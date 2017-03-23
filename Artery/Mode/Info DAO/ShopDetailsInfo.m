//
//  ShopDetailsInfo.m
//  Shitan
//
//  Created by RichardLiu on 15/3/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ShopDetailsInfo.h"

@implementation ShopDetailsInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.address = [dict objectForKeyNotNull:@"address"];
    self.addressId = [dict objectForKeyNotNull:@"addressId"];
    self.addressName = [dict objectForKeyNotNull:@"addressName"];
    self.branchName = [dict objectForKeyNotNull:@"branchName"];
    
    self.longitude = [dict objectForKeyNotNull:@"longitude"];
    self.latitude = [dict objectForKeyNotNull:@"latitude"];
    
    
    self.coverImgId = [dict objectForKeyNotNull:@"coverImgId"];
    self.imgUrl = [dict objectForKeyNotNull:@"imgUrl"];
    
    self.imgHeight = [[dict objectForKeyNotNull:@"imgHeight"] integerValue];
    self.imgWidth = [[dict objectForKeyNotNull:@"imgWidth"] integerValue];
    
    self.isEdited = [[dict objectForKeyNotNull:@"isEdited"] boolValue];
    
    self.name = [dict objectForKeyNotNull:@"name"];
    self.nameId = [dict objectForKeyNotNull:@"nameId"];
    self.score = [[dict objectForKeyNotNull:@"score"] floatValue];
    
    return self;
}

@end
