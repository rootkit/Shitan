//
//  MessageViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-9-16.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "MessageViewController.h"
#import "BroadcastViewController.h"
#import "NoticeViewController.h"

@interface MessageViewController ()<ICViewPagerDataSource, ICViewPagerDelegate>

@end


@implementation MessageViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"消息"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"消息"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"消息"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataSource = self;
    self.delegate = self;
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
}


#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ICViewPagerController *)viewPager {
    return 2;
}

- (UIView *)viewPager:(ICViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.tag = 10000+index;
    if (index == 0) {
        label.text = @"广播";
    }
    else
    {
        label.text = @"通知";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [label sizeToFit];
    
    return label;
}


- (UIViewController *)viewPager:(ICViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    if (index == 0) {
        BroadcastViewController *vc = [[BroadcastViewController alloc] init];
        return vc;
    }
    if (index == 1) {
        NoticeViewController *vc = [[NoticeViewController alloc] init];
        return vc;
    }
    
    return nil;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ICViewPagerController *)viewPager valueForOption:(ICViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ICViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ICViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ICViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    return value;
}



- (UIColor *)viewPager:(ICViewPagerController *)viewPager colorForComponent:(ICViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ICViewPagerIndicator:
            return [MAIN_COLOR colorWithAlphaComponent:1.0];
            break;
        default:
            break;
    }
    
    return color;
}


- (void)viewPager:(ICViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    if (index == 0) {
        UILabel *leftL = (UILabel *)[viewPager.view viewWithTag:10000];
        [leftL setTextColor:MAIN_COLOR];
        
        
        UILabel *rightL = (UILabel *)[viewPager.view viewWithTag:10001];
        [rightL setTextColor:[UIColor grayColor]];
    }
    else if(index == 1)
    {
        UILabel *leftL = (UILabel *)[viewPager.view viewWithTag:10001];
        [leftL setTextColor:MAIN_COLOR];
        
        
        UILabel *rightL = (UILabel *)[viewPager.view viewWithTag:10000];
        [rightL setTextColor:[UIColor grayColor]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
