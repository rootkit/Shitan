//
//  CompositeInfo.m
//  Shitan
//
//  Created by RichardLiu on 15/4/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "CompositeInfo.h"

@implementation CompositeInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    
    //商铺信息
    if([dict objectForKey:@"addressTagExt"] != [NSNull null] && [[dict objectForKey:@"addressTagExt"] isKindOfClass:[NSDictionary class]])
    {
        self.sInfo = [[ShopInfo alloc] initWithParsData:[dict objectForKey:@"addressTagExt"]];
    }
    
    
    //单品信息
    if ([dict objectForKey:@"nameTagExts"] != [NSNull null] && [[dict objectForKey:@"nameTagExts"] isKindOfClass:[NSArray class]]) {
        self.nameTagExts = [self encapsulationItemArray:[dict objectForKey:@"nameTagExts"]];
    }
    
    return self;
}

//封装单品数组
- (NSArray *)encapsulationItemArray:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in array) {
        ItemInfo *tInfo = [[ItemInfo alloc] initWithParsData:item];
        [tempArray addObject:tInfo];
    }
    
    return tempArray;
}


@end
