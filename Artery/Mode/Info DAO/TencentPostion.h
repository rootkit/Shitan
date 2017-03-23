//
//  TencentPostion.h
//  Shitan
//
//  Created by RichardLiu on 15/3/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TencentPostion : NSObject

@property (nonatomic, strong) NSString *address;        //详细地址
@property (nonatomic, strong) NSString *title;          //标题

@property (nonatomic, strong) NSString *nation;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;


@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
