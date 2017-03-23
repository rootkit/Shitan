//
//  ResultsImageTableViewCell.h
//  Shitan
//
//  Created by RichardLiu on 15/3/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultDetailsViewController.h"
#import "ResultItemViewController.h"

@interface ResultsImageTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titLabel;
@property (nonatomic, strong) UIScrollView *coView;
@property (nonatomic, weak) ResultDetailsViewController *controller;

@property (nonatomic, weak) ResultItemViewController* itemController;

- (void)setCellWithCellInfo:(NSArray *)array isHideHead:(BOOL)isHide;

@end
