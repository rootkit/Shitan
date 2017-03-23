//
//  STLoginViewController.h
//  Shitan
//
//  Created by Richard Liu on 15/9/5.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STChildViewController.h"

@interface STLoginViewController : STChildViewController

@property (nonatomic, weak) UITextField *userName;
@property (nonatomic, weak) UITextField *passWord;

@property (nonatomic, weak) UIButton *regButton;
@property (nonatomic, weak) UIButton *loginButton;
@property (nonatomic, weak) UIButton *forgetButton;

@end
