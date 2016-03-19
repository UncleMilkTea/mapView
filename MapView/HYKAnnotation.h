//
//  HYKAnnotation.h
//  MapView
//
//  Created by 侯玉昆 on 16/3/19.
//  Copyright © 2016年 suger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HYKAnnotation : NSObject<MKAnnotation>

@property(nonatomic) CLLocationCoordinate2D coordinate;

@property(copy,nonatomic) NSString *title;

@property(copy,nonatomic) NSString *subtitle;

@end
