//
//  STBaseHomeTableViewController.h
//  Shitan
//
//  Created by Avalon on 15/4/23.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
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


@interface STBaseHomeTableViewController : UITableViewController<DynamicHeadViewDelegate, DynamicContentsViewDelegate,
DynamicToolsbarViewDelegate, DynamicBottomViewDelegate>

//是否使用上下拉刷新控件
@property (nonatomic, assign) BOOL displayRefreshView;
@property (nonatomic, strong) CoreDataManage *coreDataMange;
@property (nonatomic, strong) NSMutableArray *dynamicModelFrames;
@property (nonatomic, assign) STCommntEntranceType commntEntranceType;


- (void)loadNewData;

- (void)loadMoreData;

//读取数据库
- (void)readData;

- (void)initCoreData;

//写入数据
- (void)writeDate:(NSArray *)array;

//适用于隐藏/删除
- (void)dynamicToolsbarView:(DynamicToolsbarView *)dynamicToolsbarView
                DynamicInfo:(DynamicInfo *)dInfo
               indexWithRow:(NSUInteger)row;


//点赞
- (void)hasPraise:(PraiseInfo *)pInfo cellWithRow:(NSUInteger)row;

//取消点赞
- (void)cancelPraise:(PraiseInfo *)pInfo cellWithRow:(NSUInteger)row;




@end
