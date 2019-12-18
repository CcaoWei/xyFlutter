package com.xiaoyan.ui.nsd;

import android.os.Debug;
import android.text.TextUtils;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.EOFException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class MDNSDiscover {

    private static MDNSDiscover mInstance;

    private MDNSDiscover() {
    }

    public static MDNSDiscover getInstance() {
        if (mInstance == null) {
            synchronized (MDNSDiscover.class) {
                if (mInstance == null) {
                    mInstance = new MDNSDiscover();
                }
            }
        }
        return mInstance;
    }

    private static final short QTYPE_A = 0x0001;
    static final short QTYPE_PTR = 0x000c;
    static final short QTYPE_TXT = 0x0010;
    static final short QTYPE_SRV = 0x0021;

    private static final boolean DEBUG = false;

    public void hexdump(byte[] data, int offset, int length) {
        while (offset < length) {
            System.out.printf("%08x", offset);
            int origOffset = offset;
            int col;
            for (col = 0; col < 16 && offset < length; col++, offset++) {
                System.out.printf("%02x", data[offset] & 0xFF);
            }
            for (; col < 16; col++) {
                System.out.printf("   ");
            }
            System.out.print(" ");
            offset = origOffset;
            for (col = 0; col < 16 && offset < length; col++, offset++) {
                byte val = data[offset];
                char c;
                if (val >= 32 && val < 127) {
                    c = (char) val;
                } else {
                    c = '.';
                }
                System.out.printf("%c", c);
            }
            System.out.println();
        }
    }


    public static class Record {
        public String fqdn;
        public int ttl;

        public String getServiceName() {
            if (!TextUtils.isEmpty(fqdn)) {
                final String[] attrs = fqdn.split("\\.");
                if (attrs.length > 0) {
                    return attrs[0];
                }
            }
            return null;
        }

        public String getServiceType() {
            if (!TextUtils.isEmpty(fqdn)) {
                final String[] attrs = fqdn.split("\\.");
                if (attrs.length > 2) {
                    return attrs[1] + "." + attrs[2];
                }
            }
            return null;
        }
    }

    public static class A extends Record {
        public String ipaddr;
    }

    public static class SRV extends Record {
        public int priority, weight, port;

        public String target;
    }

    public static class TXT extends Record {
        public Map<String, String> dict;
    }

    public static class Result {
        public A a;
        public SRV srv;
        public TXT txt;
    }

    void decode(byte[] packet, int packetLength, Result result) throws IOException {
        final DataInputStream dis = new DataInputStream(new ByteArrayInputStream(packet, 0, packetLength));
        final short transactionID = dis.readShort();
        final short flags = dis.readShort();
        final int questions = dis.readUnsignedShort();
        final int answers = dis.readUnsignedShort();
        final int authorityRRs = dis.readUnsignedShort();
        final int additionalRRs = dis.readUnsignedShort();

        for (int i = 0; i < questions; i++) {
            final String fqdn = decodeFQDN(dis, packet, packetLength);
            final short type = dis.readShort();
            final short qclass = dis.readShort();
        }

        for (int i = 0; i < answers + authorityRRs + additionalRRs; i++) {
            final String fqdn = decodeFQDN(dis, packet, packetLength);
            final short type = dis.readShort();
            final short aclass = dis.readShort();
            if (DEBUG) System.out.printf("%s, record%n", typeString(type));
            if (DEBUG) System.out.println("Name: " + fqdn);
            final int ttl = dis.readInt();
            final int length = dis.readUnsignedShort();
            final byte[] data = new byte[length];
            dis.readFully(data);
            Record record = null;
            switch (type) {
                case QTYPE_A:
                    record = result.a = decodeA(data);
                    break;
                case QTYPE_SRV:
                    record = result.srv = decodeSRV(data, packet, packetLength);
                    break;
                case QTYPE_PTR:
                    decodePTR(data, packet, packetLength);
                    break;
                case QTYPE_TXT:
                    record = result.txt = decodeTXT(data);
                    break;
                    default:
                        if (DEBUG) hexdump(data, 0, data.length);
            }
            if (record != null) {
                record.fqdn = fqdn;
                record.ttl = ttl;
            }
        }
    }

    private static String decodeFQDN(DataInputStream dis, byte[] packet, int packetLength) throws IOException {
        final StringBuilder result = new StringBuilder();
        boolean dot = false;
        while (true) {
            int pointerHopCount = 0;
            int length;
            while (true) {
                length = dis.readUnsignedByte();
                if (length == 0) return result.toString();
                if ((length & 0xC0) == 0xc0) {
                    if ((++pointerHopCount) * 2 >= packetLength)
                        throw new IOException("cyclic empty references in domain name");
                    length &= 0x3f;
                    final int offset = (length << 8) | dis.readUnsignedByte();
                    dis = new DataInputStream(new ByteArrayInputStream(packet, offset, packetLength - offset));
                } else {
                    break;
                }
            }
            final byte[] segment = new byte[length];
            dis.readFully(segment);
            if (dot) result.append('.');
            dot = true;
            result.append(new String(segment));
            if (result.length() > packetLength)
                throw new IOException("cyclic non-empty references in domain name");
        }
    }

    private static TXT decodeTXT(byte[] data) throws IOException {
        final TXT txt = new TXT();
        txt.dict = new HashMap<>();
        final DataInputStream dis = new DataInputStream(new ByteArrayInputStream(data));
        while (true) {
            int length;
            try {
                length = dis.readUnsignedByte();
            } catch (EOFException e) {
                return txt;
            }
            final byte[] segmentBytes = new byte[length];
            dis.readFully(segmentBytes);
            final String segment = new String(segmentBytes);
            int pos = segment.indexOf('=');
            String key, value = null;
            if (pos != -1) {
                key = segment.substring(0, pos);
                value = segment.substring(pos + 1);
            } else {
                key = segment;
            }
            if (DEBUG) System.out.println(key + "=" + value);
            if (!txt.dict.containsKey(key)) {
                txt.dict.put(key, value);
            }
        }
    }

    private static A decodeA(byte[] data) throws IOException {
        if (data.length < 4)
            throw new IOException("expected 4 bytes for IPv4 addr");
        final A a = new A();
        a.ipaddr = (data[0] & 0xFF) + "." + (data[1] & 0xFF) + "." + (data[2] & 0xFF) + "." + (data[3] & 0xFF);
        if (DEBUG) System.out.println("Ipaddr: " + a.ipaddr);
        return a;
    }

    private static String decodePTR(byte[] ptrData, byte[] packet, int packetLength) throws IOException {
        final DataInputStream dis = new DataInputStream(new ByteArrayInputStream(ptrData));
        final String fqdn = decodeFQDN(dis, packet, packetLength);
        if (DEBUG) System.out.println(fqdn);
        return fqdn;
    }

    private static String typeString(short type) {
        switch (type) {
            case QTYPE_A: return "A";
            case QTYPE_PTR: return "PTR";
            case QTYPE_SRV: return "SRV";
            case QTYPE_TXT: return "TXT";
            default: return "Unknown";
        }
    }

    private static SRV decodeSRV(byte[] srvData, byte[] packetData, int packetLength) throws IOException {
        final DataInputStream dis = new DataInputStream(new ByteArrayInputStream(srvData));
        final SRV srv = new SRV();
        srv.priority = dis.readUnsignedShort();
        srv.weight = dis.readUnsignedShort();
        srv.port = dis.readUnsignedShort();
        srv.target = decodeFQDN(dis, packetData, packetLength);
        if (DEBUG) System.out.printf("Priority: %d Weight: %d Port: %d Target: %s%n", srv.priority, srv.weight, srv.port, srv.target);
        return srv;
    }
}
