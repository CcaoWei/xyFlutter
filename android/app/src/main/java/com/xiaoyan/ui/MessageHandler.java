package com.xiaoyan.ui;

import com.xiaoyan.ui.nsd.ServiceDetector;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.BasicMessageChannel;

public class MessageHandler {

    private static MessageHandler mInstance;

    private static final String LOCAL_SERVICE = "localService";

    private MessageHandler() {}

    public static MessageHandler getInstance() {
        if (mInstance == null) {
            mInstance = new MessageHandler();
        }
        return mInstance;
    }

    BasicMessageChannel mMessageChannel;

    void setMessageChannel(BasicMessageChannel channel) {
        mMessageChannel = channel;
    }

    public void getFoundedServices() {
        final ArrayList<ServiceDetector.HomeCenter> services = ServiceDetector.getInstance().discoveredServices();
        for (ServiceDetector.HomeCenter homeCenter : services) {
            final HashMap<String, Object> args = new HashMap<>();
            args.put("type", LOCAL_SERVICE);
            args.put("uuid", homeCenter.mUuid);
            args.put("name", homeCenter.mName);
            args.put("ip", homeCenter.mHost);
            mMessageChannel.send(args);
        }
    }
}
