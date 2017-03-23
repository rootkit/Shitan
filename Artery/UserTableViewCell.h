//
//  UserTableViewCell.h
//  Shitan
//
//  Created by 刘敏 on 14-11-15.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalInfo.h"

@protocol UserCellDelegate;

@interface UserTableViewCell : UITableViewCell

@property (nonatomic, weak) id<UserCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) UIButton *followButton;


// 赋值（粉丝、关注）
- (void)setCellWithRelationshipCellInfo:(PersonalInfo *)dInfo setRow:(NSInteger)row isFocus:(BOOL)isFocus;

// 赋值 （昵称、手机号码搜索）
- (void)setCellWithRelationshipCellInfo:(PersonalInfo *)dInfo setRow:(NSInteger)row;

// 赋值 （weibo）
- (void)setCellWithRelationshipWeiboCellInfo:(PersonalInfo *)dInfo setRow:(NSInteger)row;

@end


@protocol UserCellDelegate <NSObject>

- (void)followButtonWithCellwithRow:(NSInteger)row;

@end