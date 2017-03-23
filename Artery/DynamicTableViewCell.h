//
//  DynamicTableViewCell.h
//  Shitan
//
//  Created by 刘敏 on 14/11/30.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicInfo.h"
#import "UserRelationshipDAO.h"
#import "ImageDAO.h"
#import "TipsDetailsViewController.h"
#import "FavoriteDetailViewController.h"
#import "ResultItemViewController.h"
#import "ImageListViewController.h"
#import "SpecialViewController.h"
#import "BubbleView.h"
#import "ShopInfo.h"
#import "PraiseInfo.h"



@interface DynamicTableViewCell : UITableViewCell<BubbleViewDelegate>

//一定要用weak， 防止出现循环引用
@property (nonatomic, weak) TipsDetailsViewController *tipsVC;
@property (nonatomic, weak) ResultItemViewController *rVC;
@property (nonatomic, weak) ImageListViewController *iVC;
@property (nonatomic, weak) SpecialViewController *sVC;

@property (strong, nonatomic) UserRelationshipDAO *dao;
@property (strong, nonatomic) ImageDAO *mDao;


@property (strong, nonatomic) UIView *bgroundView;

@property (strong, nonatomic) UIButton *headV;             //头像
@property (strong, nonatomic) UILabel *nameLabel;          //名字
@property (strong, nonatomic) UILabel *timeLabel;          //时间
@property (strong, nonatomic) UIButton *focusButton;       //关注按钮

@property (strong, nonatomic) UIImageView *picImageV;      //图片

@property (strong, nonatomic) UILabel *desLabel;                    //文字描述

@property (strong, nonatomic) UIView *bottomView;                   //底部View

@property (strong, nonatomic) UIButton *praiseButton;               //赞
@property (strong, nonatomic) UIButton *commentsButton;             //评论
@property (strong, nonatomic) UIButton *collectionButton;           //收藏
@property (strong, nonatomic) UIButton *moreButton;                 //更多

@property (strong, nonatomic) DynamicInfo *dInfo;

@property (nonatomic, strong) NSMutableArray *bubbleArray;          //用来存储标签数组
@property (nonatomic, assign) BOOL isShow;                          //标签是否显示




- (CGFloat)setCellWithCellInfo:(DynamicInfo *)dInfo isShowfocusButton:(BOOL)_show;

- (void)setQuality;

@end
