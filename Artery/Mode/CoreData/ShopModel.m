//
//  ShopModel.m
//  Shitan
//
//  Created by 刘敏 on 15/2/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ShopModel.h"
#import "DynamicMode.h"


@implementation ShopModel

@dynamic address;
@dynamic addressName;
@dynamic avgPrice;
@dynamic branchName;
@dynamic latitude;
@dynamic longitude;
@dynamic phone;
@dynamic dyInfo;



- (id)initWithParsData:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if ([dict objectForKey:@"address"] != [NSNull null])
        {
            self.address = [dict objectForKey:@"address"];
        }
        
        if ([dict objectForKey:@"addressName"] != [NSNull null]) {
            self.addressName = [dict objectForKey:@"addressName"];
        }
        
        if ([dict objectForKey:@"avgPrice"] != [NSNull null]) {
            self.avgPrice = [dict objectForKey:@"avgPrice"];
        }
        
        if ([dict objectForKey:@"branchName"] != [NSNull null]) {
            self.branchName = [dict objectForKey:@"branchName"];
            
        }
        
        if ([dict objectForKey:@"phone"] != [NSNull null]) {
            self.phone = [dict objectForKey:@"phone"];
            
        }
        
        if ([dict objectForKey:@"longitude"] != [NSNull null]) {
            self.longitude = [dict objectForKey:@"longitude"];
            
        }
        
        if ([dict objectForKey:@"latitude"] != [NSNull null]) {
            self.latitude = [dict objectForKey:@"latitude"];
            
        }
    }
    
    return self;
    
}


@end
