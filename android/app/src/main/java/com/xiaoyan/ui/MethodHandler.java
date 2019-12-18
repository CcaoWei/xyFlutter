package com.xiaoyan.ui;

import com.xiaoyan.ui.qq.QQListener;
import com.xiaoyan.ui.qq.QQMethodHandler;
import com.xiaoyan.ui.wechat.WXApiHandler;
import com.xiaoyan.ui.wechat.WXAuthHandler;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodHandler {
    private static MethodHandler mHandler;

    private MethodHandler() {}

    public static MethodHandler getInstance() {
        if (mHandler == null) {
            mHandler = new MethodHandler();
        }
        return mHandler;
    }

    private MethodChannel mMethodChannel;
    private MethodChannel.Result mResult;

    public void result(Object obj) {
        if (mResult != null) {
            mResult.success(obj);
        }
    }

    public void setMethodChannel(MethodChannel channel, final FlutterActivity activity, final QQListener qqListener) {
        mMethodChannel = channel;
        mMethodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                mResult = result;
                if ("getClientId".equals(call.method)) {
                    SystemMethodHandler.getInstance().handleGetClientId();
                } else if ("getClientType".equals(call.method)) {
                    SystemMethodHandler.getInstance().handleGetClientType();
                } else if ("getPlatform".equals(call.method)) {
                    SystemMethodHandler.getInstance().handleGetPlatform();
                } else if ("getSystemVersion".equals(call.method)) {
                    SystemMethodHandler.getInstance().handleGetSystemVersion();
                } else if ("getAppVersion".equals(call.method)) {
                    SystemMethodHandler.getInstance().handleGetAppVersion(activity.getApplicationContext());
                } else if ("getHttpAgent".equals(call.method)) {
                    SystemMethodHandler.getInstance().handleGetHttpAgent();
                } else if ("scanQRCode".equals(call.method)) {
                    SystemMethodHandler.getInstance().handleScanQRCode(call, result, activity);
                } else if ("registerWechat".equals(call.method)) {
                    WXApiHandler.getInstance().registerApp(call, result);
                } else if ("isWechatInstalled".equals(call.method)) {
                    WXApiHandler.getInstance().checkWechatInstallation(result);
                } else if ("wechatLogin".equals(call.method)) {
                    WXAuthHandler.sendAuth(call, result);
                } else if ("registerQQ".equals(call.method)) {
                    QQMethodHandler.getInstance().handleRegisterQQ(call, activity);
                } else if ("isQQInstalled".equals(call.method)) {
                    QQMethodHandler.getInstance().handleIsQQInstalled(activity);
                } else if ("qqLogin".equals(call.method)) {
                    QQMethodHandler.getInstance().handleQQLogin(call, qqListener, activity);
                } else if ("scanLocalService".equals(call.method)) {
                    SystemMethodHandler.getInstance().handleScanLocalService(activity);
                } else if ("getFoundLocalServices".equals(call.method)) {
                    SystemMethodHandler.getInstance().handleGetFoundedServices();
                } else if ("downloadApk".equals(call.method)) {
                    SystemMethodHandler.getInstance().handleDownloadApk(call, activity);
                }
            }
        });
    }

}
