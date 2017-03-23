//
//  WGS84TOGCJ02.h
//  Shitan
//
//  Created by 刘敏 on 14/12/17.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.

//  将WGS-84转为GCJ-02(火星坐标):

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WGS84TOGCJ02 : NSObject

//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
