//
//  REInlineCustomPickerItem.m
//  Shitan
//
//  Created by Richard Liu on 15/6/11.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "REInlineCustomPickerItem.h"

@implementation REInlineCustomPickerItem

+ (instancetype)itemWithPickerItem:(RECustomPickerItem *)pickerItem
{
    return [[self alloc] initWithPickerItem:pickerItem];
}

- (id)initWithPickerItem:(RECustomPickerItem *)pickerItem
{
    self = [super init];
    if (self) {
        _pickerItem = pickerItem;
    }
    return self;
}

@end
