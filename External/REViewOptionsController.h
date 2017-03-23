//
//  REViewOptionsController.h
//  Shitan
//
//  Created by 刘敏 on 14-11-12.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "RETableViewManager.h"


@interface REViewOptionsController : STChildViewController <RETableViewManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (weak, readwrite, nonatomic) RETableViewItem *item;
@property (strong, readwrite, nonatomic) NSArray *options;
@property (strong, readonly, nonatomic) RETableViewManager *tableViewManager;
@property (strong, readonly, nonatomic) RETableViewSection *mainSection;
@property (assign, readwrite, nonatomic) BOOL multipleChoice;
@property (copy, readwrite, nonatomic) void (^completionHandler)(void);
@property (strong, readwrite, nonatomic) RETableViewCellStyle *style;
@property (weak, readwrite, nonatomic) id<RETableViewManagerDelegate> delegate;

- (id)initWithItem:(RETableViewItem *)item options:(NSArray *)options multipleChoice:(BOOL)multipleChoice completionHandler:(void(^)(void))completionHandler;


@end
