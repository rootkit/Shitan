//
//  PlaceInfo.m
//  Shitan
//
//  Created by 刘敏 on 14-9-26.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PlaceInfo.h"

@implementation PlaceInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    if ([dict objectForKey:@"id"] != [NSNull null])
    {
        self.mId = [[dict objectForKey:@"id"] integerValue];
    }
    
    if ([dict objectForKey:@"address"] != [NSNull null]) {
        self.address = [dict objectForKey:@"address"];
    }
    
    if ([dict objectForKey:@"addressId"] != [NSNull null]) {
        self.addressId = [dict objectForKey:@"addressId"];
    }
    
    if ([dict objectForKey:@"addressName"] != [NSNull null]) {
        self.addressName = [dict objectForKey:@"addressName"];
        
    }
    
    if ([dict objectForKey:@"branchName"] != [NSNull null]) {
        self.branchName = [dict objectForKey:@"branchName"];
        
    }
    
    if ([dict objectForKey:@"addressSource"] != [NSNull null]) {
        self.addressSource = [dict objectForKey:@"addressSource"];
    }
    
    
    if ([dict objectForKey:@"businessId"] != [NSNull null]) {
        self.businessId = [dict objectForKey:@"businessId"];
    }
    
    if ([dict objectForKey:@"city"] != [NSNull null]) {
        self.city = [dict objectForKey:@"city"];
    }
    
    
    if ([dict objectForKey:@"geoHash"] != [NSNull null]) {
        self.geoHash = [dict objectForKey:@"geoHash"];
    }
    
    
    if ([dict objectForKey:@"latitude"] != [NSNull null]) {
        self.latitude = [dict objectForKey:@"latitude"];
    }
    
    if ([dict objectForKey:@"longitude"] != [NSNull null]) {
        self.longitude = [dict objectForKey:@"longitude"];
    }

    
    if ([dict objectForKey:@"phone"] != [NSNull null]) {
        self.phone = [dict objectForKey:@"phone"];
    }
    
    if ([dict objectForKey:@"region"] != [NSNull null]) {
        self.region = [dict objectForKey:@"region"];
    }

    

    return self;
}

@end
