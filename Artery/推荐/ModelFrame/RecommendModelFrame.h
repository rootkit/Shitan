//
//  RecommendModelFrame.h
//  Shitan
//
//  Created by Richard Liu on 15/6/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DishesInfo.h"


@interface RecommendModelFrame : NSObject

@property (nonatomic, strong) DishesInfo *dInfo;

@property (nonatomic, assign) CGRect bottomViewFrame;       //文字标题
@property (nonatomic, assign) CGRect scrollViewFrame;       //图片

@property (nonatomic, assign) CGRect dishNameFrame;         //菜名
@property (nonatomic, assign) CGRect desLabelFrame;         //文字

@property (nonatomic, assign) CGRect lineVFrame;
@property (nonatomic, assign) CGRect shadowFrame;

@property (nonatomic, assign) CGRect imageFrame;


@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end
