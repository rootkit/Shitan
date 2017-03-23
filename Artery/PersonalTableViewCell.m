//
//  PersonalTableViewCell.m
//  Shitan
//
//  Created by Richard Liu on 15/5/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "PersonalTableViewCell.h"
#import "STButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "SJAvatarBrowser.h"


#define kOneselfMarginTop 15
#define kOneselfMarginLeft 15
#define kOneselfMarginRight 15
#define kOneselfHeadViewWidth 73
#define kOneselfNickViewHeight 17
#define kOneselfMineBtnHeight 40
#define kLineVWidth 1
#define kOneselfHeadViewHeight kOneselfHeadViewWidth

@implementation PersonalTableViewCell

- (void)awakeFromNib {

    // Initialization code
    //头像
    [self setUpHeadView];
    
    //昵称
    [self setUpNickView];
    
    //简介
    [self setUpSignatureView];
    
    //编辑个人资料按钮
    [self setUpAcces];
    
    //按钮
    [self setUpMines];
}

- (void)updateData
{
    [_headButton sd_setImageWithURL:[NSURL URLWithString:[AccountInfo sharedAccountInfo].portraiturl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_default.png"]];

    [_nickLabel setText:[AccountInfo sharedAccountInfo].nickname];
    
    NSString *signature = nil;
    if ([[AccountInfo sharedAccountInfo].signature length] == 0) {
        signature = [NSString stringWithFormat:@"个人简介：暂无"];
    }
    else{
        signature = [NSString stringWithFormat:@"个人简介：%@", [AccountInfo sharedAccountInfo].signature];
    }
    
    [_signatureLabel setText:signature];
    
}


//头像
- (void)setUpHeadView
{
    CGFloat headX = kOneselfMarginLeft;
    CGFloat headY = kOneselfMarginTop;
    CGFloat headW = kOneselfHeadViewWidth;
    CGFloat headH = headW;
    
    _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headButton.frame = CGRectMake(headX, headY, headW, headH);
    
    
    //圆角
    _headButton.layer.cornerRadius = 6; //设置那个圆角的有多圆
    _headButton.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
    _headButton.layer.borderColor = [[UIColor whiteColor] CGColor];//设置边框的颜色
    _headButton.layer.masksToBounds = YES;  //设为NO去试试
    
    [_headButton addTarget:self action:@selector(headButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_headButton];
    
    
    if ([AccountInfo sharedAccountInfo].userType == Acc_STBB) {
        //食探标识
        UIImageView *bageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_st_big.png"]];
        [bageV setFrame:CGRectMake(70, 70, 20, 20)];
        [self.contentView addSubview:bageV];
    }
}

//头像
- (void)headButtonTouch:(id)sender
{
    [SJAvatarBrowser showImage:self.headButton.imageView];
}



//昵称
- (void)setUpNickView
{
    CGFloat nickX = CGRectGetMaxX(_headButton.frame) + kOneselfMarginLeft;
    CGFloat nickY = _headButton.frame.origin.y +10;
    CGFloat nickW = self.frame.size.width - _headButton.frame.size.width - kOneselfMarginLeft * 3;
    CGFloat nickH = kOneselfNickViewHeight;
    
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickX, nickY, nickW, nickH)];
    [_nickLabel setBackgroundColor:[UIColor clearColor]];
    [_nickLabel setTextAlignment:NSTextAlignmentLeft];
    [_nickLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_nickLabel setText:[AccountInfo sharedAccountInfo].nickname];
    
    [self.contentView addSubview:_nickLabel];
}

//设置签名
- (void)setUpSignatureView{
    
    CGFloat signatureX = CGRectGetMaxX(_headButton.frame) + kOneselfMarginLeft;
    CGFloat signatureY = CGRectGetMaxY(_nickLabel.frame)+8;
    CGFloat signatureW = MAINSCREEN.size.width -130;
    CGFloat signatureH = _headButton.frame.size.height - _nickLabel.frame.size.height - kOneselfMarginTop;
    
    _signatureLabel = [[UILabel alloc]init];
    _signatureLabel.frame = CGRectMake(signatureX, signatureY, signatureW, signatureH);
    //初始化个性签名Label
    _signatureLabel.numberOfLines = 0;
    self.signatureLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_signatureLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14.0]];
    [_signatureLabel setTextColor:MAIN_TITLE_COLOR];
    
    [self.contentView addSubview:_signatureLabel];
    
}


//编辑个人资料按钮
- (void)setUpAcces{
    
    CGFloat accesX = MAINSCREEN.size.width - 38;
    CGFloat accesY = 15 +33;
    
    _accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accessoryButton setImage:[UIImage imageNamed:@"bg_uitableview_array"] forState:UIControlStateNormal];
    
    [_accessoryButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _accessoryButton.frame = CGRectMake(accesX, accesY, 40, 40);
    [_accessoryButton setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_accessoryButton];
    
    CGFloat transparentX = CGRectGetMaxX(_headButton.frame) + kOneselfMarginLeft;
    CGFloat transparentY = _headButton.frame.origin.y;
    CGFloat transparentW = MAINSCREEN.size.width -transparentX;
    CGFloat transparentH = _headButton.frame.size.height;
    _transparentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _transparentBtn.frame = CGRectMake(transparentX, transparentY, transparentW, transparentH);
    _transparentBtn.backgroundColor = [UIColor clearColor];
    [_transparentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _transparentBtn.tag = 3;
    [self.contentView addSubview:_transparentBtn];
}

- (void)setUpMines{
    CGFloat btnY = CGRectGetMaxY(_headButton.frame) + kOneselfMarginTop;
    CGFloat btnW = MAINSCREEN.size.width / 3;
    CGFloat btnH = kOneselfMineBtnHeight;
    
    for (int i = 0; i < 3; i++) {
        STButton *nums = nil;
        if (i == 0) {
            nums = [[STButton alloc] initWithFrame:CGRectZero buttonWithTitle:@"图片" buttonwithNum:[NSString stringWithFormat:@"%ld", (long)[AccountInfo sharedAccountInfo].imgCount]];
        }
        if (i == 1) {
            nums = [[STButton alloc] initWithFrame:CGRectZero buttonWithTitle:@"粉丝" buttonwithNum:[NSString stringWithFormat:@"%ld", (long)[AccountInfo sharedAccountInfo].fansCount]];
        }
        if (i == 2) {
            nums = [[STButton alloc] initWithFrame:CGRectZero buttonWithTitle:@"关注" buttonwithNum:[NSString stringWithFormat:@"%ld", (long)[AccountInfo sharedAccountInfo].followedCount]];
        }
        
        nums.tag = i+2000;
        nums.frame = CGRectMake(btnW * i, btnY, btnW, btnH);
        [_accessoryButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvents:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        
        //开启触摸事件响应
        [nums addGestureRecognizer:tapGesture];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(btnW * (i + 1) , btnY+8, kLineVWidth, btnH-10)];
        lineV.backgroundColor = [UIColor colorWithHex:0xD9D9D9];
        [self.contentView addSubview:lineV];
        
        [self.contentView addSubview:nums];
    }
}


//触摸事件响应
- (void)tapEvents:(UITapGestureRecognizer *)tapGesture
{
    NSInteger tag = tapGesture.view.tag - 2000;
    if ([self.delegate respondsToSelector:@selector(personalTableViewCell:bTnIndex:)]) {
        [self.delegate personalTableViewCell:self bTnIndex:tag];
    }

}


#pragma mark - 点击事件
- (void)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(personalTableViewCell:bTnIndex:)]) {
        [self.delegate personalTableViewCell:self bTnIndex:sender.tag];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
