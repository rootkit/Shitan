//
//  SpeciesInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/7/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeciesInfo : NSObject

@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *cateId;
@property (nonatomic, strong) NSString *cateName;

@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSArray *prodArray;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
