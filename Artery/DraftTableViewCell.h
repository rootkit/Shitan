//
//  DraftTableViewCell.h
//  Shitan
//
//  Created by 刘敏 on 15/1/20.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraftTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageV;      //图片

@property (nonatomic, strong) UILabel *timeLabel;              //时间
@property (nonatomic, strong) UILabel *placeLabel;             //地点
@property (nonatomic, strong) UILabel *desLabel;               //文字描述

- (void)initWithParsData:(NSDictionary *)dict;

@end
