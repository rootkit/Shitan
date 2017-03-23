//
//  STBaseHomeTableViewController.m
//  Shitan
//
//  Created by Avalon on 15/4/23.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STBaseHomeTableViewController.h"


@interface STBaseHomeTableViewController ()

@end

@implementation STBaseHomeTableViewController


- (CoreDataManage *)coreDataMange{
    
    if (_coreDataMange == nil) {
        _coreDataMange = [[CoreDataManage alloc] init];
    }

    return _coreDataMange;
}

- (NSMutableArray *)dynamicModelFrames
{
    if (_dynamicModelFrames == nil) {
        _dynamicModelFrames  =  [[NSMutableArray alloc] init];
        
    }
    
    return _dynamicModelFrames;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}



#pragma mark - 添加刷新控件
- (void)setDisplayRefreshView:(BOOL)displayRefreshView{
    _displayRefreshView = displayRefreshView;
    
    if (_displayRefreshView) {
        
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
}


#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [self.tableView.header endRefreshing];
    
    [self.tableView reloadData];
}



#pragma mark - 上拉刷新更多数据
- (void)loadMoreData{
    
    [self.tableView.footer endRefreshing];
    
    [self.tableView reloadData];
}



#pragma mark - 头像的代理事件
- (void)dynamicHeadView:(DynamicHeadView *)dynamicHeadView useId:(NSString *)useId{
    [self jumpToOneselfViewWithUserId:useId];
}

#pragma mark - 关注按钮代理事件
- (void)dynamicHeadView:(DynamicHeadView *)dynamicHeadView refreshdyAttentionWithUseId:(NSString *)dInfo
{
    //改变关注状态
    [_coreDataMange selectDataWithFocus:dInfo];
    
    [self readData];
}


#pragma mark - 标签的代理事件
- (void)dynamicContentsView:(DynamicContentsView *)dynamicContentsView bubbleView:(BubbleView *)bubbleView sInfo:(ShopInfo *)sInfo{
    
    if(bubbleView.tipType == Tip_Location)
    {
        //展现该商家的所有单品
        ResultDetailsViewController *dVC = (ResultDetailsViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[ResultDetailsViewController class]];
        dVC.sInfo = sInfo;
        dVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dVC animated:YES];
    }
    else{
        TipsDetailsViewController *tVC = (TipsDetailsViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[TipsDetailsViewController class]];
        tVC.bubbleV = bubbleView;
        tVC.shopInfo = sInfo;
        
        //显示地点
        if (bubbleView.tipType == Tip_Location) {
            tVC.isShowPlace = YES;
        }
        
        //标签点击
        tVC.m_Type = FistTypeTips;
        
        tVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:tVC animated:YES];
    }
    
}

#pragma mark - 赞列表及评论的点击代理事件
//进入个人主页
- (void)dynamicBottomView:(DynamicBottomView *)dynamicBottomView WithUserId:(NSString *)userId{
    
    [self jumpToOneselfViewWithUserId:userId];
    
}

//进入赞列表
- (void)dynamicBottomView:(DynamicBottomView *)dynamicBottomView WithImageId:(NSString *)imageId{
    
    UserListViewController *userListVC = (UserListViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MineStoryboard" class:[UserListViewController class]];
    
    userListVC.respondentUserId = [AccountInfo sharedAccountInfo].userId;
    userListVC.hidesBottomBarWhenPushed = YES;
    userListVC.userListType = PraiseList;
    userListVC.imageId = imageId;
    
    [self.navigationController pushViewController:userListVC animated:YES];
}

//进入评论列表
- (void)dynamicBottomView:(DynamicBottomView *)dynamicBottomView
               WithUserId:(NSString *)userId
                  ImageId:(NSString *)imageId
              cellWithRow:(NSUInteger)row{
    
    
    [self jumpToCommentListWithImageId:imageId UserId:userId pushKeyboard:NO cellWithRow:row];
}

#pragma mark - 工具条的代理事件
- (void)dynamicToolsbarView:(DynamicToolsbarView *)dynamicToolsbarView
                  withIndex:(NSInteger)index
                DynamicInfo:(DynamicInfo *)dInfo
               indexWithRow:(NSUInteger)row{
    //点赞
    if (index == 0) {
        
        dInfo.hasPraise = !dInfo.hasPraise;
        
        //封装数据
        PraiseInfo *pInfo = [[PraiseInfo alloc] init];
        pInfo.hasFollowTheAuthor = dInfo.hasFollowTheAuthor;
        pInfo.userId = [AccountInfo sharedAccountInfo].userId;
        pInfo.nickName = [AccountInfo sharedAccountInfo].nickname;
        pInfo.portraitUrl = [AccountInfo sharedAccountInfo].portraiturl;
        pInfo.imgId = dInfo.imgId;
        pInfo.createTime = [Units getNowTime];
        
        if (dInfo.hasPraise) {
            //点赞
            [self hasPraise:pInfo cellWithRow:row];
        }
        else
            [self cancelPraise:pInfo cellWithRow:row];
    }
    
    //评论
    if (index == 1) {
        [self jumpToCommentListWithImageId:dInfo.imgId UserId:dInfo.userId pushKeyboard:YES cellWithRow:row];
        
    }
    //收藏
    if (index == 2) {
        
        CollectionTypeViewController *coVC = (CollectionTypeViewController*)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[CollectionTypeViewController class]];
        
        coVC.imageId = dInfo.imgId;
        coVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:coVC animated:YES];
    }
}

#pragma mark - 页面跳转
//个人页面的跳转
- (void)jumpToOneselfViewWithUserId:(NSString *)useId{
    
    if ([useId isEqualToString:[AccountInfo sharedAccountInfo].userId]) {
        ProfileTableViewController *hVC = [[ProfileTableViewController alloc] init];
        hVC.isFromTabbar = NO;
        hVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hVC animated:YES];
        
    }
    else{
        HimselfViewController *hVC = (HimselfViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MineStoryboard" class:[HimselfViewController class]];
        hVC.respondentUserId = useId;
        hVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hVC animated:YES];
    }
    
}

//评论列表的跳转
- (void)jumpToCommentListWithImageId:(NSString *) imgId
                              UserId:(NSString *)userId
                        pushKeyboard:(BOOL)pushKeyBoard
                         cellWithRow:(NSUInteger)row{
    
    CommentListViewController *dVC = (CommentListViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[CommentListViewController class]];
    dVC.hidesBottomBarWhenPushed = YES;
    dVC.imageID = imgId;
    dVC.userID = userId;
    dVC.isPopKeyboard = pushKeyBoard;
    dVC.mRow = row;
    
    //入口来源(精选)
    dVC.mType = _commntEntranceType;
    
    [self.navigationController pushViewController:dVC animated:YES];
    
}

//适用于隐藏/删除
- (void)dynamicToolsbarView:(DynamicToolsbarView *)dynamicToolsbarView
                DynamicInfo:(DynamicInfo *)dInfo
               indexWithRow:(NSUInteger)row
{
    
}

#pragma mark -点赞操作（点赞和取消点赞）
//点赞
- (void)hasPraise:(PraiseInfo *)pInfo cellWithRow:(NSUInteger)row
{

}


//取消点赞
- (void)cancelPraise:(PraiseInfo *)pInfo cellWithRow:(NSUInteger)row
{

}



#pragma mark - 数据库操作
/**
 *  读取数据（数据库数据）
 *  无网络请求时读取、启东时先读取本地数据
 *  @return
 */
- (void)readData{
    [self initCoreData];
    [self.tableView reloadData];
}

- (void)initCoreData
{
    //先清空
    [self.dynamicModelFrames removeAllObjects];
    
    NSArray *array  = [self.coreDataMange selectCoreData];
    [self.dynamicModelFrames addObjectsFromArray:array];
}

//写入数据
- (void)writeDate:(NSArray *)array{
    
    if ([array isKindOfClass:[NSArray class]] && [array count] > 0)
    {
        [self.coreDataMange insertCoreData:array];
    }
}



@end
