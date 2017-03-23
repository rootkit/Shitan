//
//  CommentCell.h
//  Shitan
//
//  Created by 刘敏 on 14-10-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListViewController.h"
#import "CommentInfo.h"
#import "EmojiConvertor.h"
#import "MLEmojiLabel.h"

@interface CommentCell : UITableViewCell

@property (nonatomic, weak) CommentListViewController *controller;

@property (weak, nonatomic) IBOutlet UIButton *headV;        //头像
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;     //时间

@property (strong, nonatomic) EmojiConvertor *emojiCon;

// 赋值
- (CGFloat)setCellWithCellInfo:(CommentInfo *)dInfo cellWithRow:(NSInteger)tag;

@end
