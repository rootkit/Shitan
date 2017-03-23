//
//  ProductInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/6/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ProductInfo.h"

@implementation ProductInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{

    self.productId  = [dict objectForKeyNotNull:@"productId"];
    
    self.price = [dict objectForKeyNotNull:@"discount"];            //折扣
    self.orPrice = [dict objectForKeyNotNull:@"price"];             //价格（原价）

    self.businessId = [dict objectForKeyNotNull:@"businessId"];
    self.cateId = [dict objectForKeyNotNull:@"cateId"];
    
    self.name = [dict objectForKeyNotNull:@"name"];
    self.des = [dict objectForKeyNotNull:@"description"];
    
    self.buyCount = [[dict objectForKeyNotNull:@"buyCount"] integerValue];
    self.sellCount = [[dict objectForKeyNotNull:@"sellCount"] integerValue];
    
    self.totalCount = [[dict objectForKeyNotNull:@"totalCount"] integerValue];

    self.hasRules = [[dict objectForKeyNotNull:@"hasRules"] boolValue];
    self.isMeal = [[dict objectForKeyNotNull:@"isMeal"] boolValue];
    
    self.h5Url = [dict objectForKeyNotNull:@"h5Url"];
    
    
    //图片地址数组
    if ([dict objectForKeyNotNull:@"imgUrl"]) {
        self.imgArray = [[dict objectForKeyNotNull:@"imgUrl"] componentsSeparatedByString:@","];
    }

    return self;
    
}

@end
