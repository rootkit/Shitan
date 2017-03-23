//
//  MessageCell.h
//  Shitan
//
//  Created by Jia HongCHI on 14-10-5.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"
#import "MLEmojiLabel.h"


typedef NS_ENUM(NSInteger, MsgType) {
    M_Welcome = 1,           // 初次进入食探，欢迎语
    M_WeiboFriends = 2,      // 初次进入匹配微博好友
    M_MobFriends = 3,        // 初次进入匹配手机好友
    M_ImgDelete = 4,         // 图片删除通知
    M_Follow = 5,            // 谁关注了我
    M_Praise = 6,            // 谁赞了我
    M_CommentOnImg = 7,      // 谁评论了我的图片
    M_CommentOnComment = 8,  // 谁评论了我的评论
    M_WeiboFriend = 9,       // 我的微博好友进入了食探
    M_MobFriend = 10         // 我的手机好友进入了食探
    
};

@interface MessageCell : UITableViewCell<TTTAttributedLabelDelegate>

@property (assign, nonatomic) MsgType msgType;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *targetImageView;
@property (strong, nonatomic) MLEmojiLabel *msgLabel;

- (void)setCellWithCellInfo:(MessageInfo *)mesInfo cellWithRow:(NSInteger)row;

@end
