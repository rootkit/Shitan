//
//  ProfileTableViewController.h
//  Shitan
//
//  Created by Avalon on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STHomeViewController.h"
#import "JSBadgeView.h"
#import "PersonalInfo.h"
#import "UserRelationshipDAO.h"

@interface ProfileTableViewController : STHomeViewController

//是否从Tab进入，控制左上角和右上角设置按钮
@property (assign) BOOL isFromTabbar;

@property (nonatomic, weak) UITableView *settingTabelView;


//编辑个人资料
- (void)editorButonTouch;

//打开粉丝列表
- (void)openFansList;

//打开关注列表
- (void)openAttentionList;


@end
