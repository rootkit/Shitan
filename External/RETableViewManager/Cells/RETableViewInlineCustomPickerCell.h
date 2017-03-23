//
//  RETableViewInlineCustomPickerCell.h
//  Shitan
//
//  Created by Richard Liu on 15/6/11.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RETableViewCell.h"
#import "REInlineCustomPickerItem.h"

@interface RETableViewInlineCustomPickerCell : RETableViewCell<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, readwrite, nonatomic) REInlineCustomPickerItem *item;

@end
