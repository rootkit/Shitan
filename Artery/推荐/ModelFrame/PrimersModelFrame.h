//
//  PrimersModelFrame.h
//  Shitan
//
//  Created by Richard Liu on 15/8/28.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DishesInfo.h"

@interface PrimersModelFrame : NSObject

@property (nonatomic, strong) DishesInfo *dInfo;
@property (nonatomic, assign) CGRect backViewFrame;         //背景
@property (nonatomic, assign) CGRect desLabelFrame;         //文字

@property (nonatomic, assign) CGFloat rowHeight;            //cell高度


@end
