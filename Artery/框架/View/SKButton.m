//
//  SKButton.m
//  Shitan
//
//  Created by Richard Liu on 15/9/25.
//  Copyright © 2015年 刘 敏. All rights reserved.
//

#import "SKButton.h"

@implementation SKButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    NSString *st = [NSString stringWithFormat:@" %@", title];
    
    [super setTitle:st forState:state];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -18, 0, 0)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width - 14, 0, 0)];

    [self layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted{}



@end
