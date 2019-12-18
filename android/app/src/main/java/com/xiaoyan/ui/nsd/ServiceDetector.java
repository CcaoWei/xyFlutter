package com.xiaoyan.ui.nsd;

import android.content.Context;
import android.net.nsd.NsdServiceInfo;
import android.util.Log;
import android.os.Looper;
import android.os.Handler;

import com.xiaoyan.ui.EventHandler;

import java.lang.Runnable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class ServiceDetector {

    private static final String TAG = ServiceDetector.class.getSimpleName();

    private static final String SERVICE_TYPE = "_websocket._tcp";

    private boolean mIsBrowsing = false;

    private static ServiceDetector mServiceDetector;

    public static ServiceDetector getInstance() {
        if (mServiceDetector == null) {
            synchronized (ServiceDetector.class) {
                if (mServiceDetector == null) {
                    mServiceDetector = new ServiceDetector();
                }
            }
        }
        return mServiceDetector;
    }

    private HashMap<String, HomeCenter> mDiscoveredHomeCenters = new HashMap<>();

    private ServiceDetector() {}

    private Listener mListener;

    public void setListener(Listener listener) {
        mListener = listener;
    }

    public void start(Context context) {
        if (!mIsBrowsing) {
            startBrowsing(context);
            mIsBrowsing = true;
        } else {
            stopBrowsing();
            startBrowsing(context);
        }
    }

    public void stop() {
        if (mIsBrowsing) {
            stopBrowsing();
            mIsBrowsing = false;
            clearDiscoveredHomeCenters();
        }
    }

    private void clearDiscoveredHomeCenters() {
        mDiscoveredHomeCenters.clear();
    }

    private DiscoverResolver mResolver;

    private synchronized void startBrowsing(Context context) {
        if (mResolver == null) {
            mResolver = new DiscoverResolver(context, SERVICE_TYPE, new DiscoverResolver.Listener() {
                @Override
                public void onServicesChanged(Map<String, MDNSDiscover.Result> services) {
                    for (MDNSDiscover.Result result : services.values()) {
                        if (result == null) continue;
                        final String name = result.srv.getServiceName(); // home center uuid
                        final String host = result.a.ipaddr;
                        final int port = result.srv.port;
                        final Map<String, String> dict = result.txt.dict;
                        final String deviceName = dict.get("dn");
                        final String hardwareVersion = dict.get("hw");
                        final String sv = dict.get("sv");

                        final HomeCenter homeCenter = new HomeCenter(name, deviceName);
                        homeCenter.mHost = host;
                        homeCenter.mPort = port;
                        homeCenter.mVersionString = sv;

                        if (!mDiscoveredHomeCenters.containsKey(name)) {
                            EventHandler.getInstance().localServiceDidFound(homeCenter);
                            //mListener.onLocalServiceFound(homeCenter);
                            mDiscoveredHomeCenters.put(name, homeCenter);
                        }
                    }
                }

                @Override
                public void onServiceLost(NsdServiceInfo service) {
                    final String uuid = service.getServiceName();
                    if (mDiscoveredHomeCenters.containsKey(uuid)) {
                        final HomeCenter homeCenter = mDiscoveredHomeCenters.get(uuid);
                        Handler h = new Handler(Looper.getMainLooper());
                        Runnable r = new Runnable() {
                            public void run() {
                                Log.w(TAG, "to call localservicedidlost");
                                EventHandler.getInstance().localServiceDidLost(homeCenter);
                            }
                        };
                        h.post(r);
                        // new Handler(Looper.getMainLooper()).post(new Runnable() {
                        // });
                        //mListener.onLocalServiceLost(homeCenter);
                        mDiscoveredHomeCenters.remove(uuid);
                    }
                }
            });

            mResolver.start();
        } else {
            if (mIsBrowsing) {
                Log.d(TAG, "startBrowsing: Try to start browsing, but the resolver is already here and is browsing!");
            } else {
                mResolver.start();
            }
        }
    }

    private void stopBrowsing() {
        if (mResolver != null) {
            mResolver.stop();
            mResolver = null;
        }
    }

    public ArrayList<HomeCenter> discoveredServices() {
        return new ArrayList<>(mDiscoveredHomeCenters.values());
    }

    public interface Listener {
        void onLocalServiceFound(HomeCenter homeCenter);
        void onLocalServiceLost(HomeCenter homeCenter);
    }

    public class HomeCenter {
        public final String mUuid;
        public final String mName;

        public String mHost;
        public int mPort;

        public String mVersionString;

        HomeCenter(String uuid, String name) {
            mUuid = uuid;
            mName = name;
        }
    }
}
