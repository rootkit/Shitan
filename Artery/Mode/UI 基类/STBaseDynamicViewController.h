//
//  STBaseDynamicViewController.h
//  Shitan
//
//  Created by Richard Liu on 15/5/26.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STChildViewController.h"
#import "MJRefresh.h"
#import "DynamicModelCell.h"
#import "DynamicModelFrame.h"
#import "DynamicHeadView.h"
#import "DynamicContentsView.h"
#import "DynamicToolsbarView.h"
#import "ResultDetailsViewController.h"
#import "TipsDetailsViewController.h"
#import "UserListViewController.h"
#import "CollectionTypeViewController.h"
#import "ProfileTableViewController.h"
#import "HimselfViewController.h"
#import "CommentListViewController.h"

@interface STBaseDynamicViewController : STChildViewController<DynamicHeadViewDelegate,DynamicContentsViewDelegate,
DynamicToolsbarViewDelegate,DynamicBottomViewDelegate>

@property (nonatomic, assign) STCommntEntranceType commntEntranceType;

//点赞
- (void)hasPraise:(PraiseInfo *)pInfo cellWithRow:(NSUInteger)row;

//取消点赞
- (void)cancelPraise:(PraiseInfo *)pInfo cellWithRow:(NSUInteger)row;

//适用于隐藏/删除
- (void)dynamicToolsbarView:(DynamicToolsbarView *)dynamicToolsbarView
                    imageID:(NSString *)imageID
               indexWithRow:(NSUInteger)row;

@end
