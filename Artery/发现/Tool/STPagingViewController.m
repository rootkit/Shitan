//
//  STPagingViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/6/24.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STPagingViewController.h"
#import "STBaseHomeTableViewController.h"

#define MENU_WIDTH  140                     //顶部菜单宽度
#define MENU_HEIGHT 36                      //顶部菜单高度
#define MENU_BUTTON_WIDTH  70               //菜单按钮宽度

#define MIN_MENU_FONT  15.f                 //小号字体
#define MAX_MENU_FONT  18.f                 //大号字体

@interface STPagingViewController ()<UIScrollViewDelegate>

// 显示内容的容器
@property (nonatomic, strong) UIScrollView *paggingScrollView;
@property (nonatomic, strong) UIScrollView *navScrollV;         //顶部标题

// 标识当前页码
@property (nonatomic, assign) NSInteger currentPage;            //当前page
@property (nonatomic, assign) NSInteger lastPage;

@end

@implementation STPagingViewController



- (void)dealloc {
    
    self.paggingScrollView.delegate = nil;
    self.paggingScrollView = nil;
    
    self.viewControllers = nil;
    
    self.didChangedPageCompleted = nil;
    
    
    for(STBaseHomeTableViewController *tempVC in _viewControllers)
    {
        [tempVC willMoveToParentViewController:nil];
        [tempVC.view removeFromSuperview];
        [tempVC removeFromParentViewController];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect scrollViewFrame = self.paggingScrollView.frame;
    scrollViewFrame.size.height = self.view.frame.size.height;
    self.paggingScrollView.frame = scrollViewFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    
    [self.view addSubview:self.paggingScrollView];
    
    [self reloadData];
}

- (void)initNavBar
{
    /*********************************** 顶部菜单 ********************************/
    _navScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width/2 - MENU_BUTTON_WIDTH, 24, MENU_WIDTH, MENU_HEIGHT)];
    [_navScrollV setShowsHorizontalScrollIndicator:NO];
    _navScrollV.scrollsToTop = NO;
    
    for (int i = 0; i < [_titleS count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(MENU_BUTTON_WIDTH * i, 0, MENU_BUTTON_WIDTH, MENU_HEIGHT)];
        [btn setTitle:[_titleS objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.tag = i + 1;
        
        if(i==0)
        {
            [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:MAX_MENU_FONT]];
        }
        else{
            [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:MIN_MENU_FONT]];
        }
        
        [btn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_navScrollV addSubview:btn];
    }
    
    [_navScrollV setContentSize:CGSizeMake(MENU_BUTTON_WIDTH * [_titleS count], MENU_HEIGHT)];
    
    [self.navbar addSubview:_navScrollV];
}


- (void)actionBtn:(UIButton *)btn
{
    CLog(@"%d", btn.tag);
    CLog(@"%.2f", _paggingScrollView.frame.size.width * (btn.tag - 1));
    
    
    [_paggingScrollView scrollRectToVisible:CGRectMake(_paggingScrollView.frame.size.width * (btn.tag - 1), _paggingScrollView.frame.origin.y, _paggingScrollView.frame.size.width, _paggingScrollView.frame.size.height) animated:YES];
    
    float xx = _paggingScrollView.frame.size.width * (btn.tag - 1) * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
    [_navScrollV scrollRectToVisible:CGRectMake(xx, 0, _navScrollV.frame.size.width, _navScrollV.frame.size.height) animated:YES];
}


#pragma mark - DataSource
- (NSInteger)getCurrentPageIndex {
    return self.currentPage;
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    self.currentPage = currentPage;
    
    CGFloat pageWidth = CGRectGetWidth(self.paggingScrollView.frame);
    
    CGPoint contentOffset = self.paggingScrollView.contentOffset;
    contentOffset.x = currentPage * pageWidth;
    [self.paggingScrollView setContentOffset:contentOffset animated:animated];
}

- (void)reloadData {
    if (!self.viewControllers.count) {
        return;
    }
    
    [self.paggingScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        CGRect contentViewFrame = viewController.view.bounds;
        contentViewFrame.origin.y = 0;
        contentViewFrame.origin.x = idx * CGRectGetWidth(self.view.bounds);
        viewController.view.frame = contentViewFrame;
        [self.paggingScrollView addSubview:viewController.view];
        [self addChildViewController:viewController];
    }];
    
    [self.paggingScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds) * self.viewControllers.count, MAINSCREEN.size.height)];
    
    [self setupScrollToTop];
    
    [self callBackChangedPage];
}


#pragma mark - Propertys
- (UIScrollView *)paggingScrollView {
    if (!_paggingScrollView) {
        _paggingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _paggingScrollView.bounces = NO;
        _paggingScrollView.pagingEnabled = YES;
        [_paggingScrollView setScrollsToTop:NO];
        _paggingScrollView.delegate = self;
        _paggingScrollView.showsVerticalScrollIndicator = NO;
        _paggingScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _paggingScrollView;
}


- (UIViewController *)getPageViewControllerAtIndex:(NSInteger)index {
    if (index < self.viewControllers.count) {
        return self.viewControllers[index];
    } else {
        return nil;
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage == currentPage)
        return;
    _lastPage = _currentPage;
    _currentPage = currentPage;
    
    [self setupScrollToTop];
    [self callBackChangedPage];
}



#pragma mark - Block Call Back Method
- (void)callBackChangedPage {
    UIViewController *fromViewController = [self.viewControllers objectAtIndex:self.lastPage];
    UIViewController *toViewController = [self.viewControllers objectAtIndex:self.currentPage];
    
    [fromViewController viewWillDisappear: true];
    [fromViewController viewDidDisappear: true];
    [toViewController viewWillAppear: true];
    [toViewController viewDidAppear: true];
    
    if (self.didChangedPageCompleted) {
        self.didChangedPageCompleted(self.currentPage, [[self.viewControllers valueForKey:@"title"] objectAtIndex:self.currentPage]);
    }
}

#pragma mark - TableView Helper Method
- (void)setupScrollToTop {
    for (int i = 0; i < self.viewControllers.count; i ++) {
        UITableView *tableView = (UITableView *)[self subviewWithClass:[UITableView class] onView:[self getPageViewControllerAtIndex:i].view];
        if (tableView) {
            if (self.currentPage == i) {
                [tableView setScrollsToTop:YES];
            } else {
                [tableView setScrollsToTop:NO];
            }
        }
    }
}


#pragma mark - View Helper Method
- (UIView *)subviewWithClass:(Class)cuurentClass onView:(UIView *)view {
    
    for (UIView *subView in view.subviews) {
        if ([subView.superview isKindOfClass:cuurentClass]) {
            return subView.superview;
        }
    }
    return nil;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeView:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 得到每页宽度
    CGFloat pageWidth = CGRectGetWidth(self.paggingScrollView.frame);
    
    // 根据当前的x坐标和页宽度计算出当前页数
    self.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    float xx = scrollView.contentOffset.x * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
    [_navScrollV scrollRectToVisible:CGRectMake(xx, 0, _navScrollV.frame.size.width, _navScrollV.frame.size.height) animated:YES];
}

- (void)changeView:(CGFloat)x
{
    CGFloat xx = x * (MENU_BUTTON_WIDTH / self.view.frame.size.width);
    
    CGFloat startX = xx;
    int sT = (x)/_paggingScrollView.frame.size.width + 1;
    
    if (sT <= 0)
    {
        return;
    }
    UIButton *btn = (UIButton *)[_navScrollV viewWithTag:sT];
    float percent = (startX - MENU_BUTTON_WIDTH * (sT - 1))/MENU_BUTTON_WIDTH;
    float value = [Units lerp:(1 - percent) min:MIN_MENU_FONT max:MAX_MENU_FONT];
    btn.titleLabel.font = [UIFont systemFontOfSize:value];
    [self changeColorForButton:btn red:(1 - percent)];
    
    if((int)xx%MENU_BUTTON_WIDTH == 0)
        return;
    UIButton *btn2 = (UIButton *)[_navScrollV viewWithTag:sT + 1];
    float value2 = [Units lerp:percent min:MIN_MENU_FONT max:MAX_MENU_FONT];
    btn2.titleLabel.font = [UIFont systemFontOfSize:value2];
    [self changeColorForButton:btn2 red:percent];
}



- (void)changeColorForButton:(UIButton *)btn red:(CGFloat)nRedPercent
{
    if (nRedPercent > 0.50000) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
