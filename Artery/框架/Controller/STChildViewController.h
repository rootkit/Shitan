//
//  STChildViewController.h
//  Shitan
//
//  Created by Richard Liu on 15/8/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STNavBarView.h"

@interface STChildViewController : UIViewController

@property (nonatomic, weak) STNavBarView *navbar;

// 设置导航栏在最上层
- (void)bringNavBarToTopmost;

// 是否隐藏导航栏
- (void)hideNavBar:(BOOL)bIsHide;

// 设置标题
- (void)setNavBarTitle:(NSString *)strTitle;

// 设置导航栏左按钮
- (void)setNavBarLeftBtn:(UIButton *)btn;

// 设置导航栏右按钮
- (void)setNavBarRightBtn:(UIButton *)btn;

- (void)navBarAddCoverView:(UIView *)view;
- (void)navBarAddCoverViewOnTitleView:(UIView *)view;
- (void)navBarRemoveCoverView:(UIView *)view;

// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)canDragBack;



@end
