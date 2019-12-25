//
//  MyMapVieFactory.m
//  amap_location
//
//  Created by wilson on 2019/12/24.
//

#import "MyMapViewFactory.h"
#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import "MyMapView.h"
@implementation MyMapViewFactory{
      NSObject<FlutterBinaryMessenger>*_messenger;
      FlutterMethodChannel *_channel;
}



- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager channel:(FlutterMethodChannel *)channel{
    self = [super init];
             if (self) {
                 _messenger = messager;
                 _channel = channel;
             }
             return self;
}

//设置参数的编码方式
-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

//用来创建 ios 原生view
- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {

    MyMapView *myMapView=  [[MyMapView alloc]initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger channel:_channel];
    return myMapView;
}

@end
