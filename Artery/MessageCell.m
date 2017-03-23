//
//  MessageCell.m
//  Shitan
//
//  Created by Jia HongCHI on 14-10-5.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "MessageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TimeUtil.h"


@implementation MessageCell


- (void)awakeFromNib
{
    // Initialization code
    [_headImageView.layer setCornerRadius:CGRectGetHeight([_headImageView bounds]) / 2];
    _headImageView.layer.masksToBounds = YES;
    
    [_targetImageView.layer setCornerRadius:2];
    _targetImageView.layer.masksToBounds = YES;
    
    
    if (!_msgLabel) {
        _msgLabel = [[MLEmojiLabel alloc] init];
    }
    
    _msgLabel.frame = CGRectMake(58, 13, MAINSCREEN.size.width-70, 21);
    _msgLabel.font = [UIFont systemFontOfSize:14.0f];
    _msgLabel.delegate = self;
    _msgLabel.textAlignment = NSTextAlignmentLeft;
    _msgLabel.backgroundColor = [UIColor clearColor];
    _msgLabel.isNeedAtAndPoundSign = YES;
    
    [self.contentView addSubview:_msgLabel];
    

}


- (void)setCellWithCellInfo:(MessageInfo *)mesInfo cellWithRow:(NSInteger)row
{
    //去掉首尾空格
    NSString *tempString = [mesInfo.nickname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *tempExtra = mesInfo.extra;
    NSString *mesText = @"";
    
    
    if (mesInfo.userType == Acc_STBB) {
        //食探标识
        UIImageView *bageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_st.png"]];
        [bageV setFrame:CGRectMake(36, 35, 15, 15)];
        [self.contentView addSubview:bageV];
    }
    
    switch (mesInfo.messageType) {
        case 1:
        {
            _msgLabel.text = @"欢迎加入食探";
        }
            break;
            
        case 2:
            if(mesInfo.extra != nil){
                mesText = [[@"你的微博好友 " stringByAppendingString:tempExtra] stringByAppendingString:@" 在食探中"];
                _msgLabel.text = mesText;
                [_msgLabel addLinkToTransitInformation:nil withRange:NSMakeRange(7, tempExtra.length)];
            }
            break;
            
        case 3:
            if(mesInfo.extra != nil){
                mesText = [[@"你的通讯录好友 " stringByAppendingString:tempExtra] stringByAppendingString:@" 在食探中"];
                _msgLabel.text = mesText;
                [_msgLabel addLinkToTransitInformation:nil withRange:NSMakeRange(8, tempExtra.length)];
            }
            break;
            
        case 4:
        {
            _msgLabel.text = @"你的图片已经被删除";
        }
            break;
            
        case 5:
        {
            mesText = [tempString stringByAppendingString:@" 关注了你"];
            _msgLabel.text = mesText;
            [_msgLabel addLinkToTransitInformation:nil withRange:NSMakeRange(0, tempString.length)];
            
        }
            break;
            
        case 6:
        {
            mesText = [tempString stringByAppendingString:@" 赞了你"];
            _msgLabel.text = mesText;
            [_msgLabel addLinkToTransitInformation:nil withRange:NSMakeRange(0, tempString.length)];
        }
            break;
            
        case 7:
        {
            mesText = [tempString stringByAppendingString:@" 评论了你的照片"];
            _msgLabel.text = mesText;
            [_msgLabel addLinkToTransitInformation:nil withRange:NSMakeRange(0, tempString.length)];
        }
            break;
            
        case 8:
        {
            mesText = [tempString stringByAppendingString:@" 回复了你的评论"];
            _msgLabel.text = mesText;
            [_msgLabel addLinkToTransitInformation:nil withRange:NSMakeRange(0, tempString.length)];
        }
            break;
            
        case 9:
        {
            mesText = [[@"你的微博好友 " stringByAppendingString:tempExtra] stringByAppendingString:@" 加入了食探"];
            _msgLabel.text = mesText;
            [_msgLabel addLinkToTransitInformation:nil withRange:NSMakeRange(7, tempExtra.length)];
        }
            break;
            
        case 10:
        {
            mesText = [[@"你的通讯录好友 " stringByAppendingString:tempExtra] stringByAppendingString:@" 加入了食探"];
            _msgLabel.text = mesText;
            [_msgLabel addLinkToTransitInformation:nil withRange:NSMakeRange(8, tempExtra.length)];
        }
            break;
            
        default:
            break;
    }
    

    
    //时间
    _timeLabel.text = [TimeUtil getTimeStrStyle1:mesInfo.createTime];
    _timeLabel.textColor = MAIN_TIME_COLOR;
    
    
    //头像：类型为1、4 展示系统管理员头像，其他为用户头像
    if (mesInfo.messageType == M_Welcome || mesInfo.messageType == M_ImgDelete) {
        [_headImageView setImage:[UIImage imageNamed:@"icon_system_manage_header.png"]];

    }else{
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[Units headImageThumbnails:mesInfo.portraitUrl]] placeholderImage:[UIImage imageNamed:@"head_default.png"]];
    }
    
    //头像：类型为1、2、3、5、9、10无图片，其他有图片
    if (mesInfo.messageType == M_Welcome || mesInfo.messageType == M_WeiboFriends || mesInfo.messageType == M_MobFriends || mesInfo.messageType == M_Follow || mesInfo.messageType == M_WeiboFriend || mesInfo.messageType == M_MobFriend)
    {
        _targetImageView.hidden = YES;
        _targetImageView.image = nil;
    }else{
        _targetImageView.hidden = NO;
        [_targetImageView sd_setImageWithURL:[NSURL URLWithString:[Units headImageThumbnails:mesInfo.extra]] placeholderImage:[UIImage imageNamed:@"head_default.png"]];
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
