//
//  SearchTableViewCell.m
//  NationalOA
//
//  Created by 刘敏 on 14-6-25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHiddenWithAccountField) name:@"keyboardHiddenWithAccountField" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.accountField){
        
        
        if([_delegate respondsToSelector:@selector(searchContentWithField:)]){
            [_delegate searchContentWithField:self.accountField.text];
        }
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.accountField resignFirstResponder];
}


#pragma mark UITextFieldDelegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    CLog(@"string = %@, range.length = %lu, range.location = %lu", string, range.length, (unsigned long)range.location);
    
    if (range.location > 0) {
        self.searchImageView.hidden = YES;
    }
    else{
        if (range.length > 1 || range.length == 0) {
            self.searchImageView.hidden = YES;
        }
        else
            self.searchImageView.hidden = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.searchImageView.hidden = NO;
    
    return YES;
}

- (void) keyboardHiddenWithAccountField{
    [self.accountField resignFirstResponder];
}


@end
