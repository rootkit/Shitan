//
//  SearchTableViewCell.h
//  NationalOA
//
//  Created by 刘敏 on 14-6-25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTableViewCellDelegate;


@interface SearchTableViewCell : UITableViewCell

@property (weak, nonatomic) id<SearchTableViewCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIImageView *searchImageView;
@property (nonatomic, weak) IBOutlet UITextField *accountField;

- (void) keyboardHiddenWithAccountField;

@end



@protocol SearchTableViewCellDelegate <NSObject>

@optional
- (void)searchContentWithField:(NSString *)text;



@end


