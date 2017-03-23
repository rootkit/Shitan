//
//  FoodInfo.h
//  Shitan
//
//  Created by 刘敏 on 14-11-24.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodInfo : NSObject

@property (nonatomic, strong) NSString *name;       //名字
@property (nonatomic, strong) NSString *nameId;     //美食名ID
@property (nonatomic, assign) NSInteger mId;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
