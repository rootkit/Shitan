//
//  STLeftMenuView.m
//  Shitan
//
//  Created by Richard Liu on 15/8/24.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STLeftMenuView.h"
#import "STMenuButton.h"

#define STInterval_H                10.0    //按钮间隔高度
#define ST_LEFT_W                   25.0    //按钮距离边界距离

#define STBtnH          MAINBOUNDS.size.height > 480 ? 60.0:50.0

@interface STLeftMenuView ()

/** 城市选择 */
@property (weak, nonatomic) UIButton *cityBtn;
@property (weak, nonatomic) UILabel *cityLabel;
// 首页
@property (weak, nonatomic) STMenuButton *homeBtn;
// 发现
@property (weak, nonatomic) STMenuButton *foundBtn;
// 收藏
@property (weak, nonatomic) STMenuButton *collectionBtn;
// 消息
@property (weak, nonatomic) STMenuButton *messageBtn;
// 我的
@property (weak, nonatomic) STMenuButton *mineBtn;
// 设置
@property (weak, nonatomic) STMenuButton *setingBtn;


@property (nonatomic, weak) UIButton *selectedBtn;

@property (weak, nonatomic) UIButton *wechatBtn;       //微信登陆
@property (weak, nonatomic) UIButton *phoneBtn;        //手机登陆


@property (nonatomic, assign) CGFloat  STBtnW;    //按钮宽度


@end

@implementation STLeftMenuView


#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 准备工作
        [self setUpUI];
    }
    return self;
}

- (void)setDelegate:(id<STLeftMenuViewDelegate>)delegate
{
    _delegate = delegate;
    
    //默认打开
    [self buttonTapped:self.homeBtn];
}


- (void)jumpMessage
{
    //默认打开
    [self buttonTapped:self.messageBtn];
}


- (void)setUpUI
{
    //设置背景颜色
    self.backgroundColor = [UIColor colorWithHex:0x393a40];
    
    UIImageView *cityV = [[UIImageView alloc] initWithFrame:CGRectMake(ST_LEFT_W, 50, 20, 20)];
    [cityV setImage:[UIImage imageNamed:@"menu_city"]];
    [self addSubview:cityV];
    
    //城市选择
    [self initTopUI];
    
    //按钮宽度
    _STBtnW = self.frame.size.width*(1.0 - STZoomScaleRight) - ST_LEFT_W*2;
    
    //分割线
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(ST_LEFT_W, 90, _STBtnW, 0.5)];
    [lineV setBackgroundColor:[UIColor blackColor]];
    [self addSubview:lineV];
    
    
    //首页
    STMenuButton *homeBtn = [[STMenuButton alloc] initWithFrame:CGRectMake(ST_LEFT_W, 100, _STBtnW, STBtnH) setTitle:@"   首页" normalImage:@"menu_home" selectedImage:@"menu_home_selected"];
    _homeBtn = homeBtn;
    [_homeBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _homeBtn.tag = STLeftButtonTypeHome;
    _homeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_homeBtn];
    
    
    //发现
    STMenuButton *foundBtn = [[STMenuButton alloc] initWithFrame:CGRectMake(ST_LEFT_W, CGRectGetMaxY(_homeBtn.frame)+STInterval_H, _STBtnW,  STBtnH) setTitle:@"   发现" normalImage:@"menu_found" selectedImage:@"menu_found_selected"];
    _foundBtn = foundBtn;
    
    [_foundBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _foundBtn.tag = STLeftButtonTypeFound;
    _foundBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:_foundBtn];

    [self updateLeftMenu];
}

- (void)initTopUI
{
    
    //城市选择
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityBtn = cityButton;
    _cityBtn.frame = CGRectMake(0, 50, 60, 39);
    [_cityBtn setImage:[UIImage imageNamed:@"groupon_arrow_down"] forState:UIControlStateNormal];
    _cityBtn.backgroundColor = [UIColor clearColor];
    
    //按钮右对齐
    _cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_cityBtn addTarget:self action:@selector(cictyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_cityBtn];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 50, 44)];
    _cityLabel = cityLabel;
    _cityLabel.font = [UIFont systemFontOfSize:17.0];  //UILabel的字体大小
    _cityLabel.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    _cityLabel.textColor = MAIN_TITLE_COLOR;
    _cityLabel.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
    [_cityLabel setBackgroundColor:[UIColor clearColor]];
    [_cityLabel setTextColor:[UIColor grayColor]];
    [self addSubview:_cityLabel];
    
    [_cityLabel setText:@"深圳"];
    
    //城市
    [self calculateWidthWithCityName:@"深圳"];
}


- (void)calculateWidthWithCityName:(NSString *)cName
{
    //设置一个行高上限
    CGSize size = CGSizeMake(20000, 44);
    
    //高度固定不折行，根据字的多少计算label的宽度
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:_cityLabel.font, NSFontAttributeName,nil];
    size =[cName boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    [_cityLabel setFrame:CGRectMake(70, 40, size.width, 44)];
    _cityLabel.text = cName;
    
    [_cityBtn setFrame:CGRectMake(size.width+10, 44, 80, 39)];
}

//更新UI
- (void)updateLeftMenu
{
    if (theAppDelegate.isLogin || [AccountInfo sharedAccountInfo].userId) {
        //收藏
        STMenuButton *collectionBtn = [[STMenuButton alloc] initWithFrame:CGRectMake(ST_LEFT_W, CGRectGetMaxY(_foundBtn.frame)+STInterval_H, _STBtnW, STBtnH) setTitle:@"   收藏" normalImage:@"menu_collection" selectedImage:@"menu_collection_selected"];
        _collectionBtn = collectionBtn;
        
        [_collectionBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _collectionBtn.tag = STLeftButtonTypeCollection;
        _collectionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_collectionBtn];
        
        //消息
        STMenuButton *messageBtn = [[STMenuButton alloc] initWithFrame:CGRectMake(ST_LEFT_W, CGRectGetMaxY(_collectionBtn.frame)+STInterval_H, _STBtnW, STBtnH) setTitle:@"   消息" normalImage:@"menu_message" selectedImage:@"menu_message_selected"];
        _messageBtn = messageBtn;
        
        _messageBtn.tag = STLeftButtonTypeMessage;
        [_messageBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _messageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_messageBtn];
        
        
        //我的
        STMenuButton *mineBtn = [[STMenuButton alloc] initWithFrame:CGRectMake(ST_LEFT_W, CGRectGetMaxY(_messageBtn.frame)+STInterval_H, _STBtnW, STBtnH) setTitle:@"   我的" normalImage:@"menu_mine" selectedImage:@"menu_mine_selected"];
        _mineBtn = mineBtn;
        
        _mineBtn.tag = STLeftButtonTypeMine;
        _mineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_mineBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mineBtn];
        
        //设置
        STMenuButton *setingBtn = [[STMenuButton alloc] initWithFrame:CGRectMake(ST_LEFT_W, CGRectGetMaxY(_mineBtn.frame)+STInterval_H, _STBtnW, STBtnH) setTitle:@"   设置" normalImage:@"menu_setting" selectedImage:@"menu_setting_selected"];
        _setingBtn = setingBtn;
        
        _setingBtn.tag = STLeftButtonTypeSeting;
        _setingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_setingBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_setingBtn];
    }
    else{
        //消息
        STMenuButton *messageBtn = [[STMenuButton alloc] initWithFrame:CGRectMake(ST_LEFT_W, CGRectGetMaxY(_foundBtn.frame)+STInterval_H, _STBtnW, STBtnH) setTitle:@"   消息" normalImage:@"menu_message" selectedImage:@"menu_message_selected"];
        
        _messageBtn = messageBtn;
        [_messageBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _messageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _messageBtn.tag = STLeftButtonTypeMessage;
        [self addSubview:_messageBtn];
        
        //设置
        STMenuButton *setingBtn = [[STMenuButton alloc] initWithFrame:CGRectMake(ST_LEFT_W, CGRectGetMaxY(_messageBtn.frame)+STInterval_H, _STBtnW, STBtnH) setTitle:@"   设置" normalImage:@"menu_setting" selectedImage:@"menu_setting_selected"];
        _setingBtn = setingBtn;
        [_setingBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _setingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _setingBtn.tag = STLeftButtonTypeSeting;
        [self addSubview:_setingBtn];
        
        
        //微信
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]])
        {
            UIButton *wechatBtn = [[UIButton alloc] initWithFrame:CGRectMake(ST_LEFT_W, self.frame.size.height-140, _STBtnW, 40)];
            
            _wechatBtn = wechatBtn;
            [_wechatBtn setImage:[UIImage imageNamed:@"login_wx"] forState:UIControlStateNormal];
            [_wechatBtn setTitle:@"  微信登录" forState:UIControlStateNormal];
            
            [_wechatBtn setBackgroundImage:@"btn38_green" setSelectedBackgroundImage:@"btn38_grey"];
            [_wechatBtn addTarget:self action:@selector(sender:) forControlEvents:UIControlEventTouchUpInside];
            
            [_wechatBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            _wechatBtn.layer.cornerRadius = 3;//设置那个圆角的有多圆
            _wechatBtn.layer.masksToBounds = YES;//设为NO去试试
            _wechatBtn.tag = STNormalWeiXin;
            [self addSubview:_wechatBtn];
        }
        
        //手机登陆
        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(ST_LEFT_W, self.frame.size.height-80, _STBtnW, 40)];
        _phoneBtn = phoneBtn;
        
        [_phoneBtn setImage:[UIImage imageNamed:@"login_phone"] forState:UIControlStateNormal];
        [_phoneBtn setTitle:@"  手机登录" forState:UIControlStateNormal];
        
        [_phoneBtn setBackgroundImage:@"btn38_red" setSelectedBackgroundImage:@"btn38_grey"];
        [_phoneBtn addTarget:self action:@selector(sender:) forControlEvents:UIControlEventTouchUpInside];
        
        _phoneBtn.tag = STNormalPhone;
        [_phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        _phoneBtn.layer.cornerRadius = 3;//设置那个圆角的有多圆
        _phoneBtn.layer.masksToBounds = YES;//设为NO去试试
        
        [self addSubview:_phoneBtn];
    }
}


- (void)setCityName:(NSString *)cityName
{
    [_cityLabel setText:cityName];
    //城市
    [self calculateWidthWithCityName:cityName];
}


#pragma mark - BtnAction
- (void)sender:(UIButton *)sender
{
    if (_delegate) {
        [self.delegate normaluttonClcikFrom:(STNormalButtonType)sender.tag];
    }
}


- (void)buttonTapped:(STMenuButton *)sender {
    if ([self.delegate respondsToSelector:@selector(leftMenuViewButtonClcikFrom:to:)]) {
        [self.delegate leftMenuViewButtonClcikFrom:(STLeftButtonType)self.selectedBtn.tag to:(STLeftButtonType)sender.tag];
    }
    
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
}

//cictyBtn的点击事件
- (void)cictyButtonClick:(UIButton *)sender
{
    if (_delegate) {
        [self.delegate leftMenuViewCictyButtonChange];
    }
}





@end
