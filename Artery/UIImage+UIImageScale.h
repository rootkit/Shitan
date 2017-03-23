//
//  UIImage+UIImageScale.h
//  Shitan
//
//  Created by 刘敏 on 14-9-23.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageScale)

//修改image的大小
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

- (UIImage *)getSubImage:(CGRect)rect;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;


// 控件截屏
+ (UIImage *)imageWithCaputureView:(UIView *)view;

@end

