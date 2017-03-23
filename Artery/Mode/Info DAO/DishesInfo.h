//
//  DishesInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/6/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishesInfo : NSObject

@property (nonatomic, strong) NSString *foodId;
@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *foodName;
@property (nonatomic, strong) NSString *foodDesc;

@property (nonatomic, assign) BOOL isSquare;

@property (nonatomic, assign) NSUInteger foodType;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
