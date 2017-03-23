//
//  AddressBookViewController.h
//  Shitan
//
//  Created by 刘敏 on 14-11-5.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface AddressBookViewController : STChildViewController <ABNewPersonViewControllerDelegate,ABPersonViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
