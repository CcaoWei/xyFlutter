package com.xiaoyan.ui.wechat;

import android.util.Log;

import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendAuth;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;

public class WXResponseHandler {

    private static WXResponseHandler INSTANCE;

    private WXResponseHandler() {}

    public static WXResponseHandler getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new WXResponseHandler();
        }
        return INSTANCE;
    }

    private MethodChannel channel = null;

    private static final String errStr = "errStr";
    private static final String errCode = "errCode";
    private static final String openId = "openId";
    private static final String type = "type";

    public void setMethodChanner(MethodChannel channel) {
        this.channel = channel;
    }

    public void handleResponse(BaseResp response) {
        if (response instanceof SendAuth.Resp) {
            handleAuthResponse((SendAuth.Resp) response);
        }
    }

    private void handleAuthResponse(SendAuth.Resp response) {
        Log.e("WECHAT RESPONSE", "errCode: " + response.errCode);
        final HashMap<String, Object> map = new HashMap<>();
        map.put(WXKeys.PLATFORM, WXKeys.ANDROID);
        map.put(errCode, response.errCode);
        map.put("code", response.code);
        map.put("state", response.state);
        map.put("lang", response.lang);
        map.put("country", response.country);
        map.put(errStr, response.errStr);
        map.put(openId, response.openId);
        map.put("url", response.url);
        map.put(type, response.getType());
        map.put(WXKeys.TRANSACTION, response.transaction);
        channel.invokeMethod("onAuthResponse", map);
    }
}
