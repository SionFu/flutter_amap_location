#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

#use_modular_headers!
#
#inhibit_all_warnings!
Pod::Spec.new do |s|
  s.name             = 'amap_location'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin to use amap location.高德地图定位组件'
  s.description      = <<-DESC
A Flutter plugin to use amap location.高德地图定位组件
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'JZoom' => 'jzoom8112@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
#  s.resource = ['Assets/*.png']
  s.dependency 'Flutter'
  s.dependency 'AMapLocation-NO-IDFA'
  s.dependency 'AMap2DMap-NO-IDFA'
  s.dependency 'AMapSearch-NO-IDFA'
#
#  s.dependency 'AMapLocation'
#  s.dependency 'AMap2DMap'
#  s.dependency 'AMapSearch'

  s.static_framework = true
#  s.use_modular_headers =true
  s.ios.deployment_target = '8.0'
end

