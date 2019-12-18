package com.xiaoyan.ui.qq;

import com.tencent.connect.common.Constants;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.UiError;
import com.xiaoyan.ui.MethodHandler;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class QQListener implements IUiListener {
    private boolean mIsLogin;

    void setLogin(boolean isLogin) {
        mIsLogin = isLogin;
    }

    @Override
    public void onComplete(Object response) {
        final Map<String, Object> rsp = new HashMap<>();
        if (mIsLogin) {
            if (response == null) {
                rsp.put("Code", 1);
                rsp.put("Message", "response is empty");
                MethodHandler.getInstance().result(rsp);
                //mResult.success(rsp);
                return;
            }
            final JSONObject jo = (JSONObject) response;
            if (jo.length() == 0) {
                rsp.put("Code", 1);
                rsp.put("Message", "response is empty");
                MethodHandler.getInstance().result(rsp);
                //mResult.success(rsp);
                return;
            }
            final Map<String, Object> resp = new HashMap<>();
            try {
                resp.put("openid", jo.getString(Constants.PARAM_OPEN_ID));
                resp.put("accessToken", jo.getString(Constants.PARAM_ACCESS_TOKEN));
                resp.put("expiresAt", jo.getLong(Constants.PARAM_EXPIRES_TIME));

                rsp.put("Code", 0);
                rsp.put("Message", "OK");
                rsp.put("Response", resp);
                MethodHandler.getInstance().result(rsp);
                //mResult.success(rsp);
                return;
            } catch (Exception e) {
                rsp.put("Code", 1);
                rsp.put("Message", e.getLocalizedMessage());
                MethodHandler.getInstance().result(rsp);
                //mResult.success(rsp);
                return;
            }
        }
        rsp.put("Code", 0);
        rsp.put("Message", response.toString());
        MethodHandler.getInstance().result(rsp);
        //mResult.success(rsp);
    }

    @Override
    public void onError(UiError uiError) {
        final Map<String, Object> response = new HashMap<>();
        response.put("Code", 1);
        response.put("Message", "errorCode:" + uiError.errorCode + ";errorMessage:" + uiError.errorMessage);
        MethodHandler.getInstance().result(response);
        //mResult.success(response);
    }

    @Override
    public void onCancel() {
        final Map<String, Object> response = new HashMap<>();
        response.put("Code", 2);
        response.put("Message", "cancel");
        MethodHandler.getInstance().result(response);
        //mResult.success(response);
    }
}
