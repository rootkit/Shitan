//
//  UserTableViewCell.m
//  Shitan
//
//  Created by 刘敏 on 14-11-15.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "UserTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation UserTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    _followButton = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width-68, 14, 53, 25)];
    [_followButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_followButton addTarget:self action:@selector(followButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_followButton];
}


// 赋值（粉丝、关注）
- (void)setCellWithRelationshipCellInfo:(PersonalInfo *)dInfo setRow:(NSInteger)row isFocus:(BOOL)isFocus;
{
    CLog(@"%@", [AccountInfo sharedAccountInfo].userId);
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:dInfo.portraiturl] placeholderImage:[UIImage imageNamed:@"head_default.png"]];
    
    [_headView.layer setCornerRadius:CGRectGetHeight([_headView bounds]) / 2];
    _headView.layer.masksToBounds = YES;
    
    
    if (dInfo.userType == Acc_STBB) {
        //食探标识
        UIImageView *bageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_st.png"]];
        [bageV setFrame:CGRectMake(35, 29, 15, 15)];
        [self.contentView addSubview:bageV];
    }

    
    [_nickName setText:dInfo.nickname];
    
    UIImage *image = nil;
    
    //粉丝
    if (!isFocus) {
        if ([dInfo.followerUserId isEqualToString:[AccountInfo sharedAccountInfo].userId] ||
            [dInfo.userId isEqualToString:[AccountInfo sharedAccountInfo].userId]){
            [_followButton setHidden:YES];
        }
        else{
            [_followButton setHidden:NO];
            
            if (dInfo.hasFollow == 1) {
                image =[UIImage imageNamed:@"bg_btn_userlist_followed.png"];
                [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
                [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            }
            else{
                image = [UIImage imageNamed:@"bg_btn_userlist_follow.png"];
                [_followButton setTitle:@"关注" forState:UIControlStateNormal];
                [_followButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            }
            
            [_followButton setBackgroundImage:image forState:UIControlStateNormal];
            
            _followButton.tag = row;

        }
    }
    else
    {
        //关注
        if ([dInfo.followedUserId isEqualToString:[AccountInfo sharedAccountInfo].userId]) {
            [_followButton setHidden:YES];
        }
        else
        {
            [_followButton setHidden:NO];
            
            if (dInfo.hasFollow == 1) {
                image =[UIImage imageNamed:@"bg_btn_userlist_followed.png"];
                [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
                [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else{
                image =[UIImage imageNamed:@"bg_btn_userlist_follow.png"];
                [_followButton setTitle:@"关注" forState:UIControlStateNormal];
                [_followButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            }
            
            [_followButton setBackgroundImage:image forState:UIControlStateNormal];
            
            _followButton.tag = row;
        }
    }
}



- (void)setCellWithRelationshipCellInfo:(PersonalInfo *)dInfo setRow:(NSInteger)row
{
    CLog(@"%@", [AccountInfo sharedAccountInfo].userId);
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:dInfo.portraiturl] placeholderImage:[UIImage imageNamed:@"head_default.png"]];
    
    [_headView.layer setCornerRadius:CGRectGetHeight([_headView bounds]) / 2];
    _headView.layer.masksToBounds = YES;
    
    [_nickName setText:dInfo.nickname];
    
    if (dInfo.userType == Acc_STBB) {
        //食探标识
        UIImageView *bageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_st.png"]];
        [bageV setFrame:CGRectMake(35, 29, 15, 15)];
        [self.contentView addSubview:bageV];
    }
    
    UIImage *image = nil;
    

    if ([dInfo.userId isEqualToString:[AccountInfo sharedAccountInfo].userId]){
        [_followButton setHidden:YES];
    }
    else{
        [_followButton setHidden:NO];
        
        if (dInfo.hasFollow == 1) {
            image =[UIImage imageNamed:@"bg_btn_userlist_followed.png"];
            [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
            [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }
        else{
            image =[UIImage imageNamed:@"bg_btn_userlist_follow.png"];
            [_followButton setTitle:@"关注" forState:UIControlStateNormal];
            [_followButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        }
        
        [_followButton setBackgroundImage:image forState:UIControlStateNormal];
        
        _followButton.tag = row;
    }
}




// 赋值 （weibo）
- (void)setCellWithRelationshipWeiboCellInfo:(PersonalInfo *)dInfo setRow:(NSInteger)row
{
    CLog(@"%@", [AccountInfo sharedAccountInfo].userId);
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:dInfo.portraiturl] placeholderImage:[UIImage imageNamed:@"head_default.png"]];
    
    [_headView.layer setCornerRadius:CGRectGetHeight([_headView bounds]) / 2];
    _headView.layer.masksToBounds = YES;
    
    [_nickName setText:dInfo.nickname];
    
    if (dInfo.userType == Acc_STBB) {
        //食探标识
        UIImageView *bageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_st.png"]];
        [bageV setFrame:CGRectMake(35, 29, 15, 15)];
        [self.contentView addSubview:bageV];
    }
    
    UIImage *image = nil;
    

    
    if (dInfo.hasFollow == 1) {
        image =[UIImage imageNamed:@"bg_btn_userlist_followed.png"];
        [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    else{
        image =[UIImage imageNamed:@"bg_btn_userlist_follow.png"];
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    }
    
    [_followButton setBackgroundImage:image forState:UIControlStateNormal];
    
    _followButton.tag = row;
}



- (void)followButtonTapped:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(followButtonWithCellwithRow:)]) {
        [_delegate followButtonWithCellwithRow:sender.tag];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
