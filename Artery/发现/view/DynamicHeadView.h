//
//  DynamicHeadView.h
//  Shitan
//
//  Created by Avalon on 15/5/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModelFrame.h"

@class DynamicHeadView;

@protocol DynamicHeadViewDelegate <NSObject>

@required
//头像点击事件
- (void)dynamicHeadView:(DynamicHeadView *)dynamicHeadView useId:(NSString *)useId;

@optional
//刷新关注状态
- (void)dynamicHeadView:(DynamicHeadView *)dynamicHeadView refreshdyAttentionWithUseId:(NSString *)dInfo;


@end

@interface DynamicHeadView : UIView

@property (nonatomic, strong) DynamicModelFrame *dynamicModelFrame;

@property (nonatomic, weak) id<DynamicHeadViewDelegate>delegate;

- (void)setQuality;

@end
