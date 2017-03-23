//
//  RecommendCell.h
//  Shitan
//
//  Created by Richard Liu on 15/6/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendInfo.h"

#define IMAGE_H_IPHONE5         200.0f
#define IMAGE_H_IPHONE6         234.0f
#define IMAGE_H_IPHONE6_Plus    259.0f


@interface RecommendCell : UITableViewCell

+ (RecommendCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(RecommendInfo *)mInfo;

@end
