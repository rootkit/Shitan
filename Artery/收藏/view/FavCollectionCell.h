//
//  FavCollectionCell.h
//  Shitan
//
//  Created by 刘敏 on 14/11/29.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavInfo.h"

@interface FavCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *favoritePic1;
@property (weak, nonatomic) IBOutlet UIImageView *favoritePic2;
@property (weak, nonatomic) IBOutlet UIImageView *favoritePic3;
@property (weak, nonatomic) IBOutlet UIImageView *favoritePic4;
@property (weak, nonatomic) IBOutlet UILabel *favoriteTitleLabel;

//大图的宽度（高度）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *largerIamgeWidth;

//小图距离大图的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallIMageDistanceTop;

//小图宽度/高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallIMageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallIMageHigth;


- (void)initWithParsData:(FavInfo *)fInfo;


@end
