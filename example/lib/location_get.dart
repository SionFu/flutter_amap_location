import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:amap_location/amap_location.dart';


class _LocationGetState extends State {
  AMapLocation _loc;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('直接获取定位'),
        ),
        body: new Center(
          child: _loc == null
              ? new Text("正在定位")
              : new Text("定位成功:${_loc.formattedAddress}"),
        ));
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
    AMapLocation loc = await AMapLocationClient.getLocation(true);
    setState(() {
      _loc = loc;
    });
  }

  @override
  void initState() {
    _checkPersmission();
    super.initState();
  }

  @override
  void dispose() {
    //这里可以停止定位
    //AMapLocationClient.stopLocation();

    super.dispose();
  }
}

class LocationGet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LocationGetState();
}