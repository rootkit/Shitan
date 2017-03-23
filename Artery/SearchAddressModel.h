//
//  SearchAddressModel.h
//  Shitan
//
//  Created by RichardLiu on 15/2/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchAddressTableViewCell.h"

@interface SearchAddressModel : NSObject

+ (SearchAddressTableViewCell *)findCellWithTableView:(UITableView *)tableView;

@end
