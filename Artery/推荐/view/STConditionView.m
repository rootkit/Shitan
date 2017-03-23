//
//  STConditionView.m
//  Shitan
//
//  Created by Richard Liu on 15/8/25.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STConditionView.h"
#import "SKButton.h"

//选择查询条件的的初始透明度
static const CGFloat STConditionViewAlpha = 0.8;
//button切换的时间
static const CGFloat STConditionViewDuration = 0.1;


@interface STConditionView ()

//分割线
@property (nonatomic, strong) UIView        *line1;
@property (nonatomic, strong) UIView        *line2;
@property (nonatomic, strong) UIView        *line3;
@property (nonatomic, strong) UIView        *line4;

@property (nonatomic, strong) SKButton      *menuBtn;
/** 最新按钮 */
@property (nonatomic, strong) SKButton      *newsBtn;
/** 区域按钮 */
@property (nonatomic, strong) SKButton      *areaBtn;
/** 个性按钮 */
@property (nonatomic, strong) SKButton      *personBtn;
/** 搜索按钮 */
@property (nonatomic, strong) SKButton      *searchBtn;

@property (nonatomic, strong) UIView        *bottomView;

@end



@implementation STConditionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}


//初始化
- (void)setUp
{
    //需要注意层级的关系
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;

    //最底部的View
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.alpha = STConditionViewAlpha;
    [self addSubview:self.bottomView];
    
    self.menuBtn = [SKButton buttonWithType:UIButtonTypeCustom];
    self.newsBtn = [SKButton buttonWithType:UIButtonTypeCustom];
    self.areaBtn = [SKButton buttonWithType:UIButtonTypeCustom];
    self.personBtn = [SKButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn = [SKButton buttonWithType:UIButtonTypeCustom];
    
    //添加子控件
    [self addBtnWith:self.menuBtn tag:STConditionButtonTypeMenu imageName:@"mine_menu"];
    [self addBtnWith:self.newsBtn tag:STConditionButtonTypeNew title:@"最新" imageName:@"icon_arrow_down"];
    [self addBtnWith:self.areaBtn tag:STConditionButtonTypeArea title:@"全部" imageName:@"icon_arrow_down"];
    [self addBtnWith:self.personBtn tag:STConditionButtonTypePersonality title:@"全部" imageName:@"icon_arrow_down"];
    [self addBtnWith:self.searchBtn tag:STConditionButtonTypeSearch imageName:@"mine_search"];

    
    //添加分割线
    self.line1 = [[UIView alloc] init];
    [self addLineWith:self.line1];
    self.line2 = [[UIView alloc] init];
    [self addLineWith:self.line2];
    self.line3 = [[UIView alloc] init];
    [self addLineWith:self.line3];
    self.line4 = [[UIView alloc] init];
    [self addLineWith:self.line4];
}

//布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat conditionViewX = MAINSCREEN.size.width * 0.05;
    CGFloat conditionViewW = MAINSCREEN.size.width * 0.9;
    
    //最底部的View
    self.bottomView.frame = CGRectMake(conditionViewX, 0, conditionViewW, self.frame.size.height);
    
    //设置view的属性
    CGFloat H = self.bottomView.frame.size.height;
    CGFloat W = self.bottomView.frame.size.width;
    
    CGFloat cornerRadius = (H > W ? W : H) * 0.1;
    self.bottomView.layer.cornerRadius = cornerRadius;

    //布局子控件
    CGFloat btnW = W / 4;
    CGFloat btnH = H;
    CGFloat lineH = H * 0.4;
    CGFloat lineY = H * 0.3;
    
    self.menuBtn.frame = CGRectMake(0, 0, btnW/2, btnH);
    self.line1.frame = CGRectMake(btnW/2, lineY, 1, lineH);
    
    self.newsBtn.frame = CGRectMake(CGRectGetMaxX(self.menuBtn.frame), 0, btnW, btnH);
    self.line2.frame = CGRectMake(CGRectGetMaxX(self.newsBtn.frame), lineY, 1, lineH);
    [self.newsBtn setTitle:@"最新" forState:UIControlStateNormal];
    
    self.areaBtn.frame = CGRectMake(CGRectGetMaxX(self.newsBtn.frame), 0, btnW, btnH);
    self.line3.frame = CGRectMake(CGRectGetMaxX(self.areaBtn.frame), lineY, 1, lineH);
    [self.areaBtn setTitle:@"全部" forState:UIControlStateNormal];
    
    self.personBtn.frame = CGRectMake(CGRectGetMaxX(self.areaBtn.frame), 0, btnW, btnH);
    self.line4.frame = CGRectMake(CGRectGetMaxX(self.personBtn.frame), lineY, 1, lineH);
    [self.personBtn setTitle:@"全部" forState:UIControlStateNormal];
    
    
    self.searchBtn.frame = CGRectMake(CGRectGetMaxX(self.personBtn.frame), 0, btnW/2, btnH);
}


//添加分割线
- (void)addLineWith:(UIView *)line
{
    line.backgroundColor = [UIColor colorWithHex:0x929292];
    line.alpha = STConditionViewAlpha;
    [self.bottomView addSubview:line];
}


//添加按钮
- (void)addBtnWith:(SKButton *)btn tag:(NSInteger)tag title:(NSString *)title imageName:(NSString *)imageName
{
    btn.tag = tag;
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.bottomView addSubview:btn];


    
}

//添加按钮
- (void)addBtnWith:(SKButton *)btn tag:(NSInteger)tag imageName:(NSString *)imageName
{
    btn.tag = tag;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:btn];
}

//按钮的各种点击事件
- (void)btnClick:(SKButton *)sender
{
    if (_delegate) {
        [_delegate conditionView:self didButtonClickFrom:sender.tag];
    }
}

//设置标题
- (void)setButtonTitle:(NSString *)tit didButtonClickFrom:(STConditionButtonType)index
{
    switch (index) {
        case STConditionButtonTypeNew:
            [_newsBtn setTitle:tit forState:UIControlStateNormal];
            break;
            
        case STConditionButtonTypeArea:
            [_areaBtn setTitle:tit forState:UIControlStateNormal];
            break;
            
        case STConditionButtonTypePersonality:
            [_personBtn setTitle:tit forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

@end
