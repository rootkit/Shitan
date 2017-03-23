//
//  DishesInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/6/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "DishesInfo.h"

@implementation DishesInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.foodId = [dict objectForKeyNotNull:@"foodId"];
    self.businessId = [dict objectForKeyNotNull:@"businessId"];
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    self.imgUrl = [dict objectForKeyNotNull:@"imgUrl"];
    self.foodName = [dict objectForKeyNotNull:@"foodName"];
    self.foodDesc = [dict objectForKeyNotNull:@"foodDesc"];
    
    self.foodType = [[dict objectForKeyNotNull:@"foodType"] integerValue];
    //是否是正方形（NO为长方形）
    self.isSquare = [[dict objectForKeyNotNull:@"isSquare"] boolValue];
    
    return self;
}

@end
