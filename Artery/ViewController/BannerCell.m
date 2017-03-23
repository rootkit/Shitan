//
//  BannerCell.m
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "BannerCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define IMAGE_H_IPHONE5         200.0f
#define IMAGE_H_IPHONE6         234.0f
#define IMAGE_H_IPHONE6_Plus    259.0f





@implementation BannerCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = BACKGROUND_COLOR;
    _loadingView = [[ImageLoadingView alloc] init];
}


- (void)setCellWithCellInfo:(NSArray *)array
{
    if (array.count == 0) {
        return;
    }
    
    _bannerArray = array;
    
    CGFloat mH = 0.0f;
    
    if (MAINSCREEN.size.width == IPHONE6_PLUS_WIDTH){
        mH = IMAGE_H_IPHONE6_Plus;
    }
    else if (MAINSCREEN.size.width == IPHONE6_WIDTH) {
        mH = IMAGE_H_IPHONE6;
    }
    else
        mH = IMAGE_H_IPHONE5;
    

    _scrollView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, mH)];
    
    [_scrollView initWithCount:[array count] delegate:self];
    _scrollView.scrollInterval = 5.0f;
    
    // adjust pageControl position
    _scrollView.pageControlPosition = ICPageControlPosition_BottomRight;
    _scrollView.hidePageControl = _bannerArray.count > 1 ? NO : YES;

    [self.contentView addSubview:_scrollView];
}


#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    BannerInfo *bInfo = [_bannerArray objectAtIndex:index];
    
    if (bInfo.bannerImgUrl) {
        [_loadingView showLoading];
        [_loadingView setFrame:CGRectMake(_scrollView.frame.size.width/2, _scrollView.frame.size.height/2, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        [imageView addSubview:_loadingView];
        
        dispatch_after(0.2, dispatch_get_global_queue(0, 0), ^{
            __block ImageLoadingView *loadingView = _loadingView;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:bInfo.bannerImgUrl]
                       placeholderImage:[UIImage imageNamed:@"default_image.png"]
                                options:SDWebImageLowPriority
                               progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                   
                                   if (!loadingView) {
                                       loadingView = [[ImageLoadingView alloc] init];
                                   }
                                   
                                   if (receivedSize > kMinProgress) {
                                       loadingView.progress = (float)receivedSize/expectedSize;
                                   }
                               }
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  [loadingView removeFromSuperview];
                                  loadingView = nil;
                              }];
        });
    }
    else
        imageView.image = [UIImage imageNamed:@"default_image.png"];

}



- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    BannerInfo *bInfo = [_bannerArray objectAtIndex:index];
    if (_delegate && [_delegate respondsToSelector:@selector(bannerSelected:)]) {
        [_delegate bannerSelected:bInfo];
    }
}


@end
