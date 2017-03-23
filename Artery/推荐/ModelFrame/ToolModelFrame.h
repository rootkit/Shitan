//
//  ToolModelFrame.h
//  Shitan
//
//  Created by Richard Liu on 15/8/29.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecommendInfo.h"


@interface ToolModelFrame : NSObject

@property (nonatomic, strong) RecommendInfo *mInfo;

@property (nonatomic, assign) CGRect toolsFrame;            //顶部Tools
@property (nonatomic, assign) CGRect arrowFrame;            //箭头

@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end
