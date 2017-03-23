//
//  CommentCell.m
//  Shitan
//
//  Created by 刘敏 on 14-10-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CommentCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "TimeUtil.h"
#import "MLEmojiLabel.h"


@interface CommentCell ()<MLEmojiLabelDelegate, TTTAttributedLabelDelegate>

@property (strong, nonatomic) MLEmojiLabel *desLabel;
@property (strong, nonatomic) MLEmojiLabel *nameLabel;

@property (strong, nonatomic) NSString *useID;        //存储头像者ID
@property (strong, nonatomic) NSString *commentId;    //存储评论ID（父评论ID）


@end

@implementation CommentCell

- (void)awakeFromNib
{
    // Initialization code
    _emojiCon = [[EmojiConvertor alloc] init];
    
    _desLabel = [[MLEmojiLabel alloc] init];
    _desLabel.numberOfLines = 0;
    _desLabel.font = [UIFont systemFontOfSize:14.0f];
    _desLabel.delegate = self;
    _desLabel.textAlignment = NSTextAlignmentLeft;
    _desLabel.backgroundColor = [UIColor clearColor];
    _desLabel.isNeedAtAndPoundSign = YES;
    _desLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _desLabel.customEmojiPlistName = @"expression";
    
    [self.desLabel setTextColor:MAIN_TEXT_COLOR];
    [self.contentView addSubview:self.desLabel];
    
    _nameLabel = [[MLEmojiLabel alloc] init];
    _nameLabel.numberOfLines = 1;
    _nameLabel.font = [UIFont systemFontOfSize:14.0f];
    _nameLabel.delegate = self;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.isNeedAtAndPoundSign = YES;
    [_nameLabel setFrame:CGRectMake(58, 10, 170, 21)];
    [self.nameLabel setTextColor:MAIN_USERNAME_COLOR];
    [self.contentView addSubview:self.nameLabel];

    [self.timeLabel setTextColor:MAIN_TIME_COLOR];
}

- (void)setController:(CommentListViewController *)controller{
    _controller = controller;
}


// 赋值
- (CGFloat)setCellWithCellInfo:(CommentInfo *)dInfo cellWithRow:(NSInteger)tag
{
    _useID = dInfo.commentUserId;        //存储评论发布者ID，点击头像时需要
    _commentId = dInfo.commentId;        //存储评论ID
    
    [self.headV sd_setBackgroundImageWithURL:[NSURL URLWithString:[Units headImageThumbnails:dInfo.commentUserPortraitUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_default.png"]];
    
    
    [self.headV addTarget:self action:@selector(headButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.headV.tag = 100 + tag;
    
    //头像圆角
    [self.headV.layer setCornerRadius:CGRectGetHeight([self.headV bounds]) / 2];
    self.headV.layer.masksToBounds = YES;
    
    
    if (dInfo.userType == Acc_STBB) {
        //食探标识
        UIImageView *bageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_st.png"]];
        [bageV setFrame:CGRectMake(35, 35, 15, 15)];
        [self.contentView addSubview:bageV];
    }

    //发布者昵称
    self.nameLabel.emojiText = dInfo.commentUserNickname;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //评论者ID
    [dict setObject:dInfo.commentUserId forKey:@"commentedUserId"];
    [dict setObject:dInfo.commentUserNickname forKey:@"commentedUserNickname"];
    
    [self.nameLabel addLinkToTransitInformation:dict withRange:[self.nameLabel.text rangeOfString:self.nameLabel.text]];

    //时间
    self.timeLabel.text = [TimeUtil getTimeStrStyle1:dInfo.createTime];

    /**
     *  回复的本质：A:发表图片， B评论A，A回复B的评论， B可以再回复A的评论
     */
    
    if (!dInfo.parentCommentId || [dInfo.commentedUserId isEqualToString:dInfo.commentUserId]) {
        _desLabel.emojiText = [dInfo.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else
    {
        NSString *tempS = [NSString stringWithFormat:@"回复 %@: %@", dInfo.commentedUserNickname, dInfo.content];
        _desLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:dInfo.commentedUserId forKey:@"commentedUserId"];
        [dic setObject:dInfo.commentedUserNickname forKey:@"commentedUserNickname"];
   
        [_desLabel addLinkToTransitInformation:dic withRange:[_desLabel.emojiText rangeOfString:dInfo.commentedUserNickname]];
    }
    
    CGSize size = [_desLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - 67];
    _desLabel.frame = CGRectMake(58, 32, MAINSCREEN.size.width - 67, size.height);

    return size.height+32+ 10;
}


// 计算DesLabl的高度
- (CGFloat)calculateDesLabelheight:(NSString *)text
{
    UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:13.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(MAINSCREEN.size.width-67, 2000);
    
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;

    return size.height;
}

// 点击头像
- (void)headButtonTapped:(UIButton *)sender
{
    [_controller jumpToUserInfo:_useID isComments:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    [_controller postCommentWithInfo:components commentID:_commentId];
}

@end
