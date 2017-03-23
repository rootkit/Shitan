//
//  ScreenCell.h
//  Shitan
//
//  Created by Richard Liu on 15/8/13.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassInfo.h"

@protocol ScreenCellDelegate;


@interface ScreenCell : UITableViewCell

@property (nonatomic, weak) id<ScreenCellDelegate> delegate;

+ (ScreenCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(ClassInfo *)mInfo;

@end


@protocol ScreenCellDelegate <NSObject>

- (void)seletedBtnWithKeyword:(ClassInfo *)mInfo;

@end
