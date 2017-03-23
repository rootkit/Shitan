//
//  TipsDetailsViewController.h
//  Shitan
//
//  Created by 刘敏 on 14-10-24.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleView.h"
#import "ShopInfo.h"
#import "HostViewController.h"
#import "CoreDataManage.h"
#import "STChildViewController.h"


@interface TipsDetailsViewController : STChildViewController

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) HostViewController *hostVC;

@property (nonatomic, strong) BubbleView *bubbleV;

@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, assign) NSInteger topId;     //该页最大的ID
@property (nonatomic, assign) BOOL isMore;         //是否获取更多

@property (nonatomic, assign) BOOL isShowfocus;    //是否显示标签
@property (nonatomic, strong) ShopInfo* shopInfo;  //商户信息

@property (nonatomic, assign) BOOL isShowPlace;

@property (nonatomic, strong) DynamicInfo *dyInfo;

@property (nonatomic, assign) STTypeSourceType m_Type;  //入口来源

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHight;

@property (nonatomic, assign) BOOL isHideNav;

@property (nonatomic, strong) CoreDataManage *coreDataMange;

//关注
- (void)focusButtonTapped;

//喜欢(赞)
- (void)praiseButtonTapped:(PraiseInfo *)pInfo;

//取消(赞)
- (void)cancelPraise:(PraiseInfo *)pInfo;

//点击头像
- (void)imgaeHeadTapped:(NSString *)userID;

//评论图片
- (void)commentsImage:(DynamicInfo *)dInfo;

//收藏
- (void)collectionTypeChoose:(DynamicInfo *)dInfo;

//更多
- (void)moreButtonTapped:(DynamicInfo *)dInfo;

//刷新
- (void)headerRereshing;

//评论列表
- (void)loadCommentListView:(NSString *)imageID imageReleasedID:(NSString *)userID;

// 下拉获取更多
- (void)footerRereshing;

//传递标签点击
- (void)clickBubbleViewWithInfo:(BubbleView *)bubleV shopWithInfo:(ShopInfo *)sInfo;

//图片赞列表
- (void)imagePraisList:(NSString *)imageId;

@end
