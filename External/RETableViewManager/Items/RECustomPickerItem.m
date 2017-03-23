//
//  RECustomPickerItem.m
//  Shitan
//
//  Created by Richard Liu on 15/6/11.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RECustomPickerItem.h"


@implementation RECustomPickerItem
+ (instancetype)itemWithTitle:(NSString *)title value:(NSArray *)value placeholder:(NSString *)placeholder options:(NSArray *)options
{
    return [[self alloc] initWithTitle:title value:value placeholder:placeholder options:options];
}

- (id)initWithTitle:(NSString *)title value:(NSArray *)value placeholder:(NSString *)placeholder options:(NSArray *)options
{
    self = [super init];
    if (!self)
        return nil;
    
    self.title = title;
    self.value = value;
    self.style = UITableViewCellStyleValue1;
    self.placeholder = placeholder;
    self.value = value;
    self.options = options;
    
    return self;
}

#pragma mark -
#pragma mark Error validation

- (NSArray *)errors
{
    return [REValidation validateObject:self.value name:self.name ? self.name : self.title validators:self.validators];
}

@end
