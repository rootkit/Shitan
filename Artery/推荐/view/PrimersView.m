//
//  PrimersView.m
//  Shitan
//
//  Created by Richard Liu on 15/8/28.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PrimersView.h"
#import "MLEmojiLabel.h"

@interface PrimersView ()

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) MLEmojiLabel *introductionL;

@end

@implementation PrimersView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView
{
    //背景
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    self.bgView.layer.cornerRadius = 3;//设置那个圆角的有多圆
    self.bgView.layer.masksToBounds = YES;//设为NO去试试
    [self.bgView setBackgroundColor:BACKGROUND_COLOR];
    [self addSubview:self.bgView];
    
    //简介
    MLEmojiLabel *introductionL = [[MLEmojiLabel alloc] init];
    self.introductionL = introductionL;
    self.introductionL.numberOfLines = 0;
    self.introductionL.lineBreakMode = NSLineBreakByWordWrapping;
    [self.introductionL setTextColor:MAIN_TEXT_COLOR];
    [self.introductionL setFont:[UIFont systemFontOfSize:14.0]];
    self.introductionL.isNeedAtAndPoundSign = YES;
    self.introductionL.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.introductionL.customEmojiPlistName = @"expression";
    [self.introductionL setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.introductionL];
}


- (void)setPrimersModelFrame:(PrimersModelFrame *)primersModelFrame
{
    _primersModelFrame = primersModelFrame;
    
    self.bgView.frame =_primersModelFrame.backViewFrame;
    self.introductionL.frame = _primersModelFrame.desLabelFrame;

    [self setUpChildData];
}

- (void)setUpChildData{

    self.introductionL.emojiText = [self.primersModelFrame.dInfo.foodDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
