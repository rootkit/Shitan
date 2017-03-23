//
//  ShopToolView.h
//  Shitan
//
//  Created by Richard Liu on 15/8/29.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolModelFrame.h"

@protocol  ShopToolViewDelegate;

@interface ShopToolView : UIView

@property (nonatomic, weak) id<ShopToolViewDelegate> delegate;
@property (nonatomic, strong) ToolModelFrame *headFrame;

@end


@protocol  ShopToolViewDelegate <NSObject>

- (void)shopToolView:(ShopToolView *)shopToolView btnWithTag:(NSUInteger )index;

@end