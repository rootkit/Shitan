//
//  STHomeViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/8/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STHomeViewController.h"
#import "STNavigationController.h"
#import "ResetFrame.h"

#define STScaleanimateWithDuration 0.3


@implementation STHomeViewController

- (void)dealloc
{
    [ResetFrame cancelPerformRequestAndNotification:self];
    _navbar.m_viewCtrlParent = nil;
    _navbar = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    STNavBarView *navbar = [[STNavBarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [STNavBarView barSize].width, [STNavBarView barSize].height)];
    _navbar = navbar;
    _navbar.m_viewCtrlParent = self;
    [self.view addSubview:_navbar];

    [_navbar setLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"navbar_left" imgHighlight:nil imgSelected:nil target:self action:@selector(openLeftMenu)]];
}


#pragma 导航条左右边按钮点击
- (void)openLeftMenu
{
    //添加遮盖,拦截用户操作
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _coverBtn = coverBtn;
    _coverBtn.frame = self.navigationController.view.bounds;
    [_coverBtn addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_coverBtn];
    
    //缩放比例
    CGFloat zoomScale = (MAINSCREEN.size.height - STScaleTopMargin * 2) / MAINSCREEN.size.height;
    //X移动距离
    CGFloat moveX = MAINSCREEN.size.width - MAINSCREEN.size.width * STZoomScaleRight;
    
    [UIView animateWithDuration:STScaleanimateWithDuration animations:^{
        
        CGAffineTransform transform = CGAffineTransformMakeScale(zoomScale, zoomScale);
        //先缩放在位移会使位移缩水,正常需要moveX/zoomScale 才是正常的比例,这里感觉宽度还好就省略此步
        self.navigationController.view.transform = CGAffineTransformTranslate(transform, moveX, 0);
        //将状态改成已经缩放
        self.isScale = YES;
    }];
}


//cover点击
- (void)coverClick
{
    [UIView animateWithDuration:STScaleanimateWithDuration animations:^{
        self.navigationController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.coverBtn removeFromSuperview];
        self.coverBtn = nil;
        self.isScale = NO;
        
        //当遮盖按钮被销毁时调用
        if (_coverDidRomove) {
            _coverDidRomove();
        }
    }];
}
     


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_navbar && !_navbar.hidden)
    {
        [self.view bringSubviewToFront:_navbar];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [theAppDelegate.HUDManager hideHUD];
}

#pragma mark -
- (void)bringNavBarToTopmost
{
    if (_navbar)
    {
        [self.view bringSubviewToFront:_navbar];
    }
}

- (void)hideNavBar:(BOOL)bIsHide
{
    _navbar.hidden = bIsHide;
}

- (void)setNavBarTitle:(NSString *)strTitle
{
    if (_navbar)
    {
        [_navbar setTitle:strTitle];
    }
    else{
        CLog(@"APP_ASSERT_STOP");
        NSAssert1(NO, @" \n\n\n===== APP Assert. =====\n%s\n\n\n", __PRETTY_FUNCTION__);
    }
}


- (void)setNavBarRightBtn:(UIButton *)btn
{
    if (_navbar)
    {
        [_navbar setRightBtn:btn];
    }
}

- (void)navBarAddCoverView:(UIView *)view
{
    if (_navbar && view)
    {
        [_navbar showCoverView:view animation:YES];
    }
}


- (void)navBarAddCoverViewOnTitleView:(UIView *)view
{
    if (_navbar && view)
    {
        [_navbar showCoverViewOnTitleView:view];
    }
}


- (void)navBarRemoveCoverView:(UIView *)view
{
    if (_navbar)
    {
        [_navbar hideCoverView:view];
    }
}


// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)canDragBack
{
    if (self.navigationController)
    {
        [((STNavigationController *)(self.navigationController)) navigationCanDragBack:canDragBack];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
