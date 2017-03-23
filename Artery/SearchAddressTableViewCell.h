//
//  SearchAddressTableViewCell.h
//  Shitan
//
//  Created by RichardLiu on 15/2/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompositeInfo.h"
#import "UILabel+StringFrame.h"

@interface SearchAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *addressName;     //店铺名称
@property (nonatomic, strong) UILabel *addressDetail;   //详细地址

@property (nonatomic, strong) UILabel *distanceLabel;   //距离
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) ShopInfo *sInfo;

//@property (nonatomic, weak) SearchSTViewController *controller;


- (void)setCellWithCellInfo:(CompositeInfo *)cInfo;

@end
