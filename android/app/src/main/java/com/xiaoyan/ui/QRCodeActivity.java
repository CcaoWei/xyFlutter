package com.xiaoyan.ui;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.view.ViewCompat;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;

import cn.bingoogolapple.qrcode.core.QRCodeView;
import cn.bingoogolapple.qrcode.zxing.ZXingView;

public class QRCodeActivity extends Activity implements QRCodeView.Delegate {

    public static final String EXTRA_RESULT = "extra_result";
    public static final String SCAN_TYPE = "scan_type";
    public static final String TITLE = "title";

    public static final int SCAN_TO_SHARE = 1;
    public static final int SCAN_TO_REQUEST = 2;

    private ZXingView mRequestView;
    private ZXingView mShareView;

    private ImageView mBackButton;
    private TextView mTitle;

    private int mScanType;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_NO_TITLE);

        setContentView(R.layout.activity_qrcode_scan);
        setStatusColor();

        mRequestView = findViewById(R.id.qrcode_scan_request);
        mShareView = findViewById(R.id.qrcode_scan_share);
        mTitle = findViewById(R.id.title);
        mBackButton = findViewById(R.id.back_button);

        final Intent intent = getIntent();
        mScanType = intent.getIntExtra(SCAN_TYPE, 2);
        if (mScanType == SCAN_TO_REQUEST) {
            mRequestView.setDelegate(this);
            mRequestView.setVisibility(View.VISIBLE);
            mShareView.setVisibility(View.GONE);
        } else if (mScanType == SCAN_TO_SHARE) {
            mShareView.setDelegate(this);
            mShareView.setVisibility(View.VISIBLE);
            mRequestView.setVisibility(View.GONE);
        }

        final String title = intent.getStringExtra(TITLE);
        mTitle.setText(title);

        mBackButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (v != null) {
                    onPause();
                    finish();
                }
            }
        });
    }

    private void setStatusColor() {
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP) {
            final Window window = getWindow();
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(Color.GRAY);
            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE);
            final ViewGroup contentView = window.findViewById(Window.ID_ANDROID_CONTENT);
            final View childView = contentView.getChildAt(0);
            if (childView != null) {
                ViewCompat.setFitsSystemWindows(childView, false);
                ViewCompat.requestApplyInsets(childView);
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mScanType == SCAN_TO_REQUEST) {
            mRequestView.startCamera();
            mRequestView.showScanRect();
            mRequestView.startSpot();
        } else if (mScanType == SCAN_TO_SHARE) {
            mShareView.startCamera();
            mShareView.showScanRect();
            mShareView.startSpot();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (mScanType == SCAN_TO_REQUEST) {
            mRequestView.stopSpot();
            mRequestView.stopCamera();
        } else if (mScanType == SCAN_TO_SHARE) {
            mShareView.stopSpot();
            mShareView.stopCamera();
        }
    }

    @Override
    public void onScanQRCodeSuccess(String result) {
        if (mScanType == SCAN_TO_SHARE) {
            mShareView.stopSpot();
            mShareView.startSpot();
        } else {
            mRequestView.stopSpot();
            mRequestView.startSpot();
        }
        Log.e("SCAN", "result -> " + result);
        final Intent intent = new Intent();
        intent.putExtra(EXTRA_RESULT, result);
        setResult(Activity.RESULT_OK, intent);
        finish();
    }

    @Override
    public void onScanQRCodeOpenCameraError() {
        Log.e("ERROR", "open camera error");
    }
}
