//
//  STButton.h
//  Shitan
//
//  Created by Richard Liu on 15/5/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STButton : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numberLabel;

// 初始化
- (id)initWithFrame:(CGRect)frame buttonWithTitle:(NSString *)title buttonwithNum:(NSString *)numS;

// 刷新
- (void)refreshMineButton:(NSString *)numS;

@end
