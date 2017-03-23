//
//  DynamicalTableViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "DynamicalTableViewController.h"
#import "FindFriendsViewController.h"
#import "ImageDAO.h"
#import "DynamicInfo.h"
#import "HorizontalModel.h"
#import "HorizontalScrollCell.h"
#import "ImageListViewController.h"

@interface DynamicalTableViewController () <HorizontalScrollCellDelegate>

@property (nonatomic, strong) ImageDAO *dao;
@property (nonatomic, strong) NSArray *friendsList;   //关注的好友图片

@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, assign) NSUInteger topId;



@end


@implementation DynamicalTableViewController


- (void)initDao
{
    if (!_dao) {
        self.dao = [[ImageDAO alloc] init];
    }
    
    _isMore = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//滚动到顶部(PO图成功之后执行)
- (void)scrollToTheTop
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateComments:)
                                                 name:@"NEW_COMMENTS_UPDATE"
                                               object:nil];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];

    
    self.tableView.userInteractionEnabled = YES;
    
    //最新
    self.coreDataMange.tableTag = 1;
    
    //评论入口
    self.commntEntranceType = CityDYType;
    
    [self initDao];
    
    //读取缓存数据
    [self readData];
    
    [self setDisplayRefreshView:YES];
    
    [self loadNewData];
}


#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    self.isMore = NO;
    
    //获取最新
    [self requestEssenceImagesList];
    
    //获取关注动态
    [self getMyFriendImgs];
    
    [super loadNewData];
}

#pragma mark - 上拉刷新更多数据
- (void)loadMoreData{
    self.isMore = YES;
    
    //获取最新
    [self requestEssenceImagesList];
    
    [super loadMoreData];
}


//- (void)setTwitterVC:(STTwitterPaggingViewer *)twitterVC
//{
//    _twitterVC = twitterVC;
//}

// 获取最新
- (void)requestEssenceImagesList
{
    /***************************  数据封装  ******************************/
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:theAppDelegate.cInfo.name forKey:@"city"];
    
    if ([AccountInfo sharedAccountInfo].userId) {
        [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    }
    
    //信息条数
    [dict setObject:[NSNumber numberWithInt:20] forKey:@"size"];
    //同城动态
    [dict setObject:[NSNumber numberWithInteger:1] forKey:@"status"];
    
    //该页最大的ID
    if (self.isMore) {
        [dict setObject:[NSNumber numberWithInteger:self.topId] forKey:@"topId"];
    }
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    //获取图片
    [self getImagesList:requestDict];
}



// 获取好友图片
- (void)getMyFriendImgs
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (!theAppDelegate.isLogin) {
        STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
        STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
        nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        nc.view.layer.shadowOpacity = 0.2;
        
        [self presentViewController:nc animated:YES completion:nil];
        
        return;
    }
    
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    //信息条数
    [dic setObject:[NSNumber numberWithInt:10] forKey:@"size"];
    
    // 结果是否需要输出详情
    [dic setObject:[NSNumber numberWithBool:NO] forKey:@"outputDetail"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [self.dao requestMyFriendImgs:requestDict completionBlock:^(NSDictionary *result) {
        
        self.friendsList = nil;
        if ([[result objectForKey:@"code"] intValue] == 200) {
            
            NSArray *temp = [result objectForKey:@"obj"];
            self.friendsList = [self parisDataWithArray:temp];
        }
        
        //重载
        [self.tableView reloadData];
    }setFailedBlock:^(NSDictionary *result){
                       
    }];
}


//获取同城图片
- (void)getImagesList:(NSDictionary *)dic
{
    [self.dao requestNewImageList:dic completionBlock:^(NSDictionary *result) {
        
        if (result.code == 200) {
            if (result.obj) {
                
                NSArray *temp = result.obj;
                
                if (!self.isMore) {
                    [self.dynamicModelFrames removeAllObjects];
                    
                    //先清空数据
                    [self.coreDataMange clearAllData];
                }
                
                if ([temp isKindOfClass:[NSArray class]] && [temp count] > 0) {
                    self.topId = [[[temp objectAtIndex:[temp count]-1] objectForKey:@"id"]integerValue] - 1;
                    
                    [self.dynamicModelFrames addObjectsFromArray:[self parisDynamicModelFrameWithArray:temp]];

                    [self writeDate:temp];
                }
                else{
                    //没有数据是才显示
                    if ([self.dynamicModelFrames count] < 1){
                        //[self addPromptView];
                    }
                    
                }
                //重载
                [self.tableView reloadData];
                
                
            }
        }
    }setFailedBlock:^(NSDictionary *result) {
                       
    }];
}


//解析数据DynamicInfo
- (NSArray *)parisDynamicModelFrameWithArray:(NSArray *)array
{
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSDictionary *item in array) {
        DynamicModelFrame *dynamicModelFrame = [[DynamicModelFrame alloc] init];
        dynamicModelFrame.dInfo = [[DynamicInfo alloc] initWithParsData:item];
        
        [tempA addObject:dynamicModelFrame];
    }
    
    return tempA;
}


//解析数据DynamicInfo
- (NSArray *)parisDataWithArray:(NSArray *)array
{
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSDictionary *item in array) {
        DynamicInfo *dInfo = [[DynamicInfo alloc] initWithParsData:item];
        
        [tempA addObject:dInfo];
    }
    
    return tempA;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.dynamicModelFrames.count;
    }
    else return 1;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }
    else{
        DynamicModelFrame *dynamicModelFrame = self.dynamicModelFrames[indexPath.row];
        return dynamicModelFrame.rowHeight ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HorizontalScrollCell *hCell = [HorizontalModel findCellWithTableView:tableView];
        [hCell setUpCellWithArray:_friendsList];
        hCell.delegate = self;
        return hCell;
    }
    else{
        if (self.dynamicModelFrames.count) {
            DynamicModelCell *cell = [DynamicModelCell cellWithTableView:tableView];
            DynamicModelFrame* dynamicModelFrame = self.dynamicModelFrames[indexPath.row];
            
            cell.lineNO = indexPath.row;
            cell.headView.delegate = self;
            cell.contentsView.delegate = self;
            cell.bottomView.delegate = self;
            cell.toolsbarView.delegate = self;
            cell.dynamicModelFrame = dynamicModelFrame;
            
            return cell;
        }
    }
    return nil;
}

//更新评论
- (void)updateComments:(NSNotification *)notification
{
    CommentInfo *cInfo = notification.object;
    //插入数据
    [self.coreDataMange selectDataWithComment:cInfo];
    
    [self initCoreData];
    
    //局部刷新
    NSIndexPath *te = [NSIndexPath indexPathForRow:cInfo.mRow inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - HorizontalScrollCell 代理事件
- (void)horizontalScrollCell:(HorizontalScrollCell *)hCell row:(NSUInteger)row
{
    if (row == _friendsList.count)
    {
        [self jumpToImageListView];
    }
    else{
        DynamicInfo *dInfo = _friendsList[row];
        [self jumpToTipsDetailsViewController:dInfo];
    }
}

- (void)horizontalScrollCell:(HorizontalScrollCell *)hCell isFirst:(BOOL)isFirst
{
    if (!theAppDelegate.isLogin) {
        STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
        STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
        nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        nc.view.layer.shadowOpacity = 0.2;
        
        [self presentViewController:nc animated:YES completion:nil];
        
        return;
    }
    
    
    if (isFirst) {
        [self jumpToImageListView];
    }
    else{
        FindFriendsViewController *fVC = (FindFriendsViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MineStoryboard" class:[FindFriendsViewController class]];
        fVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fVC animated:YES];
    }
}


- (void)jumpToImageListView
{
    ImageListViewController *mVC = (ImageListViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"HomeStoryboard" class:[ImageListViewController class]];
    mVC.hidesBottomBarWhenPushed = YES;
    mVC.cityName = theAppDelegate.cInfo.name;
    [self.navigationController pushViewController:mVC animated:YES];
}


- (void)jumpToTipsDetailsViewController:(DynamicInfo *)dInfo
{
    TipsDetailsViewController *tipVC = (TipsDetailsViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[TipsDetailsViewController class]];
    tipVC.hidesBottomBarWhenPushed = YES;
    tipVC.m_Type = SecondTypeTips;
    tipVC.dyInfo = dInfo;
    [self.navigationController pushViewController:tipVC animated:YES];
}

#pragma mark -点赞操作（实现父类方法）
//点赞
- (void)hasPraise:(PraiseInfo *)pInfo cellWithRow:(NSUInteger)row
{
    //插入数据
    [self.coreDataMange selectDataWithPraise:pInfo];
    
    [self initCoreData];
    
    //局部刷新
    NSIndexPath *te = [NSIndexPath indexPathForRow:row inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationFade];
}


//取消点赞
- (void)cancelPraise:(PraiseInfo *)pInfo cellWithRow:(NSUInteger)row
{
    //清除数据
    [self.coreDataMange clearDataWithPraise:pInfo];
    
    [self initCoreData];
    
    //局部刷新
    NSIndexPath *te = [NSIndexPath indexPathForRow:row inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationFade];
}


//适用于隐藏/删除
- (void)dynamicToolsbarView:(DynamicToolsbarView *)dynamicToolsbarView
                    imageID:(NSString *)imageID
               indexWithRow:(NSUInteger)row
{
    [self.dynamicModelFrames removeObjectAtIndex:row];
    
    //局部刷新
    NSIndexPath *te = [NSIndexPath indexPathForRow:row inSection:1];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    dispatch_after(0.2, dispatch_get_global_queue(0, 0), ^{
        //删除数据
        [self.coreDataMange clearDataWithDyInfo:imageID];
        
        //数据同步
        [self readData];
        
    });
}



@end
