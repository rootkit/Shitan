//
//  FavoriteDetailViewController.h
//  Shitan
//
//  Created by Jia HongCHI on 14-10-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "FavInfo.h"
#import "BubbleView.h"
#import "DynamicInfo.h"


@interface FavoriteDetailViewController : STChildViewController

@property (strong, nonatomic) FavInfo* fInfo;

@property (nonatomic, strong) BubbleView *bubbleV;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, weak) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *favoriteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteDescLabel;

@property (nonatomic, assign) NSInteger topId;     //该页最大的ID
@property (nonatomic, assign) BOOL isMore;         //是否获取更多

@property (nonatomic, assign) BOOL isShowfocus;    //是否显示

@property (nonatomic, assign) BOOL isMyself;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topviewHight;

//点击
- (void)imgaeHeadTapped:(DynamicInfo *)dInfo;

//刷新
- (void)headerRereshing;

// 下拉获取更多
- (void)footerRereshing;

//标签点击
- (void)clickBubbleViewWithInfo:(BubbleView *)bubleV shopWithInfo:(ShopInfo *)sInfo;


@end
