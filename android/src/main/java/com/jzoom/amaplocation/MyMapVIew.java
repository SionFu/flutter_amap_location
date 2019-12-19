package com.jzoom.amaplocation;

import android.content.Context;
import android.view.View;
import android.widget.TextView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

class MyMapView implements PlatformView {

    private final TextView myNativeView;


    MyMapView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
        TextView myNativeView = new TextView(context);
        myNativeView.setText("我是来自Android的原生TextView");
        this.myNativeView = myNativeView;
    }


    @Override
    public View getView() {
        return myNativeView;
    }

    @Override
    public void dispose() {

    }
}
