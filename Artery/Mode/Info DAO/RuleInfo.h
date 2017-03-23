//
//  RuleInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/8/1.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuleInfo : NSObject

@property (nonatomic, strong) NSString *ruleId;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *productId;

@property (nonatomic, assign) NSUInteger num;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSArray *rulesArray;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
