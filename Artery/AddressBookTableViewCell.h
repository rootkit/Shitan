//
//  AddressBookTableViewCell.h
//  Shitan
//
//  Created by 刘敏 on 14-11-20.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactInfo.h"

@protocol AddressBookCellDelegate;


@interface AddressBookTableViewCell : UITableViewCell

@property (nonatomic, weak) id<AddressBookCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

- (void)setCellContent:(ContactInfo *)cInfo
          setIndexPath:(NSIndexPath *)indexPath;


@end


@protocol AddressBookCellDelegate <NSObject>

- (void)followButtonWithCell:(NSUInteger)row;

@end
