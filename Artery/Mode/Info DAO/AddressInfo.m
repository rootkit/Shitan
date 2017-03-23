//
//  AddressInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/6/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "AddressInfo.h"

@implementation AddressInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.addressId = [dict objectForKeyNotNull:@"addressId"];
    self.city = [dict objectForKeyNotNull:@"city"];
    self.deliverName = [dict objectForKeyNotNull:@"linkMan"];
    self.province = [dict objectForKeyNotNull:@"province"];
    self.region = [dict objectForKeyNotNull:@"county"];
    self.street = [dict objectForKeyNotNull:@"street"];
    
    self.community = [dict objectForKeyNotNull:@"community"];
    
    self.mobile = [dict objectForKeyNotNull:@"mobile"];      //移动电话
    self.phone = [dict objectForKeyNotNull:@"phone"];          //固话
    
    self.zipCode = [dict objectForKeyNotNull:@"zipcode"];
    self.userId = [dict objectForKeyNotNull:@"userId"];
    
    self.mId = [[dict objectForKeyNotNull:@"id"] integerValue];
    
    self.isDefault = [[dict objectForKeyNotNull:@"isDefault"] boolValue];
    self.isFemale  = [[dict objectForKeyNotNull:@"sex"] boolValue];    //0为男性，1为女性
    
    self.latitude = [[dict objectForKeyNotNull:@"latitude"] doubleValue];
    self.longitude = [[dict objectForKeyNotNull:@"longitude"] doubleValue];
    
    return self;
}

@end
