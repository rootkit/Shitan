//
//  RECustomPickerCell.h
//  Shitan
//
//  Created by Richard Liu on 15/6/11.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RETableViewCell.h"
#import "RECustomPickerItem.h"


@interface RECustomPickerCell : RETableViewCell <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, readonly, nonatomic) UITextField *textField;
@property (strong, readonly, nonatomic) UILabel *valueLabel;
@property (strong, readonly, nonatomic) UILabel *placeholderLabel;
@property (strong, readonly, nonatomic) UIPickerView *pickerView;

@property (strong, readwrite, nonatomic) RECustomPickerItem *item;

@end
