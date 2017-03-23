//
//  ResultDetailsViewController.m
//  Shitan
//
//  Created by RichardLiu on 15/3/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ResultDetailsViewController.h"
#import "ShopMapViewController.h"
#import "TipsConTableViewCell.h"
#import "TipsConModel.h"
#import "CompositeInfo.h"
#import "QueryDAO.h"
#import "DPDao.h"
#import "ShopDetailsInfo.h"
#import "ResultsImageTableViewCell.h"
#import "ResultImagesModel.h"
#import "ResultItemViewController.h"
#import "GroupListViewController.h"
#import "GroupInfo.h"

@interface ResultDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) QueryDAO *qDao;
@property (nonatomic, strong) DPDao *dDao;
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) NSArray *groupArray;          //团购数组
@property (nonatomic, assign) NSUInteger isHaveG;           //是否有团购信息

@property (nonatomic, assign) NSUInteger mPage;

@property (nonatomic, strong) UIStoryboard *board;

@end

@implementation ResultDetailsViewController

- (void)initDao
{
    if (!_qDao) {
        self.qDao = [[QueryDAO alloc] init];
    }
    
    if (!_dDao) {
        self.dDao = [[DPDao alloc] init];
    }
    
    _tableArray = [[NSMutableArray alloc] init];
    _isHaveG = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"店铺菜品列表"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"店铺菜品列表"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    
    if (_sInfo.addressName && _sInfo.branchName.length > 1) {
        [self setNavBarTitle:[NSString stringWithFormat:@"%@（%@）", _sInfo.addressName, _sInfo.branchName]];
    }
    else{
        [self setNavBarTitle:_sInfo.addressName];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (isIOS8) {
        [_tableView setFrame:CGRectMake(0, 44, MAINSCREEN.size.width, MAINSCREEN.size.height-24)];
    }
    else{
        [_tableView setFrame:CGRectMake(0, 64, MAINSCREEN.size.width, MAINSCREEN.size.height-44)];
    }
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

    
    [self initDao];
    
    //搜索店铺中的所有菜
    _mPage = 1;
    [self FindShopsAllDishes:_mPage];

    _tableView.backgroundColor = BACKGROUND_COLOR;
    
    [self requestMerchantsGroup];
}

//获取特定商户团购信息
- (void)requestMerchantsGroup
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    if(!_sInfo.city || !_sInfo.businessId)
    {
        return;
    }
    

    [dic setObject:_sInfo.city forKey:@"city"];
    [dic setObject:_sInfo.businessId forKey:@"business_id"];
    
    [_dDao GetMerchantsGroup:dic completionBlock:^(NSDictionary *result) {
        if ([result objectForKey:@"count"] > 0) {
            _isHaveG = [[result objectForKey:@"count"] integerValue];
            _groupArray = [self parsGroupInfo:[result objectForKey:@"deals"]];
            [_tableView reloadData];
        }
        
        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _isHaveG > 0 ? 3:2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        //有均价
        if ([_sInfo.avgPrice floatValue] > 0.1) {
            return 3;
        }
        
        return 2;
    }
    
    return 1;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    else
    {
        if (_isHaveG > 0 && indexPath.section == 1) {
            return 44;
        }
        else{
            //计算cell的高度
            NSUInteger mx = _tableArray.count/2;
            NSUInteger my = _tableArray.count%2;
            
            //单个图片宽度
            CGFloat singleW = (MAINSCREEN.size.width -16*3)/2;
            //总高度
            CGFloat s_high = (singleW+16) *(mx + my) + 16;
            //顶部高度55
            return s_high + 40;
        }
    }
    
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        TipsConTableViewCell *tipCell = [TipsConModel findCellWithTableView:tableView];
        [tipCell setCellWithCellInfo:_sInfo setRow:indexPath.row];
        tipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tipCell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        if (indexPath.row == 2) {
            tipCell.accessoryType = UITableViewCellAccessoryNone;
            tipCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return tipCell;
    }
    else
    {
        if (_isHaveG > 0 && indexPath.section == 1) {
            static NSString *ID = @"reuseCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            }
            
            cell.imageView.image = [UIImage imageNamed:@"detail_grouponicon.png"];
            cell.imageView.layer.cornerRadius = 2;//设置那个圆角的有多圆
            cell.imageView.layer.masksToBounds = YES;//设为NO去试试
            cell.textLabel.text = [NSString stringWithFormat:@"查看本店的%lu处团购信息", (unsigned long)_isHaveG];
            
            return cell;
        }
        else{
            ResultsImageTableViewCell *imageCell = [ResultImagesModel findCellWithTableView:tableView];
            [imageCell setCellWithCellInfo:_tableArray isHideHead:NO];
            imageCell.controller = self;
            imageCell.itemController = nil;
            return imageCell;
        }
    }
    
    return nil;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
            ShopMapViewController *tVC = [board instantiateViewControllerWithIdentifier:@"ShopMapViewController"];
            tVC.sInfo = _sInfo;
            
            [self.navigationController pushViewController:tVC animated:YES];
        }
        else if(indexPath.row == 1)
        {
            //拨打电话
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",_sInfo.phone];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
    }
    else if (_isHaveG > 0 && indexPath.section == 1)
    {
        GroupListViewController *gVC = (GroupListViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[GroupListViewController class]];
        gVC.tableArray = _groupArray;
        [self.navigationController pushViewController:gVC animated:YES];
    }
}


//获取店铺中所有的菜品
- (void)FindShopsAllDishes:(NSUInteger)page
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (_sInfo.addressId) {
        [dic setObject:_sInfo.addressId forKey:@"addressId"];
    }

    
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:20] forKey:@"size"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];

    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_qDao QueryListAll:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            
            if ([[result objectForKeyNotNull:@"obj"] count] > 0) {
                NSArray *tempA = [self parsItemInfo:[result objectForKeyNotNull:@"obj"]];
                NSLog(@"%@",tempA);
                [self.tableArray addObjectsFromArray:tempA];
                
                [_tableView reloadData];
            }
            
        }
    } setFailedBlock:^(NSDictionary *result) {
        CLog(@"%@", result);
    }];
}


//解析单品图片
- (NSArray *)parsItemInfo:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in array) {
        ItemInfo *tInfo = [[ItemInfo alloc] initWithParsData:item];
        [tempArray addObject:tInfo];
        
    }
    
    return tempArray;
}


- (void)imageBtnTapped:(ItemInfo *)tInfo
{
    ResultItemViewController *dVC = [_board instantiateViewControllerWithIdentifier:@"ResultItemViewController"];
    dVC.itemInfo = tInfo;
    dVC.sInfo = _sInfo;
    [self.navigationController pushViewController:dVC animated:YES];
}


//解析团购信息
- (NSArray *)parsGroupInfo:(NSArray *)array
{
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in array) {
        GroupInfo *tInfo = [[GroupInfo alloc] initWithParsData:item];
        [tempA addObject:tInfo];
        
    }
    return tempA;
}


@end
