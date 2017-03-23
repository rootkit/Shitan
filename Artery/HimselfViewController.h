//
//  HimselfViewController.h
//  Shitan
//
//  Created by 刘敏 on 14/12/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STHomeViewController.h"
#import "PersonalInfo.h"
#import "UserRelationshipDAO.h"

@interface HimselfViewController : STChildViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//图片列表视图
@property (weak, nonatomic) IBOutlet UITableView *picTableView;
//收藏列表视图
@property (weak, nonatomic) IBOutlet UICollectionView *favCollectionView;

@property (weak, nonatomic) IBOutlet UIView *btnView;
//图片列表视图点击按钮
@property (weak, nonatomic) IBOutlet UIButton *picListButton;
//收藏列表视图点击按钮
@property (weak, nonatomic) IBOutlet UIButton *favoriteListButton;
//下方展现视图
@property (weak, nonatomic) IBOutlet UIView *displayView;

//被访者userId
@property (weak, nonatomic) NSString *respondentUserId;

@property (nonatomic, strong) PersonalInfo *perInfo;


@property (nonatomic, strong) UserRelationshipDAO *userDao;

//（中间菜单）距离顶部的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHight;
// 美食日记菜单宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foodMenuWidth;
// 收藏菜单宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favMenuWidth;

//底部显示区域的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *displayViewHight;
//底部显示区域距离顶部的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *displayIntervalTopHight;

//收藏列表的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favoriteListViewHeight;


//表格的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picListViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picListViewWidth;


- (IBAction)picListButonTouch:(id)sender;
- (IBAction)favoriteListButtonTouch:(id)sender;

//打开粉丝列表
- (void)openFansList;

//打开关注列表
- (void)openAttentionList;


- (void)changeInterfaceHeight:(CGFloat )topViewHight;

@end
