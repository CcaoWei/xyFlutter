package com.xiaoyan.ui;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.tencent.connect.common.Constants;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;

import io.flutter.plugins.GeneratedPluginRegistrant;
import com.xiaoyan.ui.qq.QQListener;
import com.xiaoyan.ui.qq.QQResponseHandler;
import com.xiaoyan.ui.wechat.WXApiHandler;
import com.xiaoyan.ui.wechat.WXResponseHandler;

public class MainActivity extends FlutterActivity {
  private static final String TAG = MainActivity.class.getSimpleName();

  private static final String METHOD_CHANNEL = "io.xiaoyan.xlive/method_channel";
  private static final String EVENT_CHANNEL = "io.xiaoyan.xlive/event_channel";
  private static final String MESSAGE_CHANNEL = "io.xiaoyan.xlive/message_channel";

  private static final int REQUEST_CODE_SCAN_ACTIVITY = 2777;
  private static final int REQUEST_CODE_CAMERA_PERMISSION = 3777;

  private QQListener mQQListener;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    mQQListener = new QQListener();

    GeneratedPluginRegistrant.registerWith(this);
    //activity = this;

    final EventChannel eventChannel = new EventChannel(getFlutterView(), EVENT_CHANNEL);
    EventHandler.getInstance().setEventChannel(eventChannel);
    final BasicMessageChannel messageChannel = new BasicMessageChannel(getFlutterView(), MESSAGE_CHANNEL, StandardMessageCodec.INSTANCE);
    MessageHandler.getInstance().setMessageChannel(messageChannel);

    final MethodChannel methodChannel = new MethodChannel(getFlutterView(), METHOD_CHANNEL);
    MethodHandler.getInstance().setMethodChannel(methodChannel, this, mQQListener);

    WXApiHandler.getInstance().setRegistrar(this.registrarFor(METHOD_CHANNEL));
    WXResponseHandler.getInstance().setMethodChanner(methodChannel);
  }

  @Override
  public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    SystemMethodHandler.getInstance().handleRequestPermissionResult(requestCode, permissions, grantResults);
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (requestCode == REQUEST_CODE_SCAN_ACTIVITY) {
      SystemMethodHandler.getInstance().handleActivityResult(requestCode, resultCode, data);
    } else if (requestCode == Constants.REQUEST_LOGIN ||
            requestCode == Constants.REQUEST_QQ_SHARE ||
            requestCode == Constants.REQUEST_QZONE_SHARE ||
            requestCode == Constants.REQUEST_APPBAR) {
      QQResponseHandler.getInstance().handleActivityResult(requestCode, resultCode, data, mQQListener);
    }
  }
}


