//
//  ItemInfo.m
//  Shitan
//
//  Created by RichardLiu on 15/4/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ItemInfo.h"

@implementation ItemInfo


- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.category = [dict objectForKeyNotNull:@"category"];
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    self.mId = [dict objectForKeyNotNull:@"id"];
    self.name = [dict objectForKeyNotNull:@"name"];
    self.nameId = [dict objectForKeyNotNull:@"nameId"];
    self.nameImgUrl = [dict objectForKeyNotNull:@"nameImgUrl"];
    self.score = [[dict objectForKeyNotNull:@"score"] integerValue];
    
    return self;
}

@end
