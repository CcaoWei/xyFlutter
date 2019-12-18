package com.xiaoyan.ui.qq;

import android.content.Intent;

import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;

public class QQResponseHandler {
    private static QQResponseHandler mHandler;

    private QQResponseHandler() {}

    public static QQResponseHandler getInstance() {
        if (mHandler == null) {
            mHandler = new QQResponseHandler();
        }
        return mHandler;
    }

    public void handleActivityResult(int requestCode, int resultCode, Intent data, QQListener qqListener) {
        Tencent.onActivityResultData(requestCode, resultCode, data, qqListener);
    }
}
