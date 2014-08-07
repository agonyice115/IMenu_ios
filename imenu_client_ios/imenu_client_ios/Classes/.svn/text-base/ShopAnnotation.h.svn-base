//
//  ShopAnnotation.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-2-24.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BMapKit.h"

@interface ShopAnnotation : NSObject <BMKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@property (nonatomic, strong) NSString *thumbUrl;
@property (nonatomic, assign) NSUInteger index;

- (id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramSubTitle;

@end
