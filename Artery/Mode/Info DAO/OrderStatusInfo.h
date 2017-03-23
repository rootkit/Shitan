//
//  OrderStatusInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/8/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderStatusInfo : NSObject

@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString *updateTime;


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
