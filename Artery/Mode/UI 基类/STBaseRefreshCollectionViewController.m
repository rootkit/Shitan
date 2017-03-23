//
//  STBaseRefreshCollectionViewController.m
//  Artery
//
//  Created by Avalon on 15/4/24.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STBaseRefreshCollectionViewController.h"
#import "MJRefresh.h"


@interface STBaseRefreshCollectionViewController ()

@end

@implementation STBaseRefreshCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}


#pragma mark - 是否开启上下拉刷新
- (void)setDisplayRefreshView:(BOOL)displayRefreshView{
    
    if (displayRefreshView) {
        
        [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        [self.collectionView.header beginRefreshing];
        
        [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    }
    
}


#pragma 下拉刷新更新数据
- (void)loadNewData{
    
    [self.collectionView.header endRefreshing];
    
    [self.collectionView reloadData];
    
}

#pragma 上拉刷新更多数据
- (void)loadMoreData{
    
    [self.collectionView.footer endRefreshing];
    
    [self.collectionView reloadData];
}






@end
