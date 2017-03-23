//
//  PrimersCell.h
//  Shitan
//
//  Created by Richard Liu on 15/8/28.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//  引语

#import <UIKit/UIKit.h>
#import "PrimersView.h"
#import "PrimersModelFrame.h"

@interface PrimersCell : UITableViewCell

@property (nonatomic, strong) PrimersModelFrame *primersModelFrame;
@property (nonatomic, weak) PrimersView *pView;

+ (PrimersCell *)cellWithTableView:(UITableView *)tableView;

@end
