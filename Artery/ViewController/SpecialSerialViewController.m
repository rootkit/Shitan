//
//  SpecialSerialViewController.m
//  Shitan
//
//  Created by Avalon on 15/5/16.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "SpecialSerialViewController.h"
#import "SpecialCell.h"
#import "SpecialCellModel.h"
#import "ColumnDAO.h"
#import "BannerInfo.h"
#import "SpecialViewController.h"
#import "STWebViewController.h"
#import "MJRefresh.h"


@interface SpecialSerialViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ColumnDAO *cDAO;
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation SpecialSerialViewController

- (void)initDao
{
    if (!_cDAO) {
        self.cDAO = [[ColumnDAO alloc] init];
    }
    
    self.tableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _page = 1;
    
    [self initDao];
    
    [self setNavBarTitle:_titN];
    
    CGFloat m_topH = 0.0f;
    
    if (isIOS8) {
        m_topH = 0.0f;
    }
    else{
        m_topH = 20.0f;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, m_topH, MAINSCREEN.size.width, MAINSCREEN.size.height + 54) style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [ResetFrame resetScrollView:_tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    _tableView.userInteractionEnabled = YES;
    _tableView.separatorStyle = NO;
    
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [_tableView.header beginRefreshing];
}



#pragma mark - 下拉刷新更新数据
- (void)headerRereshing{
    _page = 1;
    
    //获取主题列表
    [self getSpecialList:_page];
    
}

#pragma mark - 上拉刷新更多数据
- (void)footerRereshing{
    if (_page > 1) {
        //获取主题列表
        [self getSpecialList:_page];
    }
    else
        [_tableView.footer endRefreshing];
}


// 获取专题
- (void)getSpecialList:(NSUInteger)page
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dic setObject:@"0" forKey:@"cityId"];
    [dic setObject:[NSNumber numberWithInteger:_groupId] forKey:@"groupId"];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:10] forKey:@"size"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_cDAO RequestSpecialList:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            NSArray *temp = [result objectForKeyNotNull:@"obj"];
            
            if (page == 1) {
                [self.tableArray removeAllObjects];
            }
            
            [self.tableArray addObjectsFromArray:[self parsSpecialData:temp]];
            
            [self.tableView reloadData];
            
            if(temp.count >= 10)
            {
                _page++;
            }
        }
        else
        {
            
        }
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    } setFailedBlock:^(NSDictionary *result) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    }];
}


//解析专题
- (NSArray *)parsSpecialData:(NSArray *)array
{
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *item in array) {
        BannerInfo *sInfo = [[BannerInfo alloc] initWithParsData:item];
        [tempA addObject:sInfo];
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

    return self.tableArray.count;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == _tableArray.count){
        return MAINSCREEN.size.width + 15;
    }
    
    else{
        return MAINSCREEN.size.width;
    }
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SpecialCell *sCell = [SpecialCellModel findCellWithTableView:tableView];
        
    if (_tableArray.count > 0) {
            BannerInfo *sInfo = _tableArray[indexPath.row];
            [sCell setCellWithCellInfo:sInfo];
    }
        return sCell;
  
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BannerInfo *bInfo = [_tableArray objectAtIndex:indexPath.row];
    if(bInfo.specialType == STPOImageType)
    {
        // PO图专题
        SpecialViewController *SVC = (SpecialViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"HomeStoryboard" class:[SpecialViewController class]];
        SVC.bInfo = bInfo;
        SVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SVC animated:YES];
    }
    else if(bInfo.specialType == STWebType){
        
        STWebViewController*dVC = CREATCONTROLLER(STWebViewController);
        dVC.mType = Type_Special;
        dVC.bInfo = bInfo;
        
        dVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dVC animated:YES];
    }
}


#pragma mark  BannerCellDelegate
- (void)bannerSelected:(BannerInfo *)sInfo
{
    if(sInfo.specialType == STPOImageType)
    {
        // PO图专题
        SpecialViewController *SVC = (SpecialViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"HomeStoryboard" class:[SpecialViewController class]];
        SVC.bInfo = sInfo;
        SVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SVC animated:YES];
    }
    else if(sInfo.specialType == STWebType){
        STWebViewController*dVC = CREATCONTROLLER(STWebViewController);
        dVC.mType = Type_Special;
        dVC.bInfo = sInfo;
        
        dVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dVC animated:YES];
    }
}
@end
