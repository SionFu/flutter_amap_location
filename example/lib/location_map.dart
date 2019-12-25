import 'dart:io';
import 'package:amap_location/amap_location.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';

class LocationMap extends StatefulWidget {
  final Function callBack;

  const LocationMap({Key key, this.callBack}) : super(key: key);

  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  String location = "";
  AMapLocation _loc ;
  @override
  void initState() {
    super.initState();
    _checkPersmission();
  }

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
        _loc =loc;
//        print(location);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            onPressed: () {
              if(_loc!=null){
                widget.callBack(_loc);
              }
            },
          )
        ],
      ),
      body: Container(
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            Container(
//              width: 200,
//              height: height,
              child: mapView,
            ),
//            Expanded(
//              child: Container(),
//            ),
            Container(
                padding: EdgeInsets.only(top: 20),
                width: size.width,
                height: 100,
                color: Colors.white,
                child: Text(location))
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
        return "定位成功\n:${loc.formattedAddress}";
      } else {
        return "定位成功:经纬度:${loc.latitude} ${loc.longitude}\n ";
      }
    } else {
      return "定位失败";
    }
  }
}
