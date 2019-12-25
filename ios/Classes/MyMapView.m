//
//  MyMapView.m
//  amap_location
//
//  Created by wilson on 2019/12/24.
//

#import "MyMapView.h"
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MyMapView ()<MAMapViewDelegate,AMapSearchDelegate>
@property (nonatomic, strong) UIButton *gpsButton;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) AMapSearchAPI *search;
@end
@implementation MyMapView {
    //FlutterIosTextLabel 创建后的标识
    int64_t _viewId;
    MAMapView *_mapView;
    MAAnnotationView *userLocationAnnotationView;
    //消息回调
    FlutterMethodChannel* _channel;
  
}


- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger channel:(FlutterMethodChannel *)channel{
    if ([super init]) {
              _channel = channel;
                        
              [AMapServices sharedServices].enableHTTPS = YES;
      
      
              _mapView  = [[MAMapView alloc] initWithFrame:self.view.frame];
              _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
              _mapView.showsUserLocation = true;
              _mapView.userTrackingMode = MAUserTrackingModeFollow;
              _mapView.zoomLevel = 18;
              _mapView.maxZoomLevel = 19;
              _mapView.minZoomLevel = 3;
              _mapView.zoomEnabled = true;
              _mapView.scrollEnabled = true;
              _mapView.delegate =self;
              _viewId = viewId;
      
      
      
              self.gpsButton = [self makeGPSButtonView];
                 self.gpsButton.center = CGPointMake(CGRectGetMidX(self.gpsButton.bounds) + 10,
                                                     self.view.bounds.size.height -  CGRectGetMidY(self.gpsButton.bounds) - 20);
                 self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
      
      
      
              self.search = [[AMapSearchAPI alloc] init];
                self.search.delegate = self;
          }
          return self;
}

- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

- (void)gpsAction {
    if(_mapView.userLocation.updating && _mapView.userLocation.location) {
        [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];
    }
}


- (nonnull UIView *)view {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];

    [view addSubview:_mapView];
    [view addSubview:self.gpsButton];
    return view;
}


/**
 *  地图移动结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    double lat=   _mapView.centerCoordinate.latitude;
     double lon =   _mapView.centerCoordinate.longitude;
    
        NSLog(@"lon %f ",lon);
        NSLog(@"lat %f ",lat);
    NSMutableArray *annotations= [NSMutableArray array];
    CLLocationCoordinate2D coordinates[1] = {{lat,lon}};
    MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
    a1.coordinate = coordinates[0];
    a1.title = @"wilson";
    [annotations addObject:a1];
    
    [_mapView removeAnnotations: self.annotations];
    [_mapView addAnnotations:annotations];
    self.annotations = annotations;
    
    [self searchReGeocodeWithCoordinate: coordinates[0]];
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];

    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    NSString *addressName =   response.regeocode.formattedAddress;
    NSString *city = response.regeocode.addressComponent.city;
    CGFloat  lat = response.regeocode.addressComponent.businessAreas[0].location.latitude;
    CGFloat  lon = response.regeocode.addressComponent.businessAreas[0].location.longitude;
    
    NSDictionary *result = @{
        @"success":@YES,
        @"formattedAddress":addressName,
        @"latitude":@(lat),
        @"longitude":@(lon),
        @"city":city
    
    };
    [_channel invokeMethod:@"location_info" arguments:result];
}

@end
