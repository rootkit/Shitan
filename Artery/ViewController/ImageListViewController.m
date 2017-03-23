//
//  ImageListViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/4/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ImageListViewController.h"
#import "ImageDAO.h"
#import "CoreDataManage.h"

@interface ImageListViewController ()

@property (nonatomic, strong) CoreDataManage *coreDataMange;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ImageDAO *dao;
@property (nonatomic, strong) NSMutableArray *dynamicModelFrames;

@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, assign) NSUInteger topId;

@property (nonatomic, assign) BOOL isShowfocus;

@end


@implementation ImageListViewController

- (void)initDao
{
    if (_dao == nil) {
        _dao = [[ImageDAO alloc] init];
        
    }
    
    if (_dynamicModelFrames == nil) {
        _dynamicModelFrames = [[NSMutableArray alloc] initWithCapacity:0];
    }

    if (_coreDataMange == nil) {
        _coreDataMange = [[CoreDataManage alloc] init];
        //关注
        _coreDataMange.tableTag = 2;
    }
    
    _isMore = NO;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    [self setNavBarTitle:@"关注"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateComments:)
                                                 name:@"ST_COMMENTS_UPDATE"
                                               object:nil];
    
    
    //评论入口
    self.commntEntranceType = FocusDYType;
    
    //初始化
    [self initDao];
    
    //读取缓存数据
    [self readData];
    
    [self setupRefresh];
    
    //获取关注动态
    [self getMyFriendImgs];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}


//刷新
- (void)headerRereshing
{
    self.isMore = NO;

    //获取关注动态
    [self getMyFriendImgs];

}

// 下拉获取更多
- (void)footerRereshing
{
    self.isMore = YES;

    //获取关注动态
    [self getMyFriendImgs];

}

// 获取好友图片
- (void)getMyFriendImgs
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    //该页最大的ID
    if (self.isMore) {
        [dic setObject:[NSNumber numberWithInteger:self.topId] forKey:@"topId"];
    }
    //信息条数
    [dic setObject:[NSNumber numberWithInt:20] forKey:@"size"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [self.dao requestMyFriendImgs:requestDict completionBlock:^(NSDictionary *result) {
        if (result.code == 200) {
            NSArray *temp = result.obj;
            
            if (!self.isMore) {
                [self.dynamicModelFrames removeAllObjects];
                
                //先清空数据
                [_coreDataMange clearAllData];
            }
            
            
            if ([temp isKindOfClass:[NSArray class]] && [temp count] > 0) {
                self.topId = [[[temp objectAtIndex:[temp count]-1] objectForKey:@"id"]integerValue] - 1;
                [self.dynamicModelFrames addObjectsFromArray:[self parisDataWithArray:temp]];
                [self writeDate:temp];
            }
            
            [self.tableView reloadData];
        }
        
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }
    setFailedBlock:^(NSDictionary *result) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}


//解析数据
- (NSArray *)parisDataWithArray:(NSArray *)array
{
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSDictionary *item in array) {
        DynamicModelFrame *dynamicModelFrame = [[DynamicModelFrame alloc] init];
        dynamicModelFrame.dInfo = [[DynamicInfo alloc] initWithParsData:item];
        
        [tempA addObject:dynamicModelFrame];
    }
    
    return tempA;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dynamicModelFrames count];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.dynamicModelFrames count] > 0) {
        
        DynamicModelFrame *dynamicModelFrame = self.dynamicModelFrames[indexPath.row];
        return dynamicModelFrame.rowHeight ;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSIndexPath *te = [NSIndexPath indexPathForRow:cInfo.mRow inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark -点赞操作（实现父类方法）
//点赞
- (void)hasPraise:(PraiseInfo *)pInfo cellWithRow:(NSUInteger)row
{
    //插入数据
    [self.coreDataMange selectDataWithPraise:pInfo];
    
    [self initCoreData];
    
    //局部刷新
    NSIndexPath *te = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationFade];
}


//取消点赞
- (void)cancelPraise:(PraiseInfo *)pInfo cellWithRow:(NSUInteger)row
{
    //清除数据
    [self.coreDataMange clearDataWithPraise:pInfo];
    
    [self initCoreData];
    
    //局部刷新
    NSIndexPath *te = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationFade];
}

//适用于隐藏/删除
- (void)dynamicToolsbarView:(DynamicToolsbarView *)dynamicToolsbarView
                    imageID:(NSString *)imageID
               indexWithRow:(NSUInteger)row
{
    [self.dynamicModelFrames removeObjectAtIndex:row];
    
    //局部刷新
    NSIndexPath *te = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    dispatch_after(0.2, dispatch_get_global_queue(0, 0), ^{
        
        //删除数据
        [self.coreDataMange clearDataWithDyInfo:imageID];
        
        //数据同步
        [self readData];
        
    });

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
