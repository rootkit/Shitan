//
//  SpecialCell.h
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerInfo.h"
#import "ImageLoadingView.h"


@interface SpecialCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageV;
//等待加载图片
@property (nonatomic, strong) ImageLoadingView *loadingView;

- (void)setCellWithCellInfo:(BannerInfo *)sInfo;

@end
