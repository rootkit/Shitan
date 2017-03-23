//
//  PhotoListCell.h
//  Artery
//
//  Created by RichardLiu on 15/4/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageV;
@property (nonatomic, weak) IBOutlet UILabel *titLabel;

// 赋值
- (void)setCellWithCellInfo:(ALAssetsGroup *)group;

@end
