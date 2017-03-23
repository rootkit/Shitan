//
//  STNavBarView.m
//  Shitan
//
//  Created by Richard Liu on 15/8/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STNavBarView.h"
#import "ResetFrame.h"


#define NavBar_Title_Width                  190.0f            //标题宽度
#define NavBar_Title_Height                 40.0f             //标题高度

#define NavBar_BarButton_Width              64.0f             //按钮宽度
#define NavBar_BarButton_Height             40.0f             //按钮高度

#define NavBar_BarButton_Right_Width        -6.0f

@interface STNavBarView ()

@property (nonatomic, readonly) UIButton        *m_btnBack;       //返回按钮
@property (nonatomic, readonly) UILabel         *m_labelTitle;    //标题
@property (nonatomic, readonly) UIImageView     *m_imgViewBg;     //背景图片
@property (nonatomic, readonly) UIButton        *m_btnLeft;       //左侧按钮
@property (nonatomic, readonly) UIButton        *m_btnRight;      //右侧按钮
@property (nonatomic, readonly) BOOL            m_bIsBlur;        //是否有模糊效果

@end

@implementation STNavBarView

@synthesize m_btnBack       = _btnBack;
@synthesize m_labelTitle    = _labelTitle;
@synthesize m_imgViewBg     = _imgViewBg;
@synthesize m_btnLeft       = _btnLeft;
@synthesize m_btnRight      = _btnRight;
@synthesize m_bIsBlur       = _bIsBlur;

+ (CGRect)rightBtnFrame
{
    return CGRectMake((MAINSCREEN.size.width - NavBar_BarButton_Width - NavBar_BarButton_Right_Width), 22.0f, NavBar_BarButton_Width, NavBar_BarButton_Height);
}

+ (CGSize)barBtnSize
{
    return CGSizeMake(NavBar_BarButton_Width, NavBar_BarButton_Height);
}

+ (CGSize)barSize
{
    return CGSizeMake(MAINSCREEN.size.width, 64.0f);
}

+ (CGRect)titleViewFrame
{
    return CGRectMake((MAINSCREEN.size.width-NavBar_Title_Width)/2, 22.0f, NavBar_Title_Width, NavBar_Title_Height);
}

// 创建一个导航条按钮：使用默认的按钮图片。
+ (UIButton *)createNormalNaviBarBtnByTitle:(NSString *)strTitle target:(id)target action:(SEL)action
{
    UIButton *btn = [[self class] createImgNaviBarBtnByImgNormal:nil imgHighlight:nil target:target action:action];
    
    [btn setTitle:strTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [ResetFrame label:btn.titleLabel setMinFontSize:14.0f numberOfLines:1];
    
    return btn;
}

// 创建一个导航条按钮：自定义按钮图片。
+ (UIButton *)createImgNaviBarBtnByImgNormal:(NSString *)strImg imgHighlight:(NSString *)strImgHighlight target:(id)target action:(SEL)action
{
    return [[self class] createImgNaviBarBtnByImgNormal:strImg imgHighlight:strImgHighlight imgSelected:strImg target:target action:action];
}


+ (UIButton *)createImgNaviBarBtnByImgNormal:(NSString *)strImg imgHighlight:(NSString *)strImgHighlight imgSelected:(NSString *)strImgSelected target:(id)target action:(SEL)action
{
    UIImage *imgNormal = [UIImage imageNamed:strImg];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:imgNormal forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:(strImgHighlight ? strImgHighlight : strImg)] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:(strImgSelected ? strImgSelected : strImg)] forState:UIControlStateSelected];
    
    CGFloat fDeltaWidth = ([[self class] barBtnSize].width - imgNormal.size.width)/2.0f;
    CGFloat fDeltaHeight = ([[self class] barBtnSize].height - imgNormal.size.height)/2.0f;
    fDeltaWidth = (fDeltaWidth >= 2.0f) ? fDeltaWidth/2.0f : 0.0f;
    fDeltaHeight = (fDeltaHeight >= 2.0f) ? fDeltaHeight/2.0f : 0.0f;
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(fDeltaHeight, fDeltaWidth, fDeltaHeight, fDeltaWidth)];
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(fDeltaHeight, -imgNormal.size.width, fDeltaHeight, fDeltaWidth)];
    
    return btn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bIsBlur = (isIOS7 && [ResetFrame is4InchScreen]);
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    // 默认左侧显示返回按钮
    _btnBack = [[self class] createImgNaviBarBtnByImgNormal:@"nav_back" imgHighlight:nil target:self action:@selector(btnBack:)];
    
    _imgViewBg = [[UIImageView alloc] initWithFrame:self.bounds];
    _imgViewBg.image = [[UIImage imageNamed:@"bg_navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    _imgViewBg.alpha = 1.0f;
    
    [self addSubview:_imgViewBg];

    _labelTitle = [[UILabel alloc] initWithFrame:[[self class] titleViewFrame]];
    _labelTitle.backgroundColor = [UIColor clearColor];
    _labelTitle.textColor = [UIColor blackColor];
    _labelTitle.font = [UIFont boldSystemFontOfSize:18.0];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    //标题
    [self addSubview:_labelTitle];

    // 返回按钮
    [self setLeftBtn:_btnBack];
}


- (void)setTitle:(NSString *)strTitle
{
    [_labelTitle setText:strTitle];
}


- (void)setLeftBtn:(UIButton *)btn
{
    if (_btnLeft)
    {
        [_btnLeft removeFromSuperview];
        
        _btnLeft = nil;
    }
    
    _btnLeft = btn;
    
    if (_btnLeft)
    {
        _btnLeft.frame = CGRectMake(-10.0f, 22.0f, [[self class] barBtnSize].width, [[self class] barBtnSize].height);
        [self addSubview:_btnLeft];
    }
}

- (void)setRightBtn:(UIButton *)btn
{
    if (_btnRight)
    {
        [_btnRight removeFromSuperview];
        _btnRight = nil;
    }
    
    _btnRight = btn;
    
    if (_btnRight)
    {
        _btnRight.frame = [[self class] rightBtnFrame];
        [self addSubview:_btnRight];
    }
}


// 设置右侧按钮标题
- (void)setRightBtnTitle:(NSString *)strTitle{
    if (_btnRight)
    {
        [_btnRight setTitle:strTitle forState:UIControlStateNormal];
    }
}


- (void)btnBack:(id)sender
{
    if (self.m_viewCtrlParent)
    {
        [self.m_viewCtrlParent.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        CLog(@"APP_ASSERT_STOP");
        NSAssert1(NO, @" \n\n\n===== APP Assert. =====\n%s\n\n\n", __PRETTY_FUNCTION__);
        
    }
}

- (void)showCoverView:(UIView *)view
{
    [self showCoverView:view animation:NO];
}


- (void)showCoverView:(UIView *)view animation:(BOOL)bIsAnimation
{
    if (view)
    {
        [self hideOriginalBarItem:YES];
        
        [view removeFromSuperview];
        
        view.alpha = 0.4f;
        [self addSubview:view];
        if (bIsAnimation)
        {
            [UIView animateWithDuration:0.2f animations:^()
             {
                 view.alpha = 1.0f;
             }completion:^(BOOL f){}];
        }
        else
        {
            view.alpha = 1.0f;
        }
    }
    else{
        CLog(@"APP_ASSERT_STOP");
        NSAssert1(NO, @" \n\n\n===== APP Assert. =====\n%s\n\n\n", __PRETTY_FUNCTION__);
    }
}

- (void)showCoverViewOnTitleView:(UIView *)view
{
    if (view)
    {
        if (_labelTitle)
        {
            _labelTitle.hidden = YES;
        }else{}
        
        [view removeFromSuperview];
        view.frame = _labelTitle.frame;
        
        [self addSubview:view];
    }
    else{
        CLog(@"APP_ASSERT_STOP");
        NSAssert1(NO, @" \n\n\n===== APP Assert. =====\n%s\n\n\n", __PRETTY_FUNCTION__);
    }
}

- (void)hideCoverView:(UIView *)view
{
    [self hideOriginalBarItem:NO];
    
    if (view && (view.superview == self))
    {
        [view removeFromSuperview];
    }
}

#pragma mark -
- (void)hideOriginalBarItem:(BOOL)bIsHide
{
    if (_btnLeft)
    {
        _btnLeft.hidden = bIsHide;
    }
    
    if (_btnBack)
    {
        _btnBack.hidden = bIsHide;
    }
    
    if (_btnRight)
    {
        _btnRight.hidden = bIsHide;
    }
    
    if (_labelTitle)
    {
        _labelTitle.hidden = bIsHide;
    }
}

- (void)dealloc
{
    if (_m_viewCtrlParent) {
        [_m_viewCtrlParent willMoveToParentViewController:nil];
        [_m_viewCtrlParent.view removeFromSuperview];
        [_m_viewCtrlParent removeFromParentViewController];
    }
}

@end
