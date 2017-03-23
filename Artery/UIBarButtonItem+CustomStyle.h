//
//  UIBarButtonItem+CustomStyle.h
//  NationalOA
//
//  Created by apple on 14-8-24.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CustomStyle)


+ (id)customWithImageName:(NSString *)imageName
                   target:(id)target
                   action:(SEL)actMethod;


+ (id)customWithTitle:(NSString *)title
               target:(id)target
               action:(SEL)actMethod;

@end
