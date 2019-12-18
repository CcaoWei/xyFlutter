package com.xiaoyan.ui;

import android.util.Log;

import com.xiaoyan.ui.nsd.ServiceDetector;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
//事件
public class EventHandler implements EventChannel.StreamHandler{

    private static final String TAG = EventHandler.class.getSimpleName();

    private static final int LOCAL_SERVICE_FOUND = 0x3001;
    private static final int LOCAL_SERVICE_LOST = 0x3002;

    private static EventHandler mHandler;

    private EventHandler() {}

    public static EventHandler getInstance() {
        if (mHandler == null) {
            mHandler = new EventHandler();
        }
        return mHandler;
    }

    EventChannel mEventChannel;
    EventChannel.EventSink mEventSink;

    void setEventChannel(EventChannel channel) {
        mEventChannel = channel;
        mEventChannel.setStreamHandler(this);
    }

    @Override
    public void onListen(Object o, final EventChannel.EventSink eventSink) {
        mEventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        ServiceDetector.getInstance().setListener(null);
    }

    public void localServiceDidFound(ServiceDetector.HomeCenter homeCenter) {
        Log.e(TAG, "localServiceDidFound: ************ found");
        final HashMap<String, Object> args = new HashMap<>();
        args.put("eventType", LOCAL_SERVICE_FOUND);
        args.put("uuid", homeCenter.mUuid);
        args.put("name", homeCenter.mName);
        args.put("ip", homeCenter.mHost);
        args.put("versionString", homeCenter.mVersionString);
        mEventSink.success(args);
    }

    public void localServiceDidLost(ServiceDetector.HomeCenter homeCenter) {
        Log.e(TAG, "localServiceDidLost: ************ removed");
        final HashMap<String, Object> args = new HashMap<>();
        args.put("eventType", LOCAL_SERVICE_LOST);
        args.put("uuid", homeCenter.mUuid);
        mEventSink.success(args);
    }
}
