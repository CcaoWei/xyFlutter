package com.xiaoyan.ui;

import android.app.DownloadManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.support.v4.content.FileProvider;
import android.util.Log;

import java.io.File;
//管理升级
public class ApkDownloadManager {
    private static final String TAG = "ApkDownloadManager";

    private static ApkDownloadManager mInstance;

    private ApkDownloadManager() {}

    public static ApkDownloadManager getInstance() {
        if (mInstance == null) {
            mInstance = new ApkDownloadManager();
        }
        return mInstance;
    }

    public void download(Context context, String url, String title, String description, final String appName) {
        Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
        context.startActivity(browserIntent);
        return;
        // final SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(context);
        // long downloadId = sp.getLong(DownloadManager.EXTRA_DOWNLOAD_ID, -1L);
        // if (downloadId != -1L) {
        //    final int status = getDownloadStatus(context, downloadId);
        //    if (status == DownloadManager.STATUS_SUCCESSFUL) {
        //        final Uri uri = getDownloadUri(context, downloadId);
        //        if (uri != null) {
        //            final String path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getAbsolutePath() + "/" + appName;
        //            if (compare(context, getApkInfo(context, path))) {
        //                install(context, appName);
        //            } else {
        //                final DownloadManager manager = (DownloadManager) context.getSystemService(Context.DOWNLOAD_SERVICE);
        //                if (manager != null) {
        //                    manager.remove(downloadId);
        //                    start(context, url, title, description, appName);
        //                }

        //            }
        //        } else {
        //            start(context, url, title, description, appName);
        //        }
        //    } else if (status == DownloadManager.STATUS_FAILED) {
        //        start(context, url, title, description, appName);
        //    } else {
        //        start(context, url, title, description, appName);
        //    }
        // } else {
        //     start(context, url, title, description, appName);
        // }
    }

    private void start(Context context, String url, String title, String description, String appName) {
        final long id = downloadNewApp(context, url, title, description, appName);
        final SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(context);
        final SharedPreferences.Editor editor = sp.edit();
        editor.putLong(DownloadManager.EXTRA_DOWNLOAD_ID, id);
        editor.putString("appName", appName);
        editor.apply();
    }

    private int getDownloadStatus(Context context, long downloadId) {
        final DownloadManager manager = (DownloadManager) context.getSystemService(Context.DOWNLOAD_SERVICE);
        final DownloadManager.Query query = new DownloadManager.Query().setFilterById(downloadId);
        if (manager != null) {
            final Cursor cursor = manager.query(query);
            if (cursor != null) {
                try {
                    if (cursor.moveToFirst()) {
                        return cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_STATUS));
                    }
                } finally {
                    cursor.close();
                }
            }
        }
        return -1;
    }

    private long downloadNewApp(Context context, String url, String title, String description, String appName) {
        final DownloadManager manager = (DownloadManager) context.getSystemService(Context.DOWNLOAD_SERVICE);
        if (manager != null) {
            final DownloadManager.Request request = new DownloadManager.Request(Uri.parse(url));
            request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE);
            request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, appName);
            request.setTitle(title);
            request.setDescription(description);
            return manager.enqueue(request);
        }
        return -1;
    }

    private Uri getDownloadUri(Context context, long downloadId) {
        final DownloadManager manager = (DownloadManager) context.getSystemService(Context.DOWNLOAD_SERVICE);
        if (manager != null) {
            return manager.getUriForDownloadedFile(downloadId);
        }
        return null;
    }

    private boolean compare(Context context, PackageInfo apkInfo) {
        if (apkInfo == null) return false;
        final String localPackage = context.getPackageName();
        if (apkInfo.packageName.equals(localPackage)) {
            try {
                final PackageInfo packageInfo = context.getPackageManager().getPackageInfo(localPackage, 0);
                if (apkInfo.versionCode > packageInfo.versionCode) return true;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    private PackageInfo getApkInfo(Context context, String path) {
        final PackageManager packageManager = context.getPackageManager();
        return packageManager.getPackageArchiveInfo(path, PackageManager.GET_ACTIVITIES);
    }

    private void install(Context context, String appName) {
        final Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        final File file = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getAbsolutePath(), appName);
        if (Build.VERSION.SDK_INT >= 24) {
            intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            final Uri contentUri = FileProvider.getUriForFile(context, "com.xiaoyan.ui.fileprovider", file);
            intent.setDataAndType(contentUri, "application/vnd.android.package-archive");
        } else {
            intent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive");
        }
        context.startActivity(intent);
    }
}
