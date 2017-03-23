//
//  AlertBlock.m
//  Shitan
//
//  Created by Richard Liu on 15/4/24.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "AlertBlock.h"

@implementation AlertBlock

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles block:(TouchBlock)block{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];//注意这里初始化父类的
    if (self) {
        self.block = block;
    }
    return self;
}

//#pragma mark -AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //这里调用函数指针_block(要传进来的参数);
    _block(buttonIndex);
}

@end