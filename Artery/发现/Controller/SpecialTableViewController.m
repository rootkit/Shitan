//
//  SpecialTableViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "SpecialTableViewController.h"
#import "SpecialViewController.h"
#import "SpecialSerialViewController.h"
#import "ImageDAO.h"

@interface SpecialTableViewController ()

@property (nonatomic, strong) ImageDAO *dao;

@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, assign) NSUInteger topId;

@end

@implementation SpecialTableViewController



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
    CLog(@"回到顶部：%d", self.tableView.scrollsToTop);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CLog(@"回到顶部：%d", self.tableView.scrollsToTop);
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //精选评论
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateComments:)
                                                 name:@"QUALITY_COMMENTS_UPDATE"
                                               object:nil];
    
    
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    self.tableView.userInteractionEnabled = YES;
    
    //精选
    self.coreDataMange.tableTag = 0;
    
    //评论入口
    self.commntEntranceType = QualityType;

    [self initDao];
    
    //读取缓存数据
    [self readData];

    [self setDisplayRefreshView:YES];
    
    [self loadNewData];
}


#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    
    [super loadNewData];
    
    self.isMore = NO;
    
    //获取精选
    [self requestEssenceImagesList];
}

#pragma mark - 上拉刷新更多数据
- (void)loadMoreData{
    [super loadMoreData];
    
    self.isMore = YES;
    
    //获取精选
    [self requestEssenceImagesList];
}


// 获取精选
- (void)requestEssenceImagesList
{
    /***************************  数据封装  ******************************/
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:theAppDelegate.cInfo.name forKey:@"city"];
    
    //信息条数
    [dict setObject:[NSNumber numberWithInt:20] forKey:@"size"];
    
    if ([AccountInfo sharedAccountInfo].userId) {
        [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    }
    
    //精选
    [dict setObject:[NSNumber numberWithInteger:5] forKey:@"status"];
    
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




//获取同城图片
- (void)getImagesList:(NSDictionary *)dic
{
    [self.dao requestNewImageList:dic completionBlock:^(NSDictionary *result) {
        
        if (result.code == 200) {
            if (result.obj) {
                
                NSArray *temp = result.obj;
                
                if (!self.isMore) {
                    [self.dynamicModelFrames removeAllObjects];
                    //先清空数据(下拉刷新时清空数据)
                    [self.coreDataMange clearAllData];
                }
                
                if ([temp isKindOfClass:[NSArray class]] && [temp count] > 0) {
                    self.topId = [[[temp objectAtIndex:[temp count]-1] objectForKey:@"id"]integerValue] - 1;
                    
                    [self.dynamicModelFrames addObjectsFromArray:[self parisDataWithArray:temp]];
                    
                    CLog(@"%@",self.dynamicModelFrames);
                    
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
    DynamicModelFrame *dynamicModelFrame = self.dynamicModelFrames[indexPath.row];
    return dynamicModelFrame.rowHeight ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dynamicModelFrames.count) {
        DynamicModelCell *cell = [DynamicModelCell cellWithTableView:tableView];
        DynamicModelFrame* dynamicModelFrame = self.dynamicModelFrames[indexPath.row];
        
        cell.lineNO = indexPath.row;      //行号
        cell.headView.delegate = self;
        cell.contentsView.delegate = self;
        cell.bottomView.delegate = self;
        cell.toolsbarView.delegate = self;
        cell.dynamicModelFrame = dynamicModelFrame;
        
        [cell.headView setQuality];
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
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationNone];
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
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}


//取消点赞
- (void)cancelPraise:(PraiseInfo *)pInfo cellWithRow:(NSUInteger)row
{
    //清除数据
    [self.coreDataMange clearDataWithPraise:pInfo];
    
    [self initCoreData];
    
    //局部刷新
    NSIndexPath *te = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
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

@end
