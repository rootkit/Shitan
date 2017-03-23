//
//  RatingBar.h
//  MyRatingBar
//
//  Created by Leaf on 14-8-28.
//  Copyright (c) 2014年 Leaf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RatingBarDelegate <NSObject>

- (void)ratingBarWithStarNumber:(NSInteger)num;

@end


@interface RatingBar : UIView

@property (nonatomic, unsafe_unretained) id<RatingBarDelegate>delegate;

/**
 *  星星的个数
 */
@property (nonatomic,assign) NSInteger starNumber;

/*
 *调整底部视图的颜色
 */
@property (nonatomic,strong) UIColor *viewColor;

/*
 *是否允许可触摸
 */
@property (nonatomic,assign) BOOL enable;


@end
