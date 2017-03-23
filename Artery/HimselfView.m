//
//  HimselfView.m
//  Shitan
//
//  Created by 刘敏 on 14/12/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "HimselfView.h"
#import "MineButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "SJAvatarBrowser.h"

@implementation HimselfView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //头像
        _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headButton setFrame:CGRectMake(15, 10, 73, 73)];
        [_headButton sd_setImageWithURL:[NSURL URLWithString:_controller.perInfo.portraiturl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_default.png"]];
        //头像圆角
        [_headButton.layer setCornerRadius:CGRectGetHeight([_headButton bounds]) / 2];
        _headButton.layer.masksToBounds = YES;
        [_headButton addTarget:self action:@selector(headButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_headButton];
        
        
        //昵称
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 87, 73, 17)];
        [_nickLabel setTextColor:MAIN_USERNAME_COLOR];
        [_nickLabel setBackgroundColor:[UIColor clearColor]];
        [_nickLabel setTextAlignment:NSTextAlignmentCenter];
        [_nickLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_nickLabel setText:_controller.perInfo.nickname];
        
        [self addSubview:_nickLabel];
        
        for (int i = 0; i < 3; i++) {
            MineButton *btn = nil;
            if (i == 0) {
                btn = [[MineButton alloc] initWithFrame:CGRectZero buttonWithTitle:@"图片" buttonwithNum:[NSString stringWithFormat:@"%ld", (long)_controller.perInfo.imgCount]];
            }
            if (i == 1) {
                btn = [[MineButton alloc] initWithFrame:CGRectZero buttonWithTitle:@"粉丝" buttonwithNum:[NSString stringWithFormat:@"%ld", (long)_controller.perInfo.fansCount]];
            }
            if (i == 2) {
                btn = [[MineButton alloc] initWithFrame:CGRectZero buttonWithTitle:@"关注" buttonwithNum:[NSString stringWithFormat:@"%ld", (long)_controller.perInfo.followedCount]];
            }
            
            btn.tag = 2000+i;
            if (MAINSCREEN.size.width>320) {
                btn.frame = CGRectMake(125+(MAINSCREEN.size.width-116)/3*i, 13, 56, 45);
            }
            else{
                btn.frame = CGRectMake(115+(MAINSCREEN.size.width-116)/3*i, 13, 56, 45);
            }
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvents:)];
            tapGesture.numberOfTapsRequired = 1;
            tapGesture.numberOfTouchesRequired = 1;
            
            //开启触摸事件响应
            [btn addGestureRecognizer:tapGesture];
            
            
            [self addSubview:btn];
        }
        
        
        //关注按钮
        _focusButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_focusButon setFrame:CGRectMake(120, 65, MAINSCREEN.size.width-140, 35)];
        [_focusButon setTitle:@"已关注" forState:UIControlStateNormal];
        
        [_focusButon.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_focusButon setBackgroundImage:@"btn36_white.png" setSelectedBackgroundImage:@"btn36_white_p.png"];
        [_focusButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_focusButon.layer setCornerRadius:2];
        _focusButon.layer.masksToBounds = YES;
        
        [_focusButon addTarget:self action:@selector(focusButonButonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_focusButon];
        
        //初始化个性签名Label
        _signatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _signatureLabel.numberOfLines = 0;
        [_signatureLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14.0]];
        [_signatureLabel setTextColor:MAIN_TEXT_COLOR];
        
        [self addSubview:_signatureLabel];
        
        
        _lineV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 178, MAINSCREEN.size.width, 4)];
        [_lineV setImage:[UIImage imageNamed:@"bg_uitableview_seperator.png"]];
        [self addSubview:_lineV];
        
        
        
    }
    return self;
}


- (void)setController:(HimselfViewController *)controller{
    _controller = controller;
}


//刷新界面
- (void)refreshOneselfView
{
    [_headButton sd_setImageWithURL:[NSURL URLWithString:_controller.perInfo.portraiturl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_head.png"]];
    
    
    if (_controller.perInfo.userType == Acc_STBB) {
        //食探标识
        UIImageView *bageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_st_big.png"]];
        [bageV setFrame:CGRectMake(64, 64, 20, 20)];
        [self addSubview:bageV];
    }
    
    [_nickLabel setText:_controller.perInfo.nickname];
    
    for (int i = 0; i < 3; i++) {
        MineButton *btn = (MineButton *)[self viewWithTag:2000+i];
        if (btn) {
            //已经存在
            if (i == 0) {
                [btn refreshMineButton:[NSString stringWithFormat:@"%ld", (long)_controller.perInfo.imgCount]];
            }
            if (i == 1){
                [btn refreshMineButton:[NSString stringWithFormat:@"%ld", (long)_controller.perInfo.fansCount]];
            }
            if (i == 2) {
                [btn refreshMineButton:[NSString stringWithFormat:@"%ld", (long)_controller.perInfo.followedCount]];
            }
        }
    }
    
    //计算高度
    [self calculateSignatureheight:_controller.perInfo.signature];
    
    [self refreshButton];
    
}


//头像
- (void)headButtonTouch:(id)sender
{
    [SJAvatarBrowser showImage:self.headButton.imageView];
}

//关注按钮
- (void)focusButonButonTouch:(id)sender
{
    NSMutableDictionary *encapsulateData = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [encapsulateData setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followerUserId"];
    [encapsulateData setObject:_controller.respondentUserId forKey:@"followedUserId"];
    
    if (_hasFollow) {
        //取消关注
        [_controller.userDao requestUserUnFollow:encapsulateData completionBlock:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] integerValue] == 200)
            {
                
                _hasFollow = NO;
                [self refreshButton];
            }
            
        } setFailedBlock:^(NSDictionary *result) {
            
            
        }];
    }
    else{
        [_controller.userDao requestUserFollow:encapsulateData completionBlock:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] integerValue] == 200)
            {
                _hasFollow = YES;
                [self refreshButton];
            }
            else
            {
                CLog(@"%@", [result objectForKey:@"msg"]);
            }
        } setFailedBlock:^(NSDictionary *result) {
            
            
        }];
        
    }
}




//触摸事件响应
- (void)tapEvents:(UITapGestureRecognizer *)tapGesture
{
    NSInteger tag = tapGesture.view.tag - 2000;
    switch (tag) {
        case 0:
            //图片个数
            break;
            
        case 1:
        {
            //粉丝
            if(_controller.perInfo.fansCount > 0){
                [_controller openFansList];
            }
        }
            break;
            
        case 2:
        {
            //关注
            if(_controller.perInfo.followedCount > 0){
                [_controller openAttentionList];
            }
        }
            break;
            
        default:
            break;
    }
}


// 计算个性签名的高度
- (void)calculateSignatureheight:(NSString *)text
{
    //设置自动行数与字符换行
    [self.signatureLabel setNumberOfLines:0];
    self.signatureLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    if (!text) {
        text = @"暂无个人简介";
    }
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:14.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(MAINSCREEN.size.width-30, 2000);
    
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    [self.signatureLabel setText:text];
    [self.signatureLabel setFont:font];
    [self.signatureLabel setTextColor:MAIN_TEXT_COLOR];
    [self.signatureLabel setFrame:CGRectMake(15, 118, MAINSCREEN.size.width-30, size.height)];
    
    [_lineV setFrame:CGRectMake(0, size.height + 124, MAINSCREEN.size.width, 4)];
    
    [_controller changeInterfaceHeight:size.height + 128];
}

- (void)refreshButton
{
    if (_hasFollow) {
        [_focusButon setTitle:@"已关注" forState:UIControlStateNormal];
        [_focusButon setBackgroundImage:@"btn36_white.png" setSelectedBackgroundImage:@"btn36_white_p.png"];
        [_focusButon setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else{
        [_focusButon setTitle:@"关注" forState:UIControlStateNormal];
        [_focusButon setBackgroundImage:@"btn38_red.png" setSelectedBackgroundImage:@"btn38_grey.png"];
        [_focusButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
}


@end
