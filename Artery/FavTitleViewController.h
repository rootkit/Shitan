//
//  FavTitleViewController.h
//  Shitan
//
//  Created by 刘敏 on 14/12/16.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "FavInfo.h"


@protocol FavTitleViewControllerDelegate;

@interface FavTitleViewController : STChildViewController

@property (nonatomic, weak) id<FavTitleViewControllerDelegate>delegate;
@property (strong, readonly, nonatomic) RETableViewManager *manager;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

//收藏夹标题
@property (strong, nonatomic) FavInfo* favInfo;

@end


@protocol FavTitleViewControllerDelegate <NSObject>

- (void)updateFavTitle:(NSString *)title;

@end
