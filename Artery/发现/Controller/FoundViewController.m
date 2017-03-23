//
//  FoundViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/8/26.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FoundViewController.h"
#import "PhotoViewController.h"


@interface FoundViewController ()

@end

@implementation FoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    
    [self setNavBarRightBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"camera_icon.png" imgHighlight:nil imgSelected:nil target:self action:@selector(cameraBtn:)]];
}



- (void)cameraBtn:(id)sender
{
    if (!theAppDelegate.isLogin) {
        STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
        STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
        nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        nc.view.layer.shadowOpacity = 0.2;
        
        [self presentViewController:nc animated:YES completion:nil];
        
        return;
    }
    
    PhotoViewController * mVC = (PhotoViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"CameraStoryboard" class:[PhotoViewController class]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mVC];
    
    [self presentViewController:nav animated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
