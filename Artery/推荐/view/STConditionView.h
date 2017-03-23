//
//  STConditionView.h
//  Shitan
//
//  Created by Richard Liu on 15/8/25.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STMenuButton, STConditionView;

//选择查询按钮类型
typedef NS_ENUM(NSInteger, STConditionButtonType) {
    STConditionButtonTypeMenu           = 10,       //左菜单
    STConditionButtonTypeNew            = 11,       //最新
    STConditionButtonTypeArea           = 12,       //区域
    STConditionButtonTypePersonality    = 13,       //个性
    STConditionButtonTypeSearch         = 14        //搜索
};


@protocol STConditionViewDelegate <NSObject>

@optional

/** 点击按钮触发代理事件 */
- (void)conditionView:(STConditionView *)view didButtonClickFrom:(STConditionButtonType)index;


@end


@interface STConditionView : UIView

@property (nonatomic, weak) id <STConditionViewDelegate> delegate;


- (void)setButtonTitle:(NSString *)tit didButtonClickFrom:(STConditionButtonType)index;


@end
