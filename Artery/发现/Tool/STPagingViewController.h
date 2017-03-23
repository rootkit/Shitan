//
//  STPagingViewController.h
//  Shitan
//
//  Created by Richard Liu on 15/6/24.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STHomeViewController.h"


typedef void(^XHDidChangedPageBlock)(NSInteger currentPage, NSString *title);

@interface STPagingViewController : STHomeViewController

// 改变页码的回调
@property (nonatomic, copy) XHDidChangedPageBlock didChangedPageCompleted;

@property (nonatomic, strong) NSArray *titleS;    //标题数组

// 控制器容器数组（最多5个）
@property (nonatomic, strong) NSArray *viewControllers;

// 获取当前页码
- (NSInteger)getCurrentPageIndex;

// 设置当前页面为你想要的页码
- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

// 设置控制器数据源，进行reload的方法
- (void)reloadData;

@end
