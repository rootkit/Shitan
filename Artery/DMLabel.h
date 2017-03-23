//
//  DMLabel.h
//  Shitan
//
//  Created by 刘敏 on 14-10-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMLabel : UILabel
{
    CGFloat     characterSpacing_;       //字间距
    long        linesSpacing_;           //行间距
}

@property(nonatomic, assign) CGFloat characterSpacing;
@property(nonatomic, assign) long    linesSpacing;

/*
 *绘制前获取label高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width;

@end
