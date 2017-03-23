//
//  MineButton.h
//  Shitan
//
//  Created by 刘敏 on 14-11-21.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface MineButton : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numberLabel;

// 初始化
- (id)initWithFrame:(CGRect)frame buttonWithTitle:(NSString *)title buttonwithNum:(NSString *)numS;

// 刷新
- (void)refreshMineButton:(NSString *)numS;

@end
