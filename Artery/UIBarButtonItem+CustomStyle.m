//
//  UIBarButtonItem+CustomStyle.m
//  NationalOA
//
//  Created by apple on 14-8-24.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "UIBarButtonItem+CustomStyle.h"

@implementation UIBarButtonItem (CustomStyle)

+ (id)customWithImageName:(NSString *)imageName
                   target:(id)target
                   action:(SEL)actMethod
{
    return [[UIBarButtonItem alloc] initWithCustomView:
            [self navigationItemBtnInitWithNormalImageNamed:imageName                                                                            andHighlightedImageNamed:nil target:target action:actMethod]];
}


+ (id)customWithTitle:(NSString *)title target:(id)target action:(SEL)actMethod {
    return [[UIBarButtonItem alloc] initWithCustomView:
            [self navigationItemBtnInitWithTitle:title target:target action:actMethod]];
}





// 文字按钮
+ (UIButton *)navigationItemBtnInitWithTitle:(NSString*)title
                                      target:(id)target
                                      action:(SEL)actMethod
{
    UIButton* itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont* font = [UIFont boldSystemFontOfSize:15];
    CGSize titlesize = [title sizeWithFont:font];
    itemBtn.frame = CGRectMake(0, 0, titlesize.width+20, 30);
    [itemBtn setTitle:title forState:UIControlStateNormal];
    itemBtn.titleLabel.font = font;
    
    [itemBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [itemBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [itemBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    
    [itemBtn addTarget:target action:actMethod forControlEvents:UIControlEventTouchUpInside];
    
    return itemBtn;
}

// 图片按钮
+ (UIButton *)navigationItemBtnInitWithNormalImageNamed:(NSString*)normalImageName
                               andHighlightedImageNamed:(NSString*)highlighedImageName
                                                 target:(id)target
                                                 action:(SEL)actMethod
{
    UIButton* itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:normalImageName];
    itemBtn.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    
    [itemBtn setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [itemBtn setBackgroundImage:[UIImage imageNamed:highlighedImageName] forState:UIControlStateHighlighted];
    [itemBtn addTarget:target action:actMethod forControlEvents:UIControlEventTouchUpInside];
    
    return itemBtn;
}







@end
