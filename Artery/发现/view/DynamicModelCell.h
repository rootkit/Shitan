//
//  DynamicModelCell.h
//  Shitan
//
//  Created by Avalon on 15/4/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModelFrame.h"

#import "DynamicHeadView.h"
#import "DynamicContentsView.h"
#import "DynamicBottomView.h"
#import "DynamicToolsbarView.h"

@class  DynamicModelCell;

@protocol DynamicModelCellDelegate <NSObject>

@optional
- (void)dynamicModelCell:(DynamicModelCell *)dynamicModelCell withpInfo:(PraiseInfo *)pInfo;

@end

@interface DynamicModelCell : UITableViewCell

@property (nonatomic, strong) DynamicModelFrame *dynamicModelFrame;

@property (nonatomic, weak) id<DynamicModelCellDelegate>delegate;

@property (nonatomic, weak) DynamicHeadView *headView;
@property (nonatomic, weak) DynamicContentsView *contentsView;
@property (nonatomic, weak) DynamicBottomView *bottomView;
@property (nonatomic, weak) DynamicToolsbarView *toolsbarView;

@property (nonatomic, assign) NSUInteger lineNO;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
