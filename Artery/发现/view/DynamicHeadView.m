//
//  DynamicHeadView.m
//  Shitan
//
//  Created by Avalon on 15/5/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "DynamicHeadView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "TimeUtil.h"
#import "UserRelationshipDAO.h"

#define kHeadVWH 40


@interface DynamicHeadView ()

//头像
@property (nonatomic, weak) UIButton *headButton;

//大V标示
@property (nonatomic, weak) UIImageView *memberV;

//名称
@property (nonatomic, weak) UILabel *nameLabel;

//日期
@property (nonatomic, weak) UILabel *timeLabel;

//关注
@property (nonatomic, weak) UIButton *focusButton;

@property (nonatomic, strong) UserRelationshipDAO *userDao;


@end


@implementation DynamicHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {    
        [self initDao];
        
        [self setUpChildView];
        
        
    }
    return self;
}


- (void)initDao{
    
    if (_userDao == nil) {
        _userDao = [[UserRelationshipDAO alloc] init];

    }
}

- (void)setUpChildView{
    
//头像
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headButton = headButton;
    self.headButton.tag = 1;
    [self.headButton addTarget:self action:@selector(headButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //头像圆角
    [self.headButton.layer setCornerRadius:kHeadVWH * 0.5];
    self.headButton.layer.masksToBounds = YES;
    [self addSubview:self.headButton];
    
//食探标识
    UIImageView *memberV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_st.png"]];
    self.memberV = memberV;
    [self addSubview:self.memberV];
    
//昵称
    UILabel *nameLabel = [[UILabel alloc]init];
    self.nameLabel = nameLabel;
    self.nameLabel.text = self.dynamicModelFrame.dInfo.nickname;
    self.nameLabel.font = [UIFont systemFontOfSize:FontSize];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.nameLabel setTextColor:MAIN_USERNAME_COLOR];
    [self addSubview:self.nameLabel];
//时间
    UILabel *timeLabel = [[UILabel alloc]init];
    self.timeLabel = timeLabel;
    [self.timeLabel setFont:[UIFont systemFontOfSize:12.0]];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [self.timeLabel setTextColor:[UIColor lightGrayColor]];
    [self addSubview:self.timeLabel];
    

//关注
    UIButton *focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.focusButton = focusButton;
    [self.focusButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [self.focusButton setImage:[UIImage imageNamed:@"btn_dynamic_follow.png"] forState:UIControlStateNormal];
    [self.focusButton setTitle:@" 关注" forState:UIControlStateNormal];
    [self.focusButton.titleLabel setFont:[UIFont systemFontOfSize:FontSize]];
    [self.focusButton addTarget:self action:@selector(focusButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.focusButton];

}

- (void)setDynamicModelFrame:(DynamicModelFrame *)dynamicModelFrame{
    
    _dynamicModelFrame = dynamicModelFrame;
   
    self.headButton.frame = _dynamicModelFrame.headVFrame;
    self.memberV.frame = _dynamicModelFrame.memberFrame;
    self.nameLabel.frame = _dynamicModelFrame.nameLabelFrame;
    self.timeLabel.frame = _dynamicModelFrame.timeLabelFrame;
    self.focusButton.frame = _dynamicModelFrame.focusButtonFrame;
    
    [self setChildViewData];
    
}

- (void)setChildViewData{
    
//设置头像图片
    [self.headButton sd_setImageWithURL:[NSURL URLWithString:[Units headImageThumbnails:self.dynamicModelFrame.dInfo.portraitUrl]]forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_default.png"]];
    
    if (self.dynamicModelFrame.dInfo.userType == Acc_STBB) {
        //食探标识
        [self.memberV setHidden:NO];
    }
    else
    {
        [self.memberV setHidden:YES];
    }

    
//设置昵称
    self.nameLabel.text = self.dynamicModelFrame.dInfo.nickname;
    
//设置时间
    self.timeLabel.text = [TimeUtil getTimeStrStyle1:self.dynamicModelFrame.dInfo.createTime];
    
//设置关注(isshow)
    if (theAppDelegate.isLogin) {
        if (self.dynamicModelFrame.dInfo.hasFollowTheAuthor || [[AccountInfo sharedAccountInfo].userId isEqualToString:self.dynamicModelFrame.dInfo.userId] ) {
            self.focusButton.hidden = YES;
        }
        else
            self.focusButton.hidden = NO;
    }
    else
        self.focusButton.hidden = YES;
}

#pragma mark - headButton的点击事件

- (void)headButtonClick{
    
    if (!theAppDelegate.isLogin) {
        STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
        STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
        nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        nc.view.layer.shadowOpacity = 0.2;
        
        [theAppDelegate.mainVC presentViewController:nc animated:YES completion:nil];
        
        return;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(dynamicHeadView:useId:)]) {
        
        [self.delegate dynamicHeadView:self useId:self.dynamicModelFrame.dInfo.userId];
    }
}

#pragma mark - focusButton的点击事件

- (void)focusButtonTapped:(UIButton *)sender{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followerUserId"];
    [dict setObject:self.dynamicModelFrame.dInfo.userId forKey:@"followedUserId"];
    
    //刷新整个表格
    [self refreshFocusButton];
    
    //关注好友
    [_userDao requestUserFollow:dict completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            //重新获取
            [AccountInfo sharedAccountInfo].followedCount++;
        }
        else
        {
            CLog(@"%@", [result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}

//刷新关注按钮状态
- (void)refreshFocusButton
{
    if ([self.delegate respondsToSelector:@selector(dynamicHeadView:refreshdyAttentionWithUseId:)]) {
        
        [self.delegate dynamicHeadView:self refreshdyAttentionWithUseId:self.dynamicModelFrame.dInfo.userId];
    }
}



#pragma mark - 精选
- (void)setQuality
{
    self.timeLabel.text = @"精选";
}




@end
