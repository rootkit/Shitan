//
//  ShopModel.h
//  Shitan
//
//  Created by 刘敏 on 15/2/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DynamicMode;

@interface ShopModel : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * addressName;
@property (nonatomic, retain) NSNumber * avgPrice;
@property (nonatomic, retain) NSString * branchName;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * phone;

@property (nonatomic, retain) DynamicMode *dyInfo;

- (id)initWithParsData:(NSDictionary *)dict;


@end
