//
//  SimpleCell.m
//  Shitan
//
//  Created by 刘敏 on 14-10-29.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "SimpleCell.h"
#import "TimeUtil.h"


@implementation SimpleCell

- (void)awakeFromNib
{
    // Initialization code
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _desLabel = desLabel;
    _desLabel.numberOfLines = 0;
    [_desLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:12.0]];
    [self.contentView addSubview:_desLabel];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, MAINSCREEN.size.width-105, 20)];
    _titleLabel = titleLabel;
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [self.contentView addSubview:_titleLabel];
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width - 85, 10, 70, 20)];
    _timeLabel = timeLabel;
    [_timeLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_timeLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_timeLabel];
}

- (void)setCellWithCellBroadCastInfo:(BroadcastInfo *)mesInfo cellWithRow:(NSInteger)row
{
    _titleLabel.textColor = MAIN_USERNAME_COLOR;
    _desLabel.textColor = MAIN_TEXT_COLOR;
    _timeLabel.textColor = MAIN_TIME_COLOR;
    
    _titleLabel.text = mesInfo.title;
    _timeLabel.text = [TimeUtil getTimeStrStyle1:mesInfo.createTime];
    
    [self calculateDesLabelheight:mesInfo.descriptions];
}


// 计算DesLabl的高度
- (void)calculateDesLabelheight:(NSString *)text
{
    UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:13.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(MAINSCREEN.size.width-30, 2000);

    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;

    [_desLabel setText:text];
    [_desLabel setFrame:CGRectMake(15, 35, MAINSCREEN.size.width-30, size.height)];
}

@end
