//
//  CompositeInfo.h
//  Shitan
//
//  Created by RichardLiu on 15/4/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopInfo.h"
#import "ItemInfo.h"

@interface CompositeInfo : NSObject

@property (nonatomic, strong) ShopInfo* sInfo;
@property (nonatomic, strong) NSArray *nameTagExts;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
