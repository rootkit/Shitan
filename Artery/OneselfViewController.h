//
//  OneselfViewController.h
//  Artery
//
//  Created by 刘敏 on 14-11-21.
//  Copyright (c) 2014年 刘 敏. All rights reserved.
//

#import "DMViewController.h"

@interface OneselfViewController : DMViewController

@property (assign) BOOL isFromTabbar;     //是否有Tabbar
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;  //整个的scrollView

//菜单
@property (strong, nonatomic) UIButton *diaryBtn;
@property (strong, nonatomic) UIButton *collectionBtn;
@property (strong, nonatomic) UIImageView *midLineV;

@property (nonatomic, assign) CGFloat topViewHight;

////displayView和picListView以及favoriteListView之间的底部间距为0的约束
//@property (weak, nonatomic) NSLayoutConstraint *displayViewVerticalSpace;
////favoriteListView高度约束
//@property (weak, nonatomic) NSLayoutConstraint *favoriteListViewHeight;

//改变界面高度
- (void)changeInterfaceHeight;

//编辑个人资料
- (void)editorButonTouch;

//打开粉丝列表
- (void)openFansList;

//打开关注列表
- (void)openAttentionList;

//我的美食日记
- (void)diaryBtnTapped;

//收集我想吃的
- (void)collectionBtnTapped;

@end
