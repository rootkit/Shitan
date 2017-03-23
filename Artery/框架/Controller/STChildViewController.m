//
//  STChildViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/8/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//  二级界面的基类

#import "STChildViewController.h"
#import "STNavigationController.h"
#import "ResetFrame.h"


@implementation STChildViewController

- (void)dealloc
{
    [ResetFrame cancelPerformRequestAndNotification:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    STNavBarView *navbar = [[STNavBarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [STNavBarView barSize].width, [STNavBarView barSize].height)];
    _navbar = navbar;
    _navbar.m_viewCtrlParent = self;
    [self.view addSubview:_navbar];
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


- (void)setNavBarLeftBtn:(UIButton *)btn
{
    if (_navbar)
    {
        [_navbar setLeftBtn:btn];
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


@end
