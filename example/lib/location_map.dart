import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationMap extends StatefulWidget {
  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  @override
  Widget build(BuildContext context) {
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
      ),
      body: Container(
        child: Center(
          child: mapView,
        ),
      ),
    );
  }
}
