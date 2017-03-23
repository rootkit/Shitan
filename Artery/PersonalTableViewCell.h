//
//  PersonalTableViewCell.h
//  Shitan
//
//  Created by Richard Liu on 15/5/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonalTableViewCell;

@protocol PersonalTableViewCellDelegate <NSObject>

@optional

- (void)personalTableViewCell:(PersonalTableViewCell *)mycell bTnIndex:(NSInteger) index;


@end


@interface PersonalTableViewCell : UITableViewCell

@property (strong, nonatomic) UIButton *headButton;      //头像
@property (strong, nonatomic) UILabel  *nickLabel;       //昵称
@property (strong, nonatomic) UIButton *editorButon;     //编辑个人资料
@property (strong, nonatomic) UILabel  *signatureLabel;  //个性签名
@property (strong, nonatomic) UIButton *accessoryButton; //附属按钮
@property (strong, nonatomic) UIButton *transparentBtn;

@property (nonatomic, weak) id<PersonalTableViewCellDelegate> delegate;

- (void)updateData;

@end
