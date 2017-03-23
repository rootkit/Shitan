//
//  REInlineCustomPickerItem.h
//  Shitan
//
//  Created by Richard Liu on 15/6/11.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RETableViewItem.h"

@class RECustomPickerItem;

@interface REInlineCustomPickerItem : RETableViewItem

@property (weak, readwrite, nonatomic) RECustomPickerItem *pickerItem;

+ (instancetype)itemWithPickerItem:(RECustomPickerItem *)pickerItem;
- (id)initWithPickerItem:(RECustomPickerItem *)pickerItem;

@end

