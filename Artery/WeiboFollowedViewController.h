//
//  WeiboFollowedViewController.h
//  Shitan
//
//  Created by 刘敏 on 14/12/4.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//
//  微博好友（关注、邀请）


#import "STChildViewController.h"

@interface WeiboFollowedViewController : STChildViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *friendsArray;      //已经加入系统
@property (strong, nonatomic) NSMutableArray *inviteArray;       //邀请加入系统


//发送微博邀请
- (void)sendInvitationWeibo:(NSInteger )row;

@end
