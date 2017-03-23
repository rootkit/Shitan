//
//  AboutViewController.m
//  Shitan
//
//  Created by 刘敏 on 14/12/3.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "AboutViewController.h"
#import "Harpy.h"

@interface AboutViewController ()

@end

@implementation AboutViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"关于"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"关于"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavBarTitle:@"关于我们"];
    
    [_versionLabel setText:[NSString stringWithFormat:@"V%@", APP_Version]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)checkNewVersion:(id)sender {
    [Harpy checkVersion];
}


@end
