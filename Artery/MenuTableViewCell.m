//
//  MenuTableViewCell.m
//  Shitan
//
//  Created by RichardLiu on 15/4/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = NAVIGATION_BACKGROUND_COLOR;
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 16, MAINSCREEN.size.width/2, 40)];
    [_leftButton addTarget:self action:@selector(leftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateHighlighted];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateSelected];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_normal.png"] forState:UIControlStateNormal];
    [_leftButton setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [_leftButton setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.contentView addSubview:_leftButton];
    
    
    
    
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width/2, 16, MAINSCREEN.size.width/2, 40)];
    [_rightButton addTarget:self action:@selector(rightBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateHighlighted];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateSelected];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_normal.png"] forState:UIControlStateNormal];
    [_rightButton setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [_rightButton setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_rightButton setTitle:@"本店其他美食" forState:UIControlStateNormal];
    [self.contentView addSubview:_rightButton];
}


- (void)setController:(ResultItemViewController *)controller
{
    _controller = controller;
}

- (void)setCellWithCellName:(NSString *)tName setLeftBtn:(BOOL)status
{
    _leftButton.selected = status;
    _rightButton.selected = !status;
    [_leftButton setTitle:tName forState:UIControlStateNormal];
}

- (void)leftBtnTapped:(id)sender
{
    [_controller leftButton:YES];
}

- (void)rightBtnTapped:(id)sender
{
    [_controller leftButton:NO];
}

@end
