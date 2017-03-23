//
//  HorizontalScrollCell.h
//  Shitan
//
//  Created by Richard Liu on 15/4/26.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollCellDelegate;

@interface HorizontalScrollCell : UITableViewCell

@property (nonatomic, assign) id<HorizontalScrollCellDelegate> delegate;

@property (nonatomic, weak) UIView *pageView;
@property (nonatomic, weak) UIScrollView *scroll;

//初始化cell中的Data
- (void)setUpCellWithArray:(NSArray *)array;

@end


@protocol HorizontalScrollCellDelegate <NSObject>

@required

//ScrollView中图片点击
- (void)horizontalScrollCell:(HorizontalScrollCell *)hCell row:(NSUInteger)row;

//点击的是否是首个按钮
- (void)horizontalScrollCell:(HorizontalScrollCell *)hCell isFirst:(BOOL)isFirst;

@end
