package com.xiaoyan.ui.qq;

import android.content.Context;

import com.tencent.tauth.Tencent;
import com.xiaoyan.ui.MethodHandler;

import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class QQMethodHandler {
    private static QQMethodHandler mHandler;

    private QQMethodHandler() {}

    public static QQMethodHandler getInstance() {
        if (mHandler == null) {
            mHandler = new QQMethodHandler();
        }
        return mHandler;
    }

    private static Tencent mTencent;

    public void handleRegisterQQ(MethodCall call, Context context) {
        final Map<String, Object> args = (Map<String, Object>) call.arguments;
        final String appId = (String) args.get("appId");
        mTencent = Tencent.createInstance(appId, context);
        MethodHandler.getInstance().result(true);
    }

    public void handleIsQQInstalled(Context context) {
        MethodHandler.getInstance().result(mTencent.isQQInstalled(context));
    }

    public void handleQQLogin(MethodCall call, QQListener listener, FlutterActivity activity) {
        final Map<String, Object> args = (Map<String, Object>) call.arguments;
        final String scopes = (String) args.get("scopes");
        listener.setLogin(true);
        mTencent.login(activity, scopes == null ? "get_simple_userinfo" : scopes, listener);
    }
}
