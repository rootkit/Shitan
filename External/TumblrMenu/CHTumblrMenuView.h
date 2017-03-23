//
//  CHTumblrMenuView.h
//  NationalOA
//
//  Created by 刘敏 on 14-7-30.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.


#import <UIKit/UIKit.h>

typedef void (^CHTumblrMenuViewSelectedBlock)(void);

@protocol CHTumblrMenuViewDelegate;

@interface CHTumblrMenuView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<CHTumblrMenuViewDelegate> delegate;

- (void)addMenuItemWithTitle:(NSString*)title andIcon:(UIImage*)icon
                addLightIcon:(UIImage *)lightIcon
            andSelectedBlock:(CHTumblrMenuViewSelectedBlock)block;

- (void)show;

@end


@protocol CHTumblrMenuViewDelegate <NSObject>

- (void)notClickwithCHTumblrMenuButton;

@end

