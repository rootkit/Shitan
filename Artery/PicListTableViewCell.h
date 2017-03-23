//
//  PicListTableViewCell.h
//  Shitan
//
//  Created by Jia HongCHI on 14/12/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicInfo.h"


@protocol PicListTableViewCellDelegate;


@interface PicListTableViewCell : UITableViewCell

@property (nonatomic, weak) id<PicListTableViewCellDelegate> delegate;

- (void)initWithParsData:(NSArray *)imgArray intWithSection:(NSInteger)section;

@end


@protocol PicListTableViewCellDelegate <NSObject>

- (void)clickImageViewTappedWithSection:(NSInteger )section withRow:(NSInteger)row;

@end