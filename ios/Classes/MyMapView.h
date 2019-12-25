//
//  MyMapView.h
//  amap_location
//
//  Created by wilson on 2019/12/24.
//


#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

//#import <MAMapKit/MAMapKit.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MyMapView :  NSObject<FlutterPlatformView>



-(instancetype)initWithWithFrame:(CGRect)frame
      viewIdentifier:(int64_t)viewId
           arguments:(id _Nullable)args
binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger  channel:(FlutterMethodChannel *)channel;
@end


NS_ASSUME_NONNULL_END
