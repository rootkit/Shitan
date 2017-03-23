//
//  STBaseRefreshCollectionViewController.h
//  Artery
//
//  Created by Avalon on 15/4/24.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STBaseRefreshCollectionViewController : UICollectionViewController

@property (nonatomic, assign) BOOL displayRefreshView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;


//上下拉刷新方法
- (void)loadMoreData;
- (void)loadNewData;

@end
