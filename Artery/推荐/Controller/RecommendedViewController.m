//
//  RecommendedViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/8/12.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RecommendedViewController.h"
#import "RMMerchantsViewController.h"
#import "STSearchViewController.h"
#import "SpecialViewController.h"
#import "STWebViewController.h"
#import "ScreenView.h"
#import "RecommendDAO.h"
#import "RecommendInfo.h"
#import "MJRefresh.h"
#import "RecommendCell.h"
#import "BannerCell.h"
#import "BannerCellModel.h"
#import "ColumnDAO.h"
#import "BannerInfo.h"
#import "STConditionView.h"
#import <CoreLocation/CoreLocation.h>

@interface RecommendedViewController ()<UITableViewDataSource, UITableViewDelegate, STConditionViewDelegate, BannerCellDelegate, ScreenViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) RecommendDAO *dao;
@property (nonatomic, strong) ColumnDAO *cDAO;

@property (nonatomic, strong) NSArray *bannerArray;             //广告条数组
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, assign) NSUInteger mPage;

@property (nonatomic, weak) STConditionView *conditionView;

@property (nonatomic, assign) NSUInteger mSort;
@property (nonatomic, strong) NSString *businessClass;       //分类ID

@property (nonatomic, strong) NSString *aeraId;
@property (nonatomic, strong) NSString *classId;

@property (nonatomic, strong) NSString *areaKey;
@property (nonatomic, strong) NSString *classKey;

@end

@implementation RecommendedViewController


- (void)initDAO
{
    if (!_dao) {
        self.dao = [[RecommendDAO alloc] init];
    }
    
    if (!_cDAO) {
        self.cDAO = [[ColumnDAO alloc] init];
    }

    _tableArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mPage = 1;
    _mSort = 0;
    
    _areaKey = @"全部";
    _classKey = @"全部";
    
    [self hideNavBar:YES];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height+20) style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:NO tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];

    
    [self initDAO];
    
    [self getBannerList];
    
    [self findRecommendList];
    
    [self setupRefresh];
    
    [self drawTopMenu];

}

- (void)drawTopMenu
{
    //添加顶部条件选择view
    STConditionView *conditionView = [[STConditionView alloc] init];
    _conditionView = conditionView;
    
    CGFloat conditionViewW = MAINSCREEN.size.width * 0.9;
    CGFloat conditionViewH = conditionViewW * 0.13;
    CGFloat conditionViewY = 34;
    
    _conditionView.frame = CGRectMake(0, conditionViewY, MAINSCREEN.size.width, conditionViewH);
    _conditionView.delegate = self;
    [self.view addSubview:_conditionView];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

//刷新
- (void)headerRereshing
{
    _mPage = 1;
    [self getBannerList];
    
    [self findRecommendList];
    
    self.tableView.footer.hidden = NO;
    
}

// 下拉获取更多
- (void)footerRereshing
{
    _mPage++;
    [self findRecommendList];
}

- (void)findRecommendList
{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        MET_MIDDLE(@"定位失败，请开启定位或检查网络状况");
    }
    
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dict setObject:theAppDelegate.cInfo.cityId forKey:@"cityId"];
    
    if (theAppDelegate.longitude) {
        [dict setObject:theAppDelegate.latitude forKey:@"latitude"];
        [dict setObject:theAppDelegate.longitude forKey:@"longitude"];
    }
    else{
        [dict setObject:@"22.556719" forKey:@"latitude"];
        [dict setObject:@"113.946318" forKey:@"longitude"];
    }
    
    
    if([AccountInfo sharedAccountInfo].userId)
    {
        [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    }
    
    //区域ID
    if(_businessClass)
        [dict setObject:_businessClass forKey:@"businessClass"];
    
    //最新
    [dict setObject:[NSNumber numberWithInteger:_mSort] forKey:@"sort"];

    [dict setObject:[NSNumber numberWithInteger:_mPage] forKey:@"page"];
    [dict setObject:[NSNumber numberWithInteger:10] forKey:@"size"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_dao getRecommendList:requestDict completionBlock:^(NSDictionary *result) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if (result.code == 200) {
            [self pairsData:result.obj];
        }
        else{
            
            if (_mPage == 1) {
                [self addPromptView];
                [self.tableArray removeAllObjects];
                [self.tableView reloadData];
            }
            // 变为没有更多数据的状态
            self.tableView.footer.hidden = YES;
//            MET_MIDDLE(@"您真是个大吃货！本页已经被你刷完啦");
            
        }
        if(_mPage == 1)
        {
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }
    setFailedBlock:^(NSDictionary *result) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

- (void)pairsData:(NSArray *)array
{
    if (!array || array.count == 0) {
        self.tableView.footer.hidden = YES;
//        MET_MIDDLE(@"您真是个大吃货！本页已经被你刷完啦");
        if (_mPage == 1) {
            [self addPromptView];
            [self.tableArray removeAllObjects];
            [self.tableView reloadData];
        }
        else{
            [self removePromptView];
        }
        
        return;
    }
    
    
    
    [self removePromptView];
    
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *item in array) {
        RecommendInfo *rInfo = [[RecommendInfo alloc] initWithParsData:item];
        [tempA addObject:rInfo];
    }
    
    if (_mPage == 1) {
        self.tableArray = tempA;
    }
    else{
        [self.tableArray addObjectsFromArray:tempA];
    }

    
    [self.tableView reloadData];
}


//增加提示语句
- (void)addPromptView
{
    UIImageView *titLabel = (UIImageView *)[self.view viewWithTag:0x128];
    if (!titLabel) {
        titLabel = [[UIImageView alloc] initWithFrame:CGRectMake((MAINBOUNDS.size.width - 244)/2, (MAINBOUNDS.size.height - 72)/2, 244, 72)];
        [titLabel setImage:[UIImage imageNamed:@"tip_no"]];
        titLabel.tag = 0x128;
    }

    [self.tableView addSubview:titLabel];
}


//删除提示语句
- (void)removePromptView
{
    UIImageView *titLabel = (UIImageView *)[self.view viewWithTag:0x128];
    if (titLabel) {
        [titLabel removeFromSuperview];
    }
}


// 获取广告条列表
- (void)getBannerList
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:@"0" forKey:@"cityId"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_cDAO RequestBannerList:requestDict completionBlock:^(NSDictionary *result) {
        if (result.code == 200) {
            NSArray *temp = result.obj;
            CLog(@"%@",temp);
            
            [self parsBannerData:temp];
        }
        else
        {
            
            
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}

// 解析BannerList
- (void)parsBannerData:(NSArray *)array
{
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *item in array) {
        BannerInfo *bInfo = [[BannerInfo alloc] initWithParsData:item];
        [tempA addObject:bInfo];
    }
    self.bannerArray = tempA;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSUInteger num = _bannerArray ? self.tableArray.count +1 : self.tableArray.count;
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //有banner
    if (_bannerArray) {
        if(indexPath.section == 0){
            if (MAINSCREEN.size.width == IPHONE6_PLUS_WIDTH){
                return IMAGE_H_IPHONE6_Plus;
            }
            else if (MAINSCREEN.size.width == IPHONE6_WIDTH) {
                return IMAGE_H_IPHONE6;
            }
            else
                return IMAGE_H_IPHONE5;
            
        }
        else
        {
            if (MAINSCREEN.size.width == IPHONE6_PLUS_WIDTH){
                return IMAGE_H_IPHONE6_Plus;
            }
            else if (MAINSCREEN.size.width == IPHONE6_WIDTH) {
                return IMAGE_H_IPHONE6;
            }
            else
                return IMAGE_H_IPHONE5;
        }
    }

    /**
     *  无Banner
     */
    if (MAINSCREEN.size.width == IPHONE6_PLUS_WIDTH){
        return IMAGE_H_IPHONE6_Plus;
    }
    else if (MAINSCREEN.size.width == IPHONE6_WIDTH) {
        return IMAGE_H_IPHONE6;
    }
    else
        return IMAGE_H_IPHONE5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_bannerArray) {
        if(indexPath.section == 0)
        {
            BannerCell *bCell = [BannerCellModel findCellWithTableView:tableView];
            bCell.delegate = self;
            [bCell setCellWithCellInfo:self.bannerArray];
            
            return bCell;
        }
        else
        {
            RecommendCell *cell = [RecommendCell cellWithTableView:tableView];
            RecommendInfo *mInfo = _tableArray[indexPath.section-1];
            [cell setCellWithCellInfo:mInfo];
            return cell;
        }
    }
    else
    {
        RecommendCell *cell = [RecommendCell cellWithTableView:tableView];
        RecommendInfo *mInfo = _tableArray[indexPath.section];
        [cell setCellWithCellInfo:mInfo];
        
        return cell;
    }

    return nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RMMerchantsViewController *pv = CREATCONTROLLER(RMMerchantsViewController);
    if (_bannerArray) {
        if (indexPath.section > 0) {
            pv.rInfo = _tableArray[indexPath.section - 1];
        }
    }
    else
    {
        pv.rInfo = _tableArray[indexPath.section];
    }
    
    pv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pv animated:YES];
}


#pragma mark  BannerCellDelegate
- (void)bannerSelected:(BannerInfo *)sInfo
{
    if(sInfo.specialType == STPOImageType)
    {
        if(!theAppDelegate.isLogin)
        {
            //弹出登录
            STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
            STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
            nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
            nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
            nc.view.layer.shadowOpacity = 0.2;
            
            [self presentViewController:nc animated:YES completion:nil];
            
            return;
        }
        
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


#pragma mark  STConditionViewDelegate
- (void)conditionView:(STConditionView *)view didButtonClickFrom:(STConditionButtonType)index
{
    if(index == STConditionButtonTypeMenu)
    {
        [self openLeftMenu];
    }
    else if (index == STConditionButtonTypeNew || index == STConditionButtonTypeArea || index == STConditionButtonTypePersonality)
    {
        ScreenView *svc = [ScreenView screenView];
        svc.delegate = self;
        
        if (index == STConditionButtonTypeNew ) {
            CLog(@"%lu", (unsigned long)_mSort);
            svc.indexA = _mSort;
        }
        else if (index == STConditionButtonTypeArea)
        {
            svc.areaKey = _areaKey;
            
        }
        else if(index == STConditionButtonTypePersonality)
        {
            svc.classKey = _classKey;
        }
        
        [svc showScreenViewToView:self.view];
        
        svc.sType = index;

        
        
        
    }
    else if (index == STConditionButtonTypeSearch)
    {
        STSearchViewController *svc = CREATCONTROLLER(STSearchViewController);
        [self.navigationController pushViewController:svc animated:YES];
    }
}

#pragma mark  ScreenViewDelegate
- (void)screenView:(ScreenView *)view seletedBtnWithKeyword:(NSString *)keyword
 seletedWithCityID:(NSString *)cityId type:(STConditionButtonType)mType
{
    [_conditionView setButtonTitle:keyword didButtonClickFrom:mType];
    
    if (mType ==  STConditionButtonTypeNew) {
        if ([keyword isEqualToString:@"最新"]) {
            _mSort = 0;
        }
        if ([keyword isEqualToString:@"最热"]) {
            _mSort = 1;
        }
        if ([keyword isEqualToString:@"最近"]) {
            _mSort = 2;
        }
    }
    else if (mType == STConditionButtonTypeArea)
    {
        _aeraId = cityId;
        _areaKey = keyword;
        
        NSMutableArray *_arr = [[NSMutableArray alloc] initWithCapacity:0];
        if (_aeraId) {
            [_arr addObject:_aeraId];
        }
        
        if (_classId) {
            [_arr addObject:_classId];
        }
        
        
        _businessClass = [_arr componentsJoinedByString:@","];
    }
    else if(mType == STConditionButtonTypePersonality)
    {
        _classId = cityId;
        _classKey = keyword;
        
        NSMutableArray *_arr = [[NSMutableArray alloc] initWithCapacity:0];
        if (_aeraId) {
            [_arr addObject:_aeraId];
        }
        
        if (_classId) {
            [_arr addObject:_classId];
        }
        
        
        _businessClass = [_arr componentsJoinedByString:@","];
    }
    
    
    
    _mPage = 1;
    
    [self findRecommendList];


}


@end
