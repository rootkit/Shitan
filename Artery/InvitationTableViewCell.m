//
//  InvitationTableViewCell.m
//  Shitan
//
//  Created by 刘敏 on 14/12/17.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "InvitationTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation InvitationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setController:(WeiboFollowedViewController *)controller{
    _controller = controller;
}

// 赋值（微博邀请）
- (void)setCellWithCellInfo:(PersonalInfo *)dInfo setRow:(NSInteger)row
{
    CLog(@"%@", [AccountInfo sharedAccountInfo].userId);
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:dInfo.portraiturl] placeholderImage:[UIImage imageNamed:@"head_default.png"]];
    
    [_headView.layer setCornerRadius:CGRectGetHeight([_headView bounds]) / 2];
    _headView.layer.masksToBounds = YES;
    
    [_nickName setText:dInfo.nickname];
    
    [_invitationButton setTitle:@"邀请" forState:UIControlStateNormal];
    [_invitationButton setBackgroundImage:@"btn38_green.png" setSelectedBackgroundImage:@"btn29_grey.png"];
    
    [_invitationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    _invitationButton.tag = row;
    
}


- (IBAction)invitationButtonTapped:(UIButton *)sender
{
    [_controller sendInvitationWeibo:sender.tag];
    
    [_invitationButton setTitle:@"已邀请" forState:UIControlStateNormal];
    [_invitationButton setBackgroundImage:@"btn29_grey.png" setSelectedBackgroundImage:@"btn36_white_p.png"];
    
    [_invitationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


@end
