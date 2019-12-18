package com.xiaoyan.ui.nsd;

import android.os.Handler;
import android.os.SystemClock;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class MapDebouncer<Key, Value> {

    interface Listener<Key, Value> {
        void put(Key key, Value value);
    }

    private final int mDebouncePeriodMillis;
    private final Listener<Key, Value> mListener;

    private final Map<Key, Value> mBackingMap = new HashMap<>();
    private final Map<Key, Long> mRemovalSchedule = new HashMap<>();

    private long mNextScheduleRemoval;
    private Handler mHandler;

    MapDebouncer(int debouncePeriodMillis, Listener<Key, Value> listener) {
        if (debouncePeriodMillis < 0)
            throw new IllegalArgumentException();
        if (listener == null)
            throw new NullPointerException();
        mDebouncePeriodMillis = debouncePeriodMillis;
        mListener = listener;
    }

    void put(Key key, Value newValue) {
        if (mDebouncePeriodMillis == 0) {
            mListener.put(key, newValue);
            return;
        }

        if (mHandler == null) {
            mHandler = new Handler();
        }

        Value oldValue = mBackingMap.get(key);
        if (oldValue == null) {
            if (newValue != null) {
                immediateUpdate(key, newValue);
            }
        } else {
            if (newValue == null) {
                timedRemoval(key);
            } else if (oldValue.equals(newValue)) {
                cancelTimedRemoval(key);
            } else {
                immediateUpdate(key, newValue);
            }
        }
    }

    private void immediateUpdate(Key key, Value value) {
        cancelTimedRemoval(key);
        performUpdate(key, value);
    }

    private void cancelTimedRemoval(Key key) {
        Long scheduled = mRemovalSchedule.remove(key);

        if (scheduled != null && scheduled == mNextScheduleRemoval) {
            long newSchedule = Long.MAX_VALUE;
            for (long time : mRemovalSchedule.values()) {
                if (time < newSchedule) {
                    newSchedule = time;
                }
            }
            if (scheduled != newSchedule) {
                mHandler.removeCallbacks(mRemoveRunnable);
                if (newSchedule < Long.MAX_VALUE) {
                    mHandler.postAtTime(mRemoveRunnable, newSchedule);
                }
            }
        }
    }

    private final Runnable mRemoveRunnable = new Runnable() {
        @Override
        public void run() {
            final long currentTime = SystemClock.uptimeMillis();
            final Iterator<Map.Entry<Key, Long>> it = mRemovalSchedule.entrySet().iterator();
            long nextScheduleTime = Long.MAX_VALUE;
            while (it.hasNext()) {
                final Map.Entry<Key, Long> entry = it.next();
                long itemTime = entry.getValue();
                if (itemTime <= currentTime) {
                    final Key key = entry.getKey();
                    performUpdate(key, null);
                    it.remove();
                } else if (itemTime < nextScheduleTime) {
                    nextScheduleTime = itemTime;
                }
            }
            mNextScheduleRemoval = 0;
            if (nextScheduleTime < Long.MAX_VALUE) {
                mHandler.postAtTime(mRemoveRunnable, nextScheduleTime);
                mNextScheduleRemoval = nextScheduleTime;
            }
        }
    };

    private void performUpdate(Key key, Value value) {
        mBackingMap.put(key, value);
        mListener.put(key, value);
    }

    private void timedRemoval(Key key) {
        long removalTime = SystemClock.uptimeMillis() + mDebouncePeriodMillis;

        if (mNextScheduleRemoval == 0) {
            mNextScheduleRemoval = removalTime;
            mHandler.postAtTime(mRemoveRunnable, removalTime);
        } else if (removalTime < mNextScheduleRemoval) {
            mHandler.removeCallbacks(mRemoveRunnable);
            mNextScheduleRemoval = removalTime;
            mHandler.postAtTime(mRemoveRunnable, removalTime);
        }
        mRemovalSchedule.put(key, removalTime);
    }

    void clear() {
        mBackingMap.clear();;
        mRemovalSchedule.clear();
        if (mHandler != null) {
            mHandler.removeCallbacks(mRemoveRunnable);
        }
        mNextScheduleRemoval = 0;
    }
}
