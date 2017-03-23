//
//  FavoritesViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/8/31.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavCollectionViewController.h"
#import "FavoriteShopViewController.h"

@interface FavoritesViewController ()<ICViewPagerDataSource, ICViewPagerDelegate>


@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"我的收藏"];
    
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
        label.text = @"店铺";
    }
    else
    {
        label.text = @"美食";
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [label sizeToFit];
    
    return label;
}


- (UIViewController *)viewPager:(ICViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    if (index == 0) {
        FavoriteShopViewController *vc = [[FavoriteShopViewController alloc] init];
        return vc;
    }
    if (index == 1) {
        FavCollectionViewController *vc = [[FavCollectionViewController alloc] init];
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
