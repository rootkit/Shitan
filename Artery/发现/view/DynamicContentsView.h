//
//  DynamicContentView.h
//  Shitan
//
//  Created by Avalon on 15/5/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModelFrame.h" 
#import "ShopInfo.h"
#import "BubbleView.h"  

@class DynamicContentsView;

@protocol  DynamicContentsViewDelegate <NSObject>

@optional

- (void)dynamicContentsView:(DynamicContentsView *)dynamicContentsView bubbleView:(BubbleView *)bubbleView sInfo:(ShopInfo *)sInfo;

@end

@interface DynamicContentsView : UIView

@property (nonatomic, strong) DynamicModelFrame *dynamicModelFrame;

@property (nonatomic, weak) id <DynamicContentsViewDelegate>delegate;


@end
