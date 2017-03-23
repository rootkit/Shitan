//
//  DynamicBottomView.h
//  Shitan
//
//  Created by Avalon on 15/5/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModelFrame.h"

@class DynamicBottomView;

@protocol  DynamicBottomViewDelegate <NSObject>

@optional

- (void)dynamicBottomView:(DynamicBottomView *)dynamicBottomView
               WithUserId:(NSString *)userId;

- (void)dynamicBottomView:(DynamicBottomView *)dynamicBottomView
              WithImageId:(NSString *)imageId;

- (void)dynamicBottomView:(DynamicBottomView *)dynamicBottomView
               WithUserId:(NSString *)userId
                  ImageId:(NSString *)imageId
              cellWithRow:(NSUInteger)row;

@end


@interface DynamicBottomView : UIView

@property (nonatomic, strong) DynamicModelFrame *dynamicModelFrame;

@property (nonatomic, weak) id<DynamicBottomViewDelegate>delegate;

@property (nonatomic, assign) NSUInteger lineNO;

@end
