//
//  RECustomPickerItem.h
//  Shitan
//
//  Created by Richard Liu on 15/6/11.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RETableViewItem.h"
#import "REInlineCustomPickerItem.h"


@interface RECustomPickerItem : RETableViewItem

@property (strong, readwrite, nonatomic) NSArray *options;
@property (strong, readwrite, nonatomic) NSArray *value;
@property (copy, readwrite, nonatomic) NSString *placeholder;
@property (assign, readwrite, nonatomic) BOOL inlinePicker;
@property (strong, readwrite, nonatomic) REInlineCustomPickerItem *inlinePickerItem;
@property (copy, readwrite, nonatomic) void (^onChange)(RECustomPickerItem *item);

+ (instancetype)itemWithTitle:(NSString *)title value:(NSArray *)value placeholder:(NSString *)placeholder options:(NSArray *)options;

- (id)initWithTitle:(NSString *)title value:(NSArray *)value placeholder:(NSString *)placeholder options:(NSArray *)options;

@end
