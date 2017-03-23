//
//  MarkViewController.h
//  Artery
//
//  Created by 刘敏 on 14-9-25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkInfo.h"

@protocol MarkViewControllerDelegate;

@interface MarkViewController : STChildViewController

@property (nonatomic, weak) id<MarkViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableview;

@end

@protocol MarkViewControllerDelegate<NSObject>

- (void)markViewControllerSelected:(MarkInfo *)mInfo;

@required

@end
