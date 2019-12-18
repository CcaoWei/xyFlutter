package com.xiaoyan.ui;

import android.Manifest;
import android.app.Activity;
import android.app.DownloadManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Process;

import com.xiaoyan.ui.nsd.ServiceDetector;

import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SystemMethodHandler {
    private static final int REQUEST_CODE_SCAN_ACTIVITY = 2777;
    private static final int REQUEST_CODE_CAMERA_PERMISSION = 3777;

    private static SystemMethodHandler mHandler;

    private SystemMethodHandler() {}

    public static SystemMethodHandler getInstance() {
        if (mHandler == null) {
            mHandler = new SystemMethodHandler();
        }
        return mHandler;
    }

    public void handleGetClientId() {
        MethodHandler.getInstance().result("xy_android_buekghs3455mFG");
    }

    public void handleGetClientType() {
        MethodHandler.getInstance().result("android_");
    }

    public void handleGetPlatform() {
        MethodHandler.getInstance().result("Android");
    }

    public void handleGetSystemVersion() {
        MethodHandler.getInstance().result(Build.VERSION.SDK_INT);
    }

    public void handleGetAppVersion(Context context) {
        final PackageManager pm = context.getPackageManager();
        try {
            final PackageInfo packageInfo = pm.getPackageInfo(context.getPackageName(), 0);
            MethodHandler.getInstance().result(packageInfo.versionName);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        MethodHandler.getInstance().result("");
    }

    public void handleGetHttpAgent() {
        MethodHandler.getInstance().result(System.getProperty("http.agent"));
    }

    public void handleScanLocalService(Context context) {
        ServiceDetector.getInstance().start(context);
        MethodHandler.getInstance().result(true);
    }

    public void handleGetFoundedServices() {
        MessageHandler.getInstance().getFoundedServices();
        MethodHandler.getInstance().result(true);
    }

    public void handleDownloadApk(MethodCall call, Context context) {
        final String url = call.argument("url");
        final String title = call.argument("title");
        final String description = call.argument("description");
        final String appName = call.argument("appName");
        ApkDownloadManager.getInstance().download(context, url, title, description, appName);
        MethodHandler.getInstance().result(true);
    }

    private boolean mExecuteAfterPermissionGranted;
    private FlutterActivity mActivity;
    private Map<String, Object> mArgs; //used for ScanQRCode

    public void handleScanQRCode(MethodCall call, MethodChannel.Result result, FlutterActivity activity) {
        if (!(call.arguments instanceof Map)) return;
        mActivity = activity;
        mArgs = (Map<String, Object>) call.arguments;
        final boolean handlePermission = (boolean) mArgs.get("handlePermissions");
        mExecuteAfterPermissionGranted = (boolean) mArgs.get("executeAfterPermissionGranted");
        if (checkSelfPermission(activity, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            if (shouldShowRequestPermissionRationale(activity, Manifest.permission.CAMERA)) {
                if (handlePermission) {
                    requestPermissions(activity);
                } else {
                    setNoPermissionError();
                }
            } else {
                if (handlePermission) {
                    requestPermissions(activity);
                } else {
                    setNoPermissionError();
                }
            }
        } else {
            startView();
        }
    }

    private int checkSelfPermission(Context context, String permission) {
        if (permission != null) {
            return context.checkPermission(permission, Process.myPid(), Process.myUid());
        } else {
            throw new IllegalArgumentException("Permission is null");
        }
    }

    private void startView() {
        final Intent intent = new Intent(mActivity, QRCodeActivity.class);
        intent.putExtra(QRCodeActivity.SCAN_TYPE, (int) mArgs.get("scanType"));
        intent.putExtra(QRCodeActivity.TITLE, (String) mArgs.get("title"));
        mActivity.startActivityForResult(intent, REQUEST_CODE_SCAN_ACTIVITY);
    }

    private boolean shouldShowRequestPermissionRationale(Activity activity, String permission) {
        if (Build.VERSION.SDK_INT >= 23) {
            return activity.shouldShowRequestPermissionRationale(permission);
        }
        return false;
    }

    private void requestPermissions(FlutterActivity activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            activity.requestPermissions(new String[]{Manifest.permission.CAMERA}, REQUEST_CODE_CAMERA_PERMISSION);
        }
    }

    private void setNoPermissionError() {
        MethodHandler.getInstance().result("error");
        //result.error("permission", "you don't have the user permission to access the camera", null);
    }

    public void handleRequestPermissionResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == REQUEST_CODE_CAMERA_PERMISSION) {
            for (int i = 0; i < permissions.length; i++) {
                final String permission = permissions[i];
                final int grantResult = grantResults[i];
                if (permission.equals(Manifest.permission.CAMERA)) {
                    if (grantResult == PackageManager.PERMISSION_GRANTED) {
                        if (mExecuteAfterPermissionGranted) {
                            startView();
                        }
                    } else {
                        setNoPermissionError();
                    }
                }
            }
        }
    }

    public void handleActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            final String string = data.getStringExtra(QRCodeActivity.EXTRA_RESULT);
            MethodHandler.getInstance().result(string);
        } else {
            MethodHandler.getInstance().result(null);
            //pendingResult.success(null);
        }
    }
}
