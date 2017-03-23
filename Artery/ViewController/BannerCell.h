//
//  BannerCell.h
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePlayerView.h"
#import "BannerInfo.h"
#import "ImageLoadingView.h"

@protocol BannerCellDelegate;

@interface BannerCell : UITableViewCell<ImagePlayerViewDelegate>

@property (strong, nonatomic) ImagePlayerView   *scrollView;
@property (strong, nonatomic) NSArray           *bannerArray;
@property (strong, nonatomic) UIPageControl     *pageControl;

//等待加载图片
@property (nonatomic, strong) ImageLoadingView *loadingView;

@property (weak, nonatomic) id<BannerCellDelegate> delegate;



- (void)setCellWithCellInfo:(NSArray *)array;

@end

@protocol BannerCellDelegate <NSObject>

- (void)bannerSelected:(BannerInfo *)sInfo;

@end
