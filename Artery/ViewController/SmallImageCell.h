//
//  SmallImageCell.h
//  Shitan
//
//  Created by Richard Liu on 15/5/5.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicInfo.h"


@protocol SmallImageCellDelegate;

@interface SmallImageCell : UITableViewCell

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) id<SmallImageCellDelegate> delegate;

- (void)setSmallImageCellWithCellInfo:(NSArray *)array;

@end


@protocol SmallImageCellDelegate <NSObject>

- (void)smallImageCellSelectItem:(DynamicInfo *)dInfo;

@end