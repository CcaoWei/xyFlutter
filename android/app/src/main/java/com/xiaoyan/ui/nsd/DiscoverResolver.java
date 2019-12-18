package com.xiaoyan.ui.nsd;

import android.content.Context;
import android.net.nsd.NsdManager;
import android.net.nsd.NsdServiceInfo;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.MulticastSocket;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class DiscoverResolver {

    private static final String TAG = DiscoverResolver.class.getSimpleName();
    private static final int PORT = 5353;
    private static final short QTYPE_A = 0x0001;
    private static final short QTYPE_PTR = 0x000c;
    private static final short QTYPE_TEXT = 0x0010;
    private static final short QTYPE_SRV = 0x0021;

    private static final short QCLASS_INTERNET = 0x0001;
    private static final short CLASS_FLAG_UNICAST = (short) 0x8000;

    private static final String MULTICAST_GROUP_ADDRESS = "224.0.0.251";

    private static final String SERVICE_TYPE = "_websocket._tcp";

    private static final boolean DEBUG = false;

    public interface Listener {
        void onServicesChanged(Map<String, MDNSDiscover.Result> services);
        void onServiceLost(NsdServiceInfo service);
    }

    private final MapDebouncer<String, Object> mDebouncer;

    private final Context mContext;
    private final String mServiceType;
    private final HashMap<String, MDNSDiscover.Result> mServices = new HashMap<>();
    private final Handler mHandler = new Handler(Looper.getMainLooper());
    private final Listener mListener;
    private boolean mStarted;
    private boolean mTransitioning;
    private final Map<String, NsdServiceInfo> mResolveQueue = new LinkedHashMap<>();

    private MulticastSocket mReceiveSocket;
    private InetAddress mGroup;

    public DiscoverResolver(Context context, String serviceType, Listener listener) {
        this(context, serviceType, listener, 0);
    }

    public DiscoverResolver(Context context, final String serviceType, Listener listener, int debounceMillis) {
        if (context == null) throw new NullPointerException("context is null");
        if (serviceType == null) throw new NullPointerException("service type is null");
        if (listener == null) throw new NullPointerException("listener is null");

        mContext = context;
        mServiceType = serviceType;
        mListener = listener;

        try {
            mGroup = InetAddress.getByName(MULTICAST_GROUP_ADDRESS);
        } catch (UnknownHostException e) {
            e.printStackTrace();
        }

        mDebouncer = new MapDebouncer<>(debounceMillis, new MapDebouncer.Listener<String, Object>() {
            @Override
            public void put(String name, Object object) {
                if (object != null) {
                    Log.d(TAG, "add: " + name);
                    synchronized (mResolveQueue) {
                        mResolveQueue.put(name, null);
                    }
                } else {
                    Log.d(TAG, "remove: " + name);
                    synchronized (DiscoverResolver.this) {
                        synchronized (mResolveQueue) {
                            mResolveQueue.remove(name);
                        }
                        if (mStarted) {
                            if (mServices.remove(name) != null) {
                                dispatchServicesChanged();
                            }
                        }
                    }
                }
            }
        });
    }

    public synchronized void start() {
        if (mStarted) return;
        if (!mTransitioning) {
            startReceiveSocket();
            discoverServices(mServiceType, NsdManager.PROTOCOL_DNS_SD, mDiscoveryListener);
            discover(mServiceType);
            mTransitioning = true;
        }
        mStarted = true;
    }

    public synchronized void stop() {
        if (!mStarted) return;
        if (!mTransitioning) {
            stopServiceDiscovery(mDiscoveryListener);
            mTransitioning = true;
        }
        synchronized (mResolveQueue) {
            mResolveQueue.clear();
        }
        mDebouncer.clear();
        mServices.clear();
        mServicesChanged = false;
        mStarted = false;
    }

    private void startReceiveSocket() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    mReceiveSocket = new MulticastSocket(PORT);
                    mReceiveSocket.joinGroup(mGroup);

                    final byte[] buf = new byte[2048];
                    final DatagramPacket packet = new DatagramPacket(buf, buf.length);
                    MDNSDiscover.Result result = new MDNSDiscover.Result();

                    while (true) {
                        while (result.a == null || result.txt == null || result.srv == null) {
                            mReceiveSocket.receive(packet);
                            if (DEBUG) {
                                System.out.println("\n\nIncoming packet: ");
                                MDNSDiscover.getInstance().hexdump(packet.getData(), 0, packet.getLength());
                            }
                            MDNSDiscover.getInstance().decode(packet.getData(), packet.getLength(), result);
                        }

                        synchronized (DiscoverResolver.this) {
                            if (mStarted) {
                                final String serviceType = result.srv.getServiceType();
                                final String serviceName = result.srv.getServiceName();
                                if (SERVICE_TYPE.equals(serviceType)) {
                                    mServices.put(serviceName, result);
                                    dispatchServicesChanged();
                                }
                            }
                        }

                        result = new MDNSDiscover.Result();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private void stopReceiveSocket() {
        if (mReceiveSocket != null) {
            try {
                mReceiveSocket.leaveGroup(mGroup);
            } catch (IOException e) {
                e.printStackTrace();
            }
            mReceiveSocket.disconnect();
            mReceiveSocket = null;
        }
    }

    private NsdManager.DiscoveryListener mDiscoveryListener = new NsdManager.DiscoveryListener() {
        @Override
        public void onStartDiscoveryFailed(String serviceType, int errorCode) {
            Log.d(TAG, "onStartDiscoveryFailed: serviceType = [" + serviceType + "], errorCode = [" + errorCode + "]");
        }

        @Override
        public void onStopDiscoveryFailed(String serviceType, int errorCode) {
            Log.d(TAG, "onStopDiscoveryFailed: serviceType = [" + serviceType + "], errorCode = [" + errorCode + "]");
        }

        @Override
        public void onDiscoveryStarted(String serviceType) {
            Log.d(TAG, "onDiscoveryStarted: serviceType = [" + serviceType + "]");
            synchronized (DiscoverResolver.this) {
                if (!mStarted) {
                    stopServiceDiscovery(this);
                } else {
                    mTransitioning = false;
                }
            }
        }

        @Override
        public void onDiscoveryStopped(String serviceType) {
            Log.d(TAG, "onDiscoveryStopped: serviceType = [" + serviceType + "]");
            if (mStarted) {
                discoverServices(serviceType, NsdManager.PROTOCOL_DNS_SD, this);
            } else {
                mTransitioning = false;
            }
        }

        @Override
        public void onServiceFound(NsdServiceInfo serviceInfo) {
            Log.d(TAG, "onServiceFound: serviceInfo = [" + serviceInfo + "]");
            synchronized (DiscoverResolver.this) {
                if (mStarted) {
                    final String name = serviceInfo.getServiceName() + "." + serviceInfo.getServiceType() + "local";
                    mDebouncer.put(name, DUMMY);
                }
            }
        }

        @Override
        public void onServiceLost(NsdServiceInfo serviceInfo) {
            Log.d(TAG, "onServiceLost: serviceInfo = [" + serviceInfo + "]");
            synchronized (DiscoverResolver.this) {
                if (mStarted) {
                    final String name = serviceInfo.getServiceName() + "." + serviceInfo.getServiceType() + "local";
                    mDebouncer.put(name, null);
                    mListener.onServiceLost(serviceInfo);
                }
            }
        }
    };


    private Object DUMMY = new Object();

    private boolean mServicesChanged;

    private void dispatchServicesChanged() {
        if (!mStarted) return;
        if (!mServicesChanged) {
            mServicesChanged = true;
            mHandler.post(mServicesChangedRunnable);
        }
    }

    private Runnable mServicesChangedRunnable = new Runnable() {
        @Override
        public void run() {
            synchronized (DiscoverResolver.this) {
                if (mStarted && mServicesChanged) {
                    final Map<String, MDNSDiscover.Result> services = (Map) mServices.clone();
                    mListener.onServicesChanged(services);
                }
                mServicesChanged = false;
            }
        }
    };

    private void discoverServices(final String serviceType, final int protocal, final NsdManager.DiscoveryListener listener) {
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                ((NsdManager) mContext.getSystemService(Context.NSD_SERVICE)).discoverServices(serviceType, protocal, listener);
            }
        }, 100);
    }

    private void stopServiceDiscovery(NsdManager.DiscoveryListener listener) {
        ((NsdManager) mContext.getSystemService(Context.NSD_SERVICE)).stopServiceDiscovery(listener);
    }

    private byte[] queryPacket(String serviceName, int qclass, int...qtypes) throws IOException {
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        final DataOutputStream dos = new DataOutputStream(baos);
        dos.writeInt(0);
        dos.writeShort(qtypes.length);
        dos.writeShort(0);
        dos.writeShort(0);
        dos.writeShort(0);
        int fqdnPtr = -1;
        for (int qtype : qtypes) {
            if (fqdnPtr == -1) {
                fqdnPtr = dos.size();
                writeFQDN(serviceName, dos);
            } else {
                dos.write(0xC0 | (fqdnPtr >> 8));
                dos.write(fqdnPtr & 0xFF);
            }
            dos.writeShort(qtype);
            dos.writeShort(qclass);
        }
        return baos.toByteArray();
    }

    private void writeFQDN(String name, OutputStream out) throws IOException {
        for (String part : name.split("\\.")) {
            out.write(part.length());
            out.write(part.getBytes());
        }
        out.write(0);
    }

    private void discover(final String serviceType) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                MulticastSocket socket;
                try {
                    socket = new MulticastSocket(PORT);
                    final byte[] data = discoveryPacket(serviceType);
                    if (DEBUG) System.out.println("Discover packet: ");
                    if (DEBUG) MDNSDiscover.getInstance().hexdump(data, 0, data.length);
                    final DatagramPacket packet = new DatagramPacket(data, data.length, mGroup, PORT);
                    socket.setTimeToLive(255);
                    socket.joinGroup(mGroup);
                    socket.send(packet);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private byte[] discoveryPacket(String serviceType) throws IOException {
        return queryPacket(serviceType + ".local", QCLASS_INTERNET, QTYPE_PTR);
    }
}
