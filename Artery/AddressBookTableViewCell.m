//
//  AddressBookTableViewCell.m
//  Shitan
//
//  Created by 刘敏 on 14-11-20.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "AddressBookTableViewCell.h"

@implementation AddressBookTableViewCell


- (void)setCellContent:(ContactInfo *)cInfo
          setIndexPath:(NSIndexPath *)indexPath
{
    
    _followButton.layer.cornerRadius = 3;//设置那个圆角的有多圆
    _followButton.layer.masksToBounds = YES;//设为NO去试试
    
    _followButton.tag = indexPath.row;
    
    
    
    if (cInfo.hasExistSystem) {
        //关注或者已关注
        if(cInfo.hasFollow)
        {
            [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
            [_followButton setBackgroundImage:@"bg_btn_userlist_followed.png" setSelectedBackgroundImage:@"btn29_grey.png"];

        }
        else{
            [_followButton setTitle:@"关注" forState:UIControlStateNormal];
            [_followButton setBackgroundImage:@"btn38_red.png" setSelectedBackgroundImage:@"btn38_grey.png"];
        }
        
        _nickName.text = [NSString stringWithFormat:@"%@(%@)", cInfo.nickName, cInfo.contactName];
    }
    else{
        [_followButton setTitle:@"邀请" forState:UIControlStateNormal];
        [_followButton setBackgroundImage:@"btn38_green.png" setSelectedBackgroundImage:@"btn29_grey.png"];
        _nickName.text = cInfo.contactName;

    }
    
    [_followButton addTarget:self action:@selector(followButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}


//关注或者已经关注
- (void)followButtonTapped:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(followButtonWithCell:)]) {
        [_delegate followButtonWithCell:sender.tag];
    }
}


@end
