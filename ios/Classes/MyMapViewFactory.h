//
//  MyMapVieFactory.h
//  amap_location
//
//  Created by wilson on 2019/12/24.
//


#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface MyMapViewFactory :  NSObject<FlutterPlatformViewFactory>


- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager channel:(FlutterMethodChannel *)channel;
@end

NS_ASSUME_NONNULL_END
