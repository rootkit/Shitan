//
//  TipInfo.h
//  Shitan
//
//  Created by 刘敏 on 14-10-20.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//  标签Model

#import <Foundation/Foundation.h>
#import "DynamicInfo.h"

@interface TipInfo : NSObject

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *imgId;        //图片ID
@property (nonatomic, strong) NSString *title;        //标签内容
@property (nonatomic, strong) NSString *tagId;        //标签ID

@property (nonatomic, assign) CGFloat point_X;        //X坐标
@property (nonatomic, assign) CGFloat point_Y;        //Y坐标

@property (nonatomic, assign) NSInteger mId;

@property (nonatomic, assign) NSInteger isLeft;       //是否在左边
@property (nonatomic, assign) MYTipsType tipType;     //标签类型

@property (nonatomic, assign) DynamicInfo *dyInfo;


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
