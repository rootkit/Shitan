//
//  ResultItemViewController.h
//  Shitan
//
//  Created by RichardLiu on 15/4/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STChildViewController.h"
#import "ShopInfo.h"
#import "ItemInfo.h"
#import "DynamicInfo.h"
#import "BubbleView.h"

@interface ResultItemViewController : STChildViewController

@property (nonatomic, strong) ShopInfo *sInfo;
@property (nonatomic, strong) ItemInfo *itemInfo;
@property (nonatomic, weak)  IBOutlet UITableView *tableView;
@property (nonatomic, strong) DynamicInfo *mInfo;
@property (nonatomic, assign) STTypeSourceType m_Type;  //入口来源
@property (nonatomic, strong) BubbleView *bubbleV;


- (void)leftButton:(BOOL)mLeft;


//关注
- (void)focusButtonTapped;

//喜欢(赞)
- (void)praiseButtonTapped;

//取消(赞)
- (void)cancelPraise;

//点击头像
- (void)imgaeHeadTapped:(NSString *)userID;

//评论图片
- (void)commentsImage:(DynamicInfo *)dInfo;

//收藏
- (void)collectionTypeChoose:(DynamicInfo *)dInfo;

//更多
- (void)moreButtonTapped:(DynamicInfo *)dInfo;

//评论列表
- (void)loadCommentListView:(NSString *)imageID imageReleasedID:(NSString *)userID;


//传递标签点击
- (void)clickBubbleViewWithInfo:(BubbleView *)bubleV shopWithInfo:(ShopInfo *)sInfo;

//图片赞列表
- (void)imagePraisList:(NSString *)imageId;


//其他菜品点击
- (void)imageBtnTapped:(ItemInfo *)tInfo;


@end
