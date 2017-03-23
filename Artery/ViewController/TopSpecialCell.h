//
//  TopSpecialCell.h
//  Shitan
//
//  Created by Richard Liu on 15/5/5.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerInfo.h"
#import "SpecialViewController.h"

@interface TopSpecialCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headV;   //顶部图片
@property (nonatomic, strong) UIView *topView;      //专题文字（标题、文字描述）

@property (nonatomic, weak) SpecialViewController *controller;

@property (nonatomic, assign) NSInteger HEADER_HIGH;

- (CGFloat)setTopSpecialCellWithCellInfo:(BannerInfo *)bInfo;


@end
