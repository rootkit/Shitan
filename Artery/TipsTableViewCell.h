//
//  TipsTableViewCell.h
//  Shitan
//
//  Created by 刘敏 on 14/12/9.
//  Copyright (c) 2014年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicInfo.h"
#import "UserRelationshipDAO.h"
#import "ImageDAO.h"
#import "FavoriteDetailViewController.h"
#import "BubbleView.h"


@interface TipsTableViewCell : UITableViewCell<BubbleViewDelegate>

@property (nonatomic, weak) FavoriteDetailViewController *favController;

@property (strong, nonatomic) UserRelationshipDAO *dao;
@property (strong, nonatomic) ImageDAO *mDao;

@property (weak, nonatomic) IBOutlet UIButton *headV;             //头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;          //名字
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;          //时间
@property (weak, nonatomic) IBOutlet UIButton *focusButton;       //关注按钮

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;      //图片

@property (strong, nonatomic) UILabel *desLabel;                    //文字描述

@property (weak, nonatomic) IBOutlet UIView *bgroundView;

@property (nonatomic, strong) NSMutableArray *bubbleArray;          //用来存储标签数组
@property (nonatomic, assign) BOOL isShow;                          //标签是否显示

@property (strong, nonatomic) DynamicInfo *dInfo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;    //背景宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHight;     //图片高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHight;



- (void)setCellWithCellInfo:(DynamicInfo *)dInfo isShowfocusButton:(BOOL)_show;

@end

