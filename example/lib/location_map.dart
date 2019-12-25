import 'dart:io';
import 'package:amap_location/amap_location.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';

import 'location_listen.dart';

class LocationMap extends StatefulWidget {
  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  String location = "";

  @override
  void initState() {
    super.initState();

    _checkPersmission();
//    init();
  }

//  init() {
//    AMapLocationClient.onLocationUpate.listen((AMapLocation loc) {
//
//      if (!mounted) return;
//      setState(() {
//        location = getLocationStr(loc);
//        print(location);
//      });
//    });
//  }

  void _checkPersmission() async {
    bool hasPermission =
        await SimplePermissions.checkPermission(Permission.WhenInUseLocation);
    if (!hasPermission) {
      PermissionStatus requestPermissionResult =
          await SimplePermissions.requestPermission(
              Permission.WhenInUseLocation);
      if (requestPermissionResult != PermissionStatus.authorized) {
        Alert.alert(context, title: "申请定位权限失败");
        return;
      }
    }

    AMapLocationClient.onLocationUpate.listen((AMapLocation loc) {
      if (!mounted) return;
      setState(() {
        location = getLocationStr(loc);
        print(location);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height - 3 * 56;

    Widget mapView;
    if ((Platform.isAndroid)) {
      mapView = AndroidView(
        viewType: "location_map",
        creationParams: {
          "myContent": "通过参数传入的文本内容",
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isIOS) {
      mapView = UiKitView(viewType: "location_map");
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("展示原生地图"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "确定",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: (){

            },
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
//              width: 200,
              height: height,
              child: mapView,
            ),
            Expanded(
              child: Container(),
            ),
            Container(child: Text(location))
          ],
        ),
      ),
    );
  }

  String getLocationStr(AMapLocation loc) {
    if (loc == null) {
      return "正在定位";
    }

    if (loc.isSuccess()) {
      if (loc.hasAddress()) {
        return "定位成功:\n地址:${loc.formattedAddress}";
      } else {
        return "定位成功:经纬度:${loc.latitude} ${loc.longitude}\n ";
      }
    } else {
      return "定位失败";
    }
  }
}
