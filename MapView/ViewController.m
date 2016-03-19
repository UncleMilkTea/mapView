//
//  ViewController.m
//  MapView
//
//  Created by 侯玉昆 on 16/3/19.
//  Copyright © 2016年 suger. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "HYKAnnotation.h"

@interface ViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
/**
 *  位置管理者
 */
@property(strong,nonatomic) CLLocationManager *locationManager;

@property(strong,nonatomic) UIButton *selectBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc]init];
    
    [_locationManager requestAlwaysAuthorization];
    
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    _mapView.mapType = MKMapTypeStandard;
    
    _mapView.delegate = self;
    //默认选中标准地图
    UIButton *defaultBtn = [self.view viewWithTag:20];
    
    defaultBtn.selected = YES;
    
}
/**
 *  地图缩放
 */
- (IBAction)biggerAndSmaller:(UIButton *)sender {
    
    NSInteger num = sender.tag == 2 ? 0.5 : 2;
    
        MKCoordinateSpan span = MKCoordinateSpanMake(_mapView.region.span.latitudeDelta*num, _mapView.region.span.longitudeDelta*num);
        
        [_mapView setRegion:MKCoordinateRegionMake(_mapView.centerCoordinate, span) animated:YES];
    }
/**
 *  回到当前位置
 */
- (IBAction)currentLoctionBtn {
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.021258, 0.016093);
    
    [_mapView setRegion:MKCoordinateRegionMake(_mapView.userLocation.location.coordinate, span) animated:YES];
    
}
- (IBAction)roadCondition:(UIButton *)sender {
    
    if(sender.selected == YES){
        sender.selected = NO;
        _mapView.showsTraffic = NO;
    }else{
        sender.selected = YES;
        _mapView.showsTraffic = YES;
    }
}
/**
 *  地图切换
 */
- (IBAction)switchMMapView:(UIButton *)sender {
    
    _selectBtn.selected = NO;
    
    sender.selected = YES;
    
    _selectBtn = sender;
   
    switch (sender.tag) {
        case 10:
            _mapView.mapType = MKMapTypeSatellite;
            break;
        case 20:
            _mapView.mapType = MKMapTypeStandard;
            break;
        case 40:
            _mapView.mapType = MKMapTypeHybrid;
            break;
    }
}

#pragma mark - 地图大头针
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//获取点击位置转换经纬度
    CGPoint loc = [touches.anyObject locationInView:_mapView];
    
    CLLocationCoordinate2D coorder = [_mapView convertPoint:loc toCoordinateFromView:_mapView];
    
    //反地理编码
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    CLLocation *loction = [[CLLocation alloc]initWithLatitude:coorder.latitude longitude:coorder.longitude];
    
    [geocoder reverseGeocodeLocation:loction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        
        if(error){
            
            NSLog(@"%@",error); return ;
        }
        
        CLPlacemark *place = [placemarks firstObject];
        
        HYKAnnotation *ann = [[HYKAnnotation alloc]init];
        
        ann.title = place.locality;
        
        ann.subtitle = place.name;
        
        ann.coordinate = coorder;
        
        [_mapView addAnnotation:ann];
        
    }];
}

#pragma mark - 获取当前位置的具体信息
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error){
            
            NSLog(@"%@",error); return ;
        }
        CLPlacemark *place = [placemarks firstObject];
        
        userLocation.title = place.locality;
        
        userLocation.subtitle = place.name;
        
    }];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    // 用户位置 可以返回空 代表大头针样式交由系统管理
    if ([annotation isKindOfClass:[MKAnnotationView class]]){
        
        return nil;
    }
    
    static NSString *identifer = @"annotation";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
    
    if (annotation == nil) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifer];
        
        
        annotationView.pinTintColor = [UIColor redColor];//大头针颜色
        
        annotationView.animatesDrop = YES;//掉落效果
        
        annotationView.canShowCallout = YES;//显示详情
        
    }
    
    return annotationView;
}

#pragma mark - 当区域改变时调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    NSLog(@"经度:%zd---纬度:%zd",_mapView.region.span.longitudeDelta,_mapView.region.span.latitudeDelta);
}


@end
