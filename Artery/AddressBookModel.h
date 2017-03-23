//
//  AddressBookModel.h
//  Shitan
//
//  Created by 刘敏 on 15/1/14.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressBookTableViewCell.h"


@interface AddressBookModel : NSObject

+ (AddressBookTableViewCell *)findCellWithTableView:(UITableView *)tableView;

@end
