//
//  ShopMiddleContentsView.m
//  Shitan
//
//  Created by Richard Liu on 15/6/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ShopMiddleContentsView.h"
#import "MLEmojiLabel.h"

@interface ShopMiddleContentsView ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *lineV;
@property (nonatomic, weak) UILabel *shadowV;
@property (nonatomic, weak) MLEmojiLabel *introductionL;



@end

@implementation ShopMiddleContentsView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView
{
    
    //标题
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    [self.nameLabel setTextColor:[UIColor blackColor]];
    [self.nameLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.nameLabel];
    
    //分割线
    UILabel *lineV = [[UILabel alloc] init];
    self.lineV = lineV;
    self.lineV.backgroundColor = [UIColor grayColor];
    [self addSubview:self.lineV];

    //阴影
    UILabel *shadowV = [[UILabel alloc] init];
    self.shadowV = shadowV;
    self.shadowV.backgroundColor = [UIColor blackColor];
    [self addSubview:self.shadowV];
    
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
    [self.introductionL setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.introductionL];
}

- (void)setRecommendModelFrame:(RecommendModelFrame *)recommendModelFrame
{
    _recommendModelFrame = recommendModelFrame;
    
    self.introductionL.frame = _recommendModelFrame.desLabelFrame;
    self.nameLabel.frame = _recommendModelFrame.dishNameFrame;
    self.lineV.frame = _recommendModelFrame.lineVFrame;
    self.shadowV.frame = _recommendModelFrame.shadowFrame;
    
    [self setUpChildData];
}

- (void)setUpChildData{
    
    if (self.recommendModelFrame.dInfo.foodDesc) {
        self.introductionL.emojiText = [self.recommendModelFrame.dInfo.foodDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    switch (self.recommendModelFrame.dInfo.foodType) {
        case 1:

            break;
            
        case 2:
        {
            [self.nameLabel setText:self.recommendModelFrame.dInfo.foodName];
            [self.nameLabel setTextColor:[UIColor blackColor]];
        }
            break;
            
        case 3:
        {
            if (self.recommendModelFrame.dInfo.foodName.length > 0) {
                [self.nameLabel setText:[NSString stringWithFormat:@"「 %@ 」", self.recommendModelFrame.dInfo.foodName]];
                [self.nameLabel setTextColor:MAIN_COLOR];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
