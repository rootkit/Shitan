//
//  AlertBlock.h
//  Shitan
//
//  Created by Richard Liu on 15/4/24.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertBlock;

typedef void (^TouchBlock)(NSInteger);


@interface AlertBlock : UIAlertView

@property(nonatomic,copy)TouchBlock block;

//需要自定义初始化方法，调用Block
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString*)otherButtonTitles
              block:(TouchBlock)block;

@end
