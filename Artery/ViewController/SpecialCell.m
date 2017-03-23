//
//  SpecialCell.m
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "SpecialCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ImageEffects.h"



@implementation SpecialCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = BACKGROUND_COLOR;
    
    _loadingView = [[ImageLoadingView alloc] init];
    
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, MAINSCREEN.size.width-20, MAINSCREEN.size.width-10)];
    // 圆角
    _imageV.layer.cornerRadius = 6;//设置那个圆角的有多圆
    _imageV.layer.masksToBounds = YES;//设为NO去试试
    
    [self.contentView addSubview:_imageV];
}


- (void)setCellWithCellInfo:(BannerInfo *)sInfo
{
    
    if (sInfo.coverImgUrl) {
        [self configureView:sInfo.coverImgUrl];
    }
    else {
        _imageV.image = [UIImage imageNamed:@"default_image.png"];
    }
    
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, _imageV.frame.size.height - 54, _imageV.frame.size.width, 54)];
    [bottomV setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [_imageV addSubview:bottomV];
    
    
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _imageV.frame.size.width-20, 34)];
    [titLabel setTextColor:[UIColor whiteColor]];
    [titLabel setText:sInfo.title];
    [titLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [bottomV addSubview:titLabel];
    
    UILabel *partLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageV.frame.size.width-120, 28, 110, 20)];
    [partLabel setTextColor:[UIColor whiteColor]];
    [partLabel setText:[NSString stringWithFormat:@"%lu人参与", (unsigned long)sInfo.applyCount]];
    partLabel.textAlignment = NSTextAlignmentRight;
    [partLabel setFont:[UIFont systemFontOfSize:12.0]];
    [bottomV addSubview:partLabel];
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 28, _imageV.frame.size.width-95, 20)];
    [desLabel setTextColor:[UIColor whiteColor]];
    [desLabel setText:sInfo.des];
    [desLabel setFont:[UIFont systemFontOfSize:12.0]];
    [bottomV addSubview:desLabel];
}

#pragma mark - 下载图片
- (void)configureView:(NSString *)imageURL
{
    if (imageURL) {
        [_loadingView showLoading];
        [_loadingView setFrame:CGRectMake(MAINSCREEN.size.width/2, MAINSCREEN.size.width/2, MAINSCREEN.size.width, MAINSCREEN.size.width)];
        [_imageV addSubview:_loadingView];
        
        dispatch_after(0.2, dispatch_get_global_queue(0, 0), ^{
            __block ImageLoadingView *loadingView = _loadingView;
            
            [_imageV sd_setImageWithURL:[NSURL URLWithString:imageURL]
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
}




@end
