//
//  DynamicToolsbarView.h
//  Shitan
//
//  Created by Avalon on 15/5/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModelFrame.h"

@class DynamicToolsbarView;

@protocol DynamicToolsbarViewDelegate <NSObject>

@optional

//适用于点赞/评论
- (void)dynamicToolsbarView:(DynamicToolsbarView *)dynamicToolsbarView
                  withIndex:(NSInteger)index
                DynamicInfo:(DynamicInfo *)dInfo
               indexWithRow:(NSUInteger)row;

//适用于隐藏/删除
- (void)dynamicToolsbarView:(DynamicToolsbarView *)dynamicToolsbarView
                  imageID:(NSString *)imageID
               indexWithRow:(NSUInteger)row;

@end

@interface DynamicToolsbarView : UIView

@property (nonatomic, strong) DynamicModelFrame *dynamicModelFrame;
@property (nonatomic, weak) id <DynamicToolsbarViewDelegate>delegate;

@property (nonatomic, assign) NSUInteger lineNO;


@end
