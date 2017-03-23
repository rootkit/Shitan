//
//  TopSpecialCell.m
//  Shitan
//
//  Created by Richard Liu on 15/5/5.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "TopSpecialCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MLEmojiLabel.h"
#import "TimeUtil.h"

#define HEADER_HIGH_IPHONE5         150.0f
#define HEADER_HIGH_IPHONE6         176.0f
#define HEADER_HIGH_IPHONE6_Plus    194.0f

#define OFFSET_X_RIGHT_N  10.0f

#define INSPECT_ALL_ARTICLE @"inspect_all_article"


@interface TopSpecialCell ()<MLEmojiLabelDelegate, TTTAttributedLabelDelegate>

@end

@implementation TopSpecialCell


- (void)awakeFromNib {
    // Initialization code
    
    [self.contentView setBackgroundColor:BACKGROUND_COLOR];
    if (MAINSCREEN.size.width == IPHONE6_PLUS_WIDTH) {
        self.HEADER_HIGH = HEADER_HIGH_IPHONE6_Plus;
    }
    else if (MAINSCREEN.size.width == IPHONE6_WIDTH) {
        self.HEADER_HIGH = HEADER_HIGH_IPHONE6;
    }
    else{
        self.HEADER_HIGH = HEADER_HIGH_IPHONE5;
    }
    
    _headV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, self.HEADER_HIGH)];
    [_headV setBackgroundColor:[UIColor whiteColor]];
    
    //遮罩
    CALayer *maskLayer = [CALayer layer];
    [maskLayer setFrame:_headV.frame];
    [maskLayer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:0.2] CGColor]];
    [_headV.layer addSublayer:maskLayer];
    [self.contentView addSubview:_headV];
}

- (CGFloat)setTopSpecialCellWithCellInfo:(BannerInfo *)bInfo
{
    [_headV sd_setImageWithURL:[NSURL URLWithString:bInfo.topImgUrl] placeholderImage:[UIImage imageNamed:@"default_image.png"]];

    
    //结束日期
    UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.HEADER_HIGH/4 - OFFSET_X_RIGHT_N, MAINSCREEN.size.width, OFFSET_X_RIGHT_N)];
    
    //开始时间
    NSDate *beginT = [TimeUtil dateFromString:bInfo.beginTime];
    
    CLog(@"活动开始时间：%@", bInfo.beginTime);
    
    if ([[TimeUtil compareCurrentBeginTime:beginT] isEqualToString:@"活动未开始"]) {
        [dateL setText:@"活动未开始，敬请期待！"];
    }
    else{
        
        NSInteger endtime = bInfo.leftTime / 1000;
        
        if (endtime <= 0) {
            dateL.text = [NSString stringWithFormat:@"活动已结束"];
        }
        
        else if (endtime < 60) {
            
            dateL.text = [NSString stringWithFormat:@"还有%ld秒结束",endtime];
            
        }
        else if (endtime < 3600){
            
            dateL.text = [NSString stringWithFormat:@"还有%ld分钟结束",endtime / 60];
        }
        else if (endtime < 3600 * 24)
        {
            dateL.text = [NSString stringWithFormat:@"还有%ld小时结束",endtime / 3600];
        }
        else if (endtime < 3600 * 24 * 30) {
            dateL.text = [NSString stringWithFormat:@"还有%ld天结束",endtime / (3600 * 24) + 1];
        }
        else if (endtime < 3600 * 24 * 30 * 12){
            dateL.text = [NSString stringWithFormat:@"还有%ld个月结束",endtime / (3600 * 24 * 30) + 1];
        }
        else {
            dateL.text = [NSString stringWithFormat:@"还有%ld年结束",endtime / (3600 * 24 * 30 * 12) + 1];
        }
        
//        if (timeS < 60 && timeS >= 0) {
//            result = [NSString stringWithFormat:@"活动已结束"];
//        }
//        else if((temp = timeS/60) <60){
//            result = [NSString stringWithFormat:@"还有%ld分钟结束",temp];
//        }
//        else if((temp = temp/60) <24){
//            result = [NSString stringWithFormat:@"还有%ld小时结束",temp];
//        }
//        else if((temp = temp/24) <30){
//            result = [NSString stringWithFormat:@"还有%ld天结束",temp];
//        }
//        else if((temp = temp/30) <12){
//            result = [NSString stringWithFormat:@"还有%ld月结束",temp];
//        }
//        else{
//            temp = temp/12;
//            result = [NSString stringWithFormat:@"还有%ld年结束",temp];
//        }
//    
        
        //dateL.text = [NSString stringWithFormat:@"还有%ld天结束",];
        
        //结束时间
//        NSDate *endT = [TimeUtil dateFromString:bInfo.endTime];
//        CLog(@"活动结束时间：%@", bInfo.endTime);
//        [dateL setText:[TimeUtil compareCurrentEndTime:endT]];
        
        
        
    }
    
    [dateL setTextColor:[UIColor whiteColor]];
    dateL.textAlignment = NSTextAlignmentCenter;
    [dateL setFont:[UIFont systemFontOfSize:14.0]];
    [_headV addSubview:dateL];
    
    
    UILabel *headL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.HEADER_HIGH/2 - OFFSET_X_RIGHT_N*2, MAINSCREEN.size.width, OFFSET_X_RIGHT_N*2)];
    
    [headL setText:bInfo.title];
    [headL setTextColor:[UIColor whiteColor]];
    headL.textAlignment = NSTextAlignmentCenter;
    [headL setFont:[UIFont boldSystemFontOfSize:18.0]];
    [_headV addSubview:headL];
    
    //参加人数
    UIImageView *joinImage = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width * 0.5 + 19, self.HEADER_HIGH - 30 , 14, 14)];
    
    joinImage.image = [UIImage imageNamed:@"icon_join"];
    joinImage.contentMode = UIViewContentModeCenter;
    [_headV addSubview:joinImage];
    
    UILabel *joinLabel = [[UILabel alloc]init];
    NSString *joinText = [NSString stringWithFormat:@"%lu人参加",(unsigned long)bInfo.applyCount];
    joinLabel.text = joinText;
    [joinLabel setFont:[UIFont systemFontOfSize:14.0]];
    joinLabel.frame = CGRectMake(CGRectGetMaxX(joinImage.frame) + 6, joinImage.frame.origin.y, 0, 0);
    [joinLabel sizeToFit];
    joinLabel.textAlignment = NSTextAlignmentCenter;
    joinLabel.textColor = [UIColor whiteColor];
    [self.headV addSubview:joinLabel];
    
    //居中处理
    CGPoint centerJoin = joinLabel.center;
    centerJoin.x = joinImage.center.x;
    joinImage.center = centerJoin;
    
    
    //浏览人数
    UIImageView *browseImage = [[UIImageView alloc] init];
    browseImage.image = [UIImage imageNamed:@"icon_brower"];
    browseImage.frame = CGRectMake(MAINSCREEN.size.width * 0.5 - 19 - joinImage.frame.size.width - 10 - joinLabel.frame.size.width, joinImage.frame.origin.y, 17, 14);
    browseImage.contentMode = UIViewContentModeCenter;
    [_headV addSubview:browseImage];
    
    UILabel *browseLabel = [[UILabel alloc]init];
    NSString *browseText = [NSString stringWithFormat:@"%lu人浏览",(unsigned long)bInfo.showCount];
    browseLabel.text = browseText;
    [browseLabel setFont:[UIFont systemFontOfSize:14.0]];
    browseLabel.frame = CGRectMake(CGRectGetMaxX(browseImage.frame) + 6, joinImage.frame.origin.y, 0, 0);
    [browseLabel sizeToFit];
    browseLabel.textAlignment = NSTextAlignmentCenter;
    browseLabel.textColor = [UIColor whiteColor];
    [self.headV addSubview:browseLabel];
    
    //居中处理
    CGPoint centerBrowse = browseLabel.center;
    centerBrowse.x = browseImage.center.x;
    browseImage.center = centerBrowse;
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.HEADER_HIGH, MAINSCREEN.size.width, self.HEADER_HIGH)];
    [_topView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:_topView];
    _topView.userInteractionEnabled = YES;
    
    
    //标题
    UILabel *tit = [[UILabel alloc] initWithFrame:CGRectMake(OFFSET_X_RIGHT_N, 15, MAINSCREEN.size.width-OFFSET_X_RIGHT_N*2, OFFSET_X_RIGHT_N*2)];
    [tit setText:[NSString stringWithFormat:@"专题：%@", bInfo.title]];
    [tit setFont:[UIFont boldSystemFontOfSize:18.0]];
    [_topView addSubview:tit];
    
    //描述
    MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
    praisLabel.delegate = self;
    praisLabel.numberOfLines = 0;
    praisLabel.font = [UIFont systemFontOfSize:14.0f];
    praisLabel.textAlignment = NSTextAlignmentLeft;
    NSString *tempS = [NSString stringWithFormat:@"%@ 查看全文", bInfo.des];
    praisLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:INSPECT_ALL_ARTICLE forKey:@"inspect_article"];
    [praisLabel addLinkToTransitInformation:dic withRange:[praisLabel.emojiText rangeOfString:@"查看全文"]];
    
    
    CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_RIGHT_N*2];
    //计算文字描述顶部的高度
    CGFloat topH = 15 + OFFSET_X_RIGHT_N*2 + OFFSET_X_RIGHT_N;
    praisLabel.frame = CGRectMake(OFFSET_X_RIGHT_N, topH, MAINSCREEN.size.width - OFFSET_X_RIGHT_N*2, size.height);
    [_topView addSubview:praisLabel];
    
    topH = topH+size.height;
    
    [_topView setFrame:CGRectMake(0, self.HEADER_HIGH, MAINSCREEN.size.width, topH + 10)];
    
    return self.HEADER_HIGH +topH + 10+15;
    
}


- (void)setController:(SpecialViewController *)controller
{
    _controller = controller;
}


#pragma mark - MLEmojiLabelDelegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"点击了某个自添加链接%@",url);
    
}


- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    NSLog(@"点击了某个自添加链接%@",addressComponents);
}



- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    NSString *status = [components objectForKey:@"inspect_article"];
    
    if ([status isEqualToString:INSPECT_ALL_ARTICLE]) {
        [_controller jumpToWebView];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
