//
//  InvitationTableViewCell.h
//  Shitan
//
//  Created by 刘敏 on 14/12/17.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalInfo.h"
#import "WeiboFollowedViewController.h"

@interface InvitationTableViewCell : UITableViewCell

@property (weak, nonatomic) WeiboFollowedViewController *controller;

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *invitationButton;

// 赋值（微博邀请）
- (void)setCellWithCellInfo:(PersonalInfo *)dInfo setRow:(NSInteger)row;


@end
