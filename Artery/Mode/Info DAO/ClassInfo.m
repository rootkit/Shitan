//
//  ClassInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/8/13.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ClassInfo.h"

@implementation ClassInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.parentId = [dict objectForKeyNotNull:@"parentId"];
    self.sort = [dict objectForKeyNotNull:@"sort"];
    self.geoHash = [dict objectForKeyNotNull:@"geoHash"];
    self.cId = [dict objectForKeyNotNull:@"cid"];
    self.latitude = [dict objectForKeyNotNull:@"latitude"];
    self.longitude = [dict objectForKeyNotNull:@"longitude"];
    self.cName = [dict objectForKeyNotNull:@"cname"];
    self.icon = [dict objectForKeyNotNull:@"icon"];
    self.createTime = [dict objectForKeyNotNull:@"createTime"];

    if([dict objectForKeyNotNull:@"subClassifys"] && [[dict objectForKeyNotNull:@"subClassifys"] isKindOfClass:[NSArray class]])
    {
        self.classArray  = [self encapsulationPraiseArray:[dict objectForKey:@"subClassifys"]];
    }

    
    return self;
}



- (NSArray *)encapsulationPraiseArray:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in array) {
        ClassInfo *pInfo = [[ClassInfo alloc] initWithParsData:item];
        [tempArray addObject:pInfo];
    }
    
    return tempArray;
}


@end
