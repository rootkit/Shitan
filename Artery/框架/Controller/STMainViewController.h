//
//  STMainViewController.h
//  Shitan
//
//  Created by Richard Liu on 15/8/24.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STHomeViewController.h"

@interface STMainViewController : UIViewController

//记录当前显示的控制器，用于添加手势拖拽
@property (nonatomic, weak) STHomeViewController *showViewController;


- (void)updateMenu;

- (void)jumpMessage;


@end
