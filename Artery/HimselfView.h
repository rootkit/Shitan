//
//  HimselfView.h
//  Shitan
//
//  Created by 刘敏 on 14/12/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HimselfViewController.h"


@interface HimselfView : UIView

@property (nonatomic, weak) HimselfViewController *controller;

@property (strong, nonatomic) UIButton *headButton;       //头像
@property (strong, nonatomic) UILabel  *nickLabel;
@property (strong, nonatomic) UIButton *focusButon;       //编辑个人资料
@property (strong, nonatomic) UILabel  *signatureLabel;   //个性签名

@property (strong, nonatomic) UIImageView *lineV;

@property (nonatomic, assign) BOOL hasFollow;    //是否已关注

//刷新界面
- (void)refreshOneselfView;

@end
