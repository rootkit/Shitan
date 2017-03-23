//
//  MenuTableViewCell.h
//  Shitan
//
//  Created by RichardLiu on 15/4/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultItemViewController.h"

@interface MenuTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;


@property (nonatomic, weak) ResultItemViewController *controller;


- (IBAction)leftBtnTapped:(id)sender;
- (IBAction)rightBtnTapped:(id)sender;

- (void)setCellWithCellName:(NSString *)tName setLeftBtn:(BOOL)status;

@end
