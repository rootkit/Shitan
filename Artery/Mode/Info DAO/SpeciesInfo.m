//
//  SpeciesInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/7/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "SpeciesInfo.h"
#import "ProductInfo.h"

@implementation SpeciesInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.businessId = [dict objectForKeyNotNull:@"businessId"];
    self.cateId = [dict objectForKeyNotNull:@"cateId"];
    self.cateName = [dict objectForKeyNotNull:@"cateName"];
    self.parentId = [dict objectForKeyNotNull:@"parentId"];
    
    
    //商品数组
    if([dict objectForKey:@"products"] != [NSNull null] && [[dict objectForKey:@"products"] isKindOfClass:[NSArray class]])
    {
        self.prodArray  = [self encapsulationPraiseArray:[dict objectForKey:@"products"]];
    }
    
    
    return self;
}


//商品数组
- (NSArray *)encapsulationPraiseArray:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in array) {
        ProductInfo *pInfo = [[ProductInfo alloc] initWithParsData:item];
        [tempArray addObject:pInfo];
    }
    
    return tempArray;
}


@end
