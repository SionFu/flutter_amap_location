package com.jzoom.amaplocation;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.maps2d.AMap;
import com.amap.api.maps2d.CameraUpdateFactory;
import com.amap.api.maps2d.LocationSource;
import com.amap.api.maps2d.MapView;
import com.amap.api.maps2d.model.CameraPosition;
import com.amap.api.maps2d.model.Marker;
import com.amap.api.maps2d.model.MarkerOptions;
import com.amap.api.maps2d.model.MyLocationStyle;
import com.amap.api.services.core.AMapException;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.geocoder.GeocodeResult;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.amap.api.services.geocoder.RegeocodeResult;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;

class MyMapView implements PlatformView, LocationSource, GeocodeSearch.OnGeocodeSearchListener,
        AMapLocationListener, MethodChannel.MethodCallHandler, Application.ActivityLifecycleCallbacks {

    private boolean disposed = false;
    private MapView mapView;
    private AMap aMap;
    private GeocodeSearch geocoderSearch;
    private OnLocationChangedListener mListener;
    private AMapLocationClient mlocationClient;
    private AMapLocationClientOption mLocationOption;
    private Context mContext;
    private PluginRegistry.Registrar registrar;
    private MethodChannel mapChannel;


    public MyMapView(Context context, AtomicInteger atomicInteger, PluginRegistry.Registrar registrar, int id, Map<String, Object> params) {
        this.mContext = context;
        this.registrar = registrar;
        mapChannel = new MethodChannel(registrar.messenger(), "amap_location");
        mapChannel.setMethodCallHandler(this);
        mContext = context;
        mapView = new MapView(context);
        mapView.onCreate(null);// 此方法必须重写
        init();
    }


    @Override
    public View getView() {
        return mapView;
    }


    /**
     * 初始化AMap对象
     */
    private void init() {
        if (aMap == null) {
            aMap = mapView.getMap();
            setUpMap();
        }

        registrar.activity().getApplication().registerActivityLifecycleCallbacks(this);
    }

    /**
     * 设置一些amap的属性
     */
    private void setUpMap() {
        // 自定义系统定位小蓝点
        MyLocationStyle myLocationStyle = new MyLocationStyle();
        myLocationStyle.strokeColor(Color.BLACK);// 设置圆形的边框颜色
        myLocationStyle.radiusFillColor(Color.argb(100, 0, 0, 180));// 设置圆形的填充颜色
        // myLocationStyle.anchor(int,int)//设置小蓝点的锚点
        myLocationStyle.strokeWidth(1.0f);// 设置圆形的边框粗细
        aMap.setMyLocationStyle(myLocationStyle);
        aMap.moveCamera(CameraUpdateFactory.zoomTo(18));
        aMap.setLocationSource(this);// 设置定位监听
        aMap.getUiSettings().setMyLocationButtonEnabled(true);// 设置默认定位按钮是否显示
        aMap.setMyLocationEnabled(true);// 设置为true表示显示定位层并可触发定位，false表示隐藏定位层并不可触发定位，默认是false

        aMap.setOnCameraChangeListener(new AMap.OnCameraChangeListener() {
            @Override
            public void onCameraChange(CameraPosition cameraPosition) {

            }

            @Override
            public void onCameraChangeFinish(CameraPosition cameraPosition) {


                MarkerOptions markerOption = new MarkerOptions()
                        .position(cameraPosition.target)
                        .title("22")
                        .snippet("233");
//                Marker marker = new Marker(markerOption);
//                marker.setPosition(cameraPosition.target);
                aMap.clear();
                aMap.addMarker(markerOption);

                LatLonPoint latLonPoint = new LatLonPoint(cameraPosition.target.latitude, cameraPosition.target.longitude);
                RegeocodeQuery query = new RegeocodeQuery(latLonPoint, 200, GeocodeSearch.AMAP);

                geocoderSearch.getFromLocationAsyn(query);
            }
        });
        try {
                geocoderSearch = new GeocodeSearch(mContext); 
                      } catch (Exception e) {
                   e.printStackTrace();
                      }
        
        geocoderSearch.setOnGeocodeSearchListener(this);
    }


    @Override
    public void onLocationChanged(AMapLocation amapLocation) {
        if (mListener != null && amapLocation != null) {
            if (amapLocation != null && amapLocation.getErrorCode() == 0) {
                mListener.onLocationChanged(amapLocation);// 显示系统小蓝点
                //  resultToMap(amapLocation);
            } else {
                String errText = "定位失败," + amapLocation.getErrorCode() + ": " + amapLocation.getErrorInfo();
                Log.e("AmapErr", errText);
            }
        }
    }

    private Map resultToMap(AMapLocation a) {

        Map map = new HashMap();

        if (a != null) {

            if (a.getErrorCode() != 0) {
                //错误信息

                map.put("description", a.getErrorInfo());
                map.put("success", false);

            } else {
                map.put("success", true);


                map.put("accuracy", a.getAccuracy());
                map.put("altitude", a.getAltitude());
                map.put("speed", a.getSpeed());
                map.put("timestamp", (double) a.getTime() / 1000);
                map.put("latitude", a.getLatitude());
                map.put("longitude", a.getLongitude());
                map.put("locationType", a.getLocationType());
                map.put("provider", a.getProvider());


                map.put("formattedAddress", a.getAddress());
                map.put("country", a.getCountry());
                map.put("province", a.getProvince());
                map.put("city", a.getCity());
                map.put("district", a.getDistrict());
                map.put("citycode", a.getCityCode());
                map.put("adcode", a.getAdCode());
                map.put("street", a.getStreet());
                map.put("number", a.getStreetNum());
                map.put("POIName", a.getPoiName());
                map.put("AOIName", a.getAoiName());

            }
            map.put("code", a.getErrorCode());
            Log.e("wilson", "定位获取结果:" + a.getLatitude() + " code：" + a.getErrorCode() + " 省:" + a.getProvince());

        }
        mapChannel.invokeMethod("location_info", map);
        return map;
    }

    @Override
    public void activate(OnLocationChangedListener listener) {
        mListener = listener;
        if (mlocationClient == null) {
            try {
                mlocationClient = new AMapLocationClient(mContext);  
                      } catch (Exception e) {
                   e.printStackTrace();
                      }
            mLocationOption = new AMapLocationClientOption();
            //设置定位监听
            mlocationClient.setLocationListener(this);
            //设置为高精度定位模式
            mLocationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
            //设置定位参数
            mlocationClient.setLocationOption(mLocationOption);
            // 此方法为每隔固定时间会发起一次定位请求，为了减少电量消耗或网络流量消耗，
            // 注意设置合适的定位时间的间隔（最小间隔支持为2000ms），并且在合适时间调用stopLocation()方法来取消定位请求
            // 在定位结束后，在合适的生命周期调用onDestroy()方法
            // 在单次定位情况下，定位无论成功与否，都无需调用stopLocation()方法移除请求，定位sdk内部会移除
            mlocationClient.startLocation();
        }
    }

    @Override
    public void deactivate() {
        mListener = null;
        if (mlocationClient != null) {
            mlocationClient.stopLocation();
            mlocationClient.onDestroy();
        }
        mlocationClient = null;

    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("annotation_add")) {
            result.success("clear_success");
        } else if (methodCall.method.equals("annotation_clear")) {
            result.success("clear_success");
        }
    }

    @Override
    public void dispose() {
        if (disposed) {
            return;
        }
        disposed = true;
        aMap.setOnInfoWindowClickListener(null);
        mapView.onDestroy();
        mapChannel.setMethodCallHandler(null);

        registrar.activity().getApplication().unregisterActivityLifecycleCallbacks(this);
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
        mapView.onCreate(savedInstanceState);
    }

    @Override
    public void onActivityStarted(Activity activity) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
    }

    @Override
    public void onActivityResumed(Activity activity) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
        mapView.onResume();
    }

    @Override
    public void onActivityPaused(Activity activity) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
        mapView.onPause();
    }

    @Override
    public void onActivityStopped(Activity activity) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
        mapView.onSaveInstanceState(outState);
    }

    @Override
    public void onActivityDestroyed(Activity activity) {
        if (disposed || activity.hashCode() != registrar.activity().hashCode()) {
            return;
        }
        mapView.onDestroy();
    }


    @Override
    public void onRegeocodeSearched(RegeocodeResult result, int rCode) {
        if (rCode == AMapException.CODE_AMAP_SUCCESS) {
            if (result != null && result.getRegeocodeAddress() != null
                    && result.getRegeocodeAddress().getFormatAddress() != null) {
                String addressName = result.getRegeocodeAddress().getFormatAddress() + "附近";
                LatLonPoint latLonPoint = result.getRegeocodeQuery().getPoint();
                Log.e("wilson 点击返回位置 ", addressName);
                Log.e("wilson 点击返回位置 ", latLonPoint.toString());
                resultToMapByResult(result);
            } else {
            }
        } else {
        }
    }

    @Override
    public void onGeocodeSearched(GeocodeResult geocodeResult, int i) {
        Log.e("wilson", geocodeResult.toString());
    }


    private Map resultToMapByResult(RegeocodeResult result) {
//        result.a;
//
        Map map = new HashMap();
        LatLonPoint latLonPoint = result.getRegeocodeQuery().getPoint();
        String city = result.getRegeocodeAddress().getCity();
        String addressName = result.getRegeocodeAddress().getFormatAddress();
        Log.e("wilson 点击返回位置 ", addressName);
        Log.e("wilson 点击返回位置 ", latLonPoint.toString());
        if (result != null) {
            map.put("success", true);
            map.put("formattedAddress", addressName);
            map.put("latitude", latLonPoint.getLatitude());
            map.put("longitude", latLonPoint.getLongitude());
            map.put("city", city);
        }else{
            map.put("success", false);
        }

        mapChannel.invokeMethod("location_info", map);
        return map;

    }
}
