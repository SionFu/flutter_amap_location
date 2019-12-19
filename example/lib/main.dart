import 'package:amap_location_example/location_get.dart';
import 'package:amap_location_example/location_listen.dart';
import 'package:amap_location_example/location_map.dart';
import 'package:flutter/material.dart';
import 'package:amap_location/amap_location.dart';

void main() {
  runApp(new MaterialApp(
    home: new Home(),
    routes: {
      "/location/get": (BuildContext context) => new LocationGet(),
      "/location/listen": (BuildContext content) => new LocationListen(),
      "/location/map": (BuildContext content) => new LocationMap()
    },
  ));
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomeState();
  }
}

class _HomeState extends State<Home> {
  var myMap = [
    {
      "title": "直接获取定位",
      "subtitle": "不需要先启用监听就可以直接获取定位",
      "url": "/location/get"
    },
    {"title": "监听定位", "subtitle": "启动定位改变监听", "url": "/location/listen"},
    {"title": "进入地图", "subtitle": "展示地图", "url": "/location/map"}
  ];

  @override
  void initState() {
    super.initState();
    initIOS();
  }

  //初始化ios
  initIOS() {
    AMapLocationClient.setApiKey("03c4bf8bce858794df1739b475606ace");
    //启动客户端,这里设置ios端的精度小一点
    AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
  }

  @override
  void dispose() {
    //注意这里关闭
    AMapLocationClient.shutdown();
    super.dispose();
  }

  List<Widget> render(BuildContext context, List children) {
    return ListTile.divideTiles(
        context: context,
        tiles: children.map((dynamic data) {
          return buildListTile(
              context, data["title"], data["subtitle"], data["url"]);
        })).toList();
  }

  Widget buildListTile(
      BuildContext context, String title, String subtitle, String url) {
    return new ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(url);
      },
      isThreeLine: true,
      dense: false,
      leading: null,
      title: new Text(title),
      subtitle: new Text(subtitle),
      trailing: new Icon(
        Icons.arrow_right,
        color: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('高德地图定位'),
        ),
        body: new Scrollbar(
            child: new ListView(
          children: render(context, myMap),
        )));
  }
}
