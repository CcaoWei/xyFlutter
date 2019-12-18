package com.xiaoyan.ui.wechat;

import android.text.TextUtils;

import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class WXApiHandler {
    private PluginRegistry.Registrar registrar = null;
    private IWXAPI wxApi = null;

    public void setRegistrar(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    public IWXAPI getWxApi() {
        return wxApi;
    }

    private static WXApiHandler INSTANCE;

    private WXApiHandler() {}

    public static WXApiHandler getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new WXApiHandler();
        }
        return INSTANCE;
    }

    public void registerApp(MethodCall call, MethodChannel.Result result) {
        if (!((boolean) call.argument(WXKeys.ANDROID))) {
            return;
        }
        if (wxApi != null) {
            final HashMap<String, Object> map = new HashMap<>();
            map.put(WXKeys.PLATFORM, WXKeys.ANDROID);
            map.put(WXKeys.RESULT, true);
            result.success(map);
            return;
        }
        final String appId = call.argument(WXKeys.APP_ID);
        if (TextUtils.isEmpty(appId)) {
            result.error("invalid app id", "are you sure your app id is correct? ", appId);
            return;
        }
        IWXAPI api = WXAPIFactory.createWXAPI(registrar.context().getApplicationContext(), appId, (boolean) call.argument("enableMTA"));
        boolean registered = api.registerApp(appId);
        wxApi = api;
        final HashMap<String, Object> map = new HashMap<>();
        map.put(WXKeys.PLATFORM, WXKeys.ANDROID);
        map.put(WXKeys.RESULT, registered);
        result.success(map);
    }

    public void checkWechatInstallation(MethodChannel.Result result) {
        if (wxApi == null) {
            result.error(CallResult.RESULT_API_NULL, "please config wxapi first", null);
            return;
        } else {
            result.success(wxApi.isWXAppInstalled());
        }
    }
}
