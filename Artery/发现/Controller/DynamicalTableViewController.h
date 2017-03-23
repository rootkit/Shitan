//
//  DynamicalTableViewController.h
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//  动态

#import "STBaseHomeTableViewController.h"
#import "FoundViewController.h"


@interface DynamicalTableViewController : STBaseHomeTableViewController

@property (nonatomic, weak) FoundViewController *twitterVC;

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSString *cityN;

//筛选条件
@property (nonatomic, strong)  NSString *scopeN;        //范围
@property (nonatomic, assign)  NSUInteger categoryN;     //类别

// 获取同城动态
- (void)requestEssenceImagesList;

// 获取关注的好友图片（10张）
- (void)getMyFriendImgs;

//滚动到顶部
- (void)scrollToTheTop;


@end
