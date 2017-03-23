//
//  ShopRecommendCell.h
//  Shitan
//
//  Created by Richard Liu on 15/6/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModelFrame.h"
#import "ShopMiddleScrollView.h"
#import "ShopMiddleContentsView.h"

@interface ShopRecommendCell : UITableViewCell

@property (nonatomic, strong) RecommendModelFrame *recommendModelFrame;

@property (nonatomic, weak) ShopMiddleScrollView *scrollView;
@property (nonatomic, weak) ShopMiddleContentsView *bottomView;

+ (ShopRecommendCell *)cellWithTableView:(UITableView *)tableView;

@end
