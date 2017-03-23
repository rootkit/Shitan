//
//  HostViewController.m
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import "HostViewController.h"
#import "TipsDetailsViewController.h"

@interface HostViewController () <ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation HostViewController

- (void)viewDidLoad {
    
    self.dataSource = self;
    self.delegate = self;
    
    _isFirst = NO;
    self.title = @"图片详情";

    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _tableArray.count;
}


- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = [NSString stringWithFormat:@"Content View #%lu", (unsigned long)index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    if (!_isFirst) {
        index = self.m_row;
        
        _isFirst = YES;
    }
    
    DynamicInfo *dyInfo = [[DynamicInfo alloc] initWithParsData:[_tableArray objectAtIndex:index]];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    TipsDetailsViewController *tipVC = [board instantiateViewControllerWithIdentifier:@"TipsDetailsViewController"];
    
    //美食日记图片点击
    tipVC.m_Type = SecondTypeTips;
    tipVC.isHideNav = YES;
    tipVC.hostVC = self;

    tipVC.dyInfo = dyInfo;
    return tipVC;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 1.0;
            break;
            
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
            
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
            
        default:
            break;
    }
    
    return value;
}


- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor redColor] colorWithAlphaComponent:0.64];
            break;
            
        default:
            break;
    }
    
    return color;
}

@end
