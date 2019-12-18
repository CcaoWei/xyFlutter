package com.xiaoyan.ui.wechat;

import com.tencent.mm.opensdk.modelmsg.SendAuth;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class WXAuthHandler {

    public static void sendAuth(MethodCall call, MethodChannel.Result result) {
        final SendAuth.Req req = new SendAuth.Req();
        req.scope = call.argument("scope");
        req.state = call.argument("state");
        if (call.hasArgument("openId")) {
            req.openId = call.argument("openId");
        }
        result.success(WXApiHandler.getInstance().getWxApi().sendReq(req));
    }
}
