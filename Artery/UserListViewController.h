//
//  UserListViewController.h
//  Shitan
//
//  Created by Jia HongCHI on 14-10-4.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListViewController : STChildViewController


typedef NS_ENUM(NSInteger, UserListType) {
    FansList,       // 粉丝列表
    FollowList,     // 关注列表
    PraiseList      // 赞列表
};

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//访问者与被访问者关系
@property (assign, nonatomic) UserListType userListType;

//图片列表
@property (strong, nonatomic) NSString *imageId;

//被查看者Id
@property (weak, nonatomic) NSString *respondentUserId;

@end
