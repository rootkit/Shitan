//
//  SpecialViewController.h
//  Shitan
//
//  Created by Richard Liu on 15/4/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//  PO图专题

#import "STChildViewController.h"
#import "BannerInfo.h"
#import "DynamicInfo.h"
#import "BubbleView.h"
#import "CoreDataManage.h"

@interface SpecialViewController : STChildViewController

@property (nonatomic, strong) BannerInfo *bInfo;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CoreDataManage *coreDataMange;

- (void)jumpToWebView;

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