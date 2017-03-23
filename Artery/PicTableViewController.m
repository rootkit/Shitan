//
//  PicTableViewController.m
//  Shitan
//
//  Created by Avalon on 15/4/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "PicTableViewController.h"
#import "PicListTableViewCell.h"
#import "PicListTableModel.h"
#import "ImageDAO.h"
#import "UserRelationshipDAO.h"
#import "HostViewController.h"
#import "MJRefresh.h"

#define kNavBarHeight 44

@interface PicTableViewController ()<PicListTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) ImageDAO *imageDao;

//图片日期数据
@property (nonatomic, strong) NSMutableArray *dateArray;

//图片列表数据
@property (nonatomic, strong) NSMutableArray *imageList;
@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSMutableArray *photos;     //图片

@property (nonatomic, weak) UITableView *tableview;



@end

@implementation PicTableViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self headerRereshing];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarTitle:@"我的美食日记"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initDao];
    
    //获取用户的发布时间
    //[self getUserPublishTimes];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(10, kNavBarHeight, MAINSCREEN.size.width - 20, MAINSCREEN.size.height - 20) style:UITableViewStyleGrouped];
    self.tableview = tableview;
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.showsVerticalScrollIndicator = FALSE;
    [self.view addSubview:self.tableview];
    

    [self setUpRefresh];

}


- (void)setUpRefresh
{
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
}

- (void)headerRereshing{
    
    [self getUserPublishTimes];
}


- (void)initDao{
    
    if (!_imageDao) {
        _imageDao = [[ImageDAO alloc] init];
    }

    
    _dateArray = [[NSMutableArray alloc] init];
    _imageList = [[NSMutableArray alloc] init];

}


//增加提示语句
- (void)addPromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (!titLabel) {
        titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, MAINSCREEN.size.width, 30)];
        titLabel.textAlignment = NSTextAlignmentCenter;
        titLabel.tag = 0x128;
    }
    
    titLabel.text = @"无数据";
    [titLabel setFont:[UIFont systemFontOfSize:18.0]];
    [titLabel setTextColor:[UIColor lightGrayColor]];
    [self.tableview addSubview:titLabel];
}


//删除提示语句
- (void)removePromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (titLabel) {
        [titLabel removeFromSuperview];
    }
}


#pragma mark 网络请求
//获取发布图片的日期
- (void)getUserPublishTimes
{
    self.tableview.hidden = NO;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    [_imageDao requestPublishTimes:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            if ([result objectForKey:@"obj"] && [[result objectForKey:@"obj"] count] > 0) {
    
                _dateArray = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"obj"]];
                [self getUserImgs];
                [self removePromptView];
            }
            else{
                [self.imageList removeAllObjects];
                
                [self.tableview reloadData];
                [self addPromptView];
            }
        }
        else
        {
            [self.imageList removeAllObjects];
            [self.tableview reloadData];
            [self addPromptView];
        }
        [self.tableview.header endRefreshing];
        
    } setFailedBlock:^(NSDictionary *result) {
        
        MET_MIDDLE([result objectForKey:@"msg"]);
        [self.tableview.header endRefreshing];
        
    }];
    
}

- (void)getUserImgs
{
    //分组 一组为20个
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    NSString *dateS = [_dateArray componentsJoinedByString:@","];
    [dic setObject:dateS forKey:@"dates"];
    
    [self.imageList removeAllObjects];
    
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_imageDao requestFoodDiary:requestDict completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            if ([result objectForKey:@"obj"]) {
                
                [self.imageList addObjectsFromArray:[result objectForKey:@"obj"]];
                
                [self.tableview reloadData];
                
                [self.tableview.header endRefreshing];
                
            }
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        [self.tableview.header endRefreshing];
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_imageList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


//预设高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLog(@"%ld", (long)indexPath.section);
    CGFloat m_cellHight;
    
    if (_imageList.count > 0) {
        NSDictionary *imgDic = [_imageList objectAtIndex:indexPath.section];
        NSInteger count = [[imgDic objectForKey:@"count"] integerValue];
        
        NSInteger i = count/3;
        NSInteger j = count%3;
        
        CGFloat imageWidth = (MAINSCREEN.size.width-50.0)/3.0;
        
        if (j > 0) {
            j = 1;
        }
        
        m_cellHight = 10.0 + ((i+j)*imageWidth + (i+j-1)*5.0) + 10.0;

    }
    
    
    return m_cellHight;
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 40)];
    [headerView setBackgroundColor:MINE_FAVORITE_BACKGROUND_COLOR];
    UILabel *headerLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    headerLab1.textColor = MAIN_TIME_COLOR;
    headerLab1.font = [UIFont systemFontOfSize:14.0f];
    
    UILabel *headerLab2 = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width-50.0, 10, 100, 30)];
    headerLab2.textColor = MAIN_TIME_COLOR;
    headerLab2.font = [UIFont systemFontOfSize:14.0f];
    
    
    if (_imageList.count > 0) {
        NSDictionary *imgDic = [_imageList objectAtIndex:section];
        if (imgDic) {
            headerLab1.text = [NSString stringWithFormat:@"%@", [imgDic objectForKey:@"date"]];
            headerLab2.text = [NSString stringWithFormat:@"%@张", [imgDic objectForKey:@"count"]];
            [headerView addSubview:headerLab1];
            [headerView addSubview:headerLab2];
        }
    }
    
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, MAINSCREEN.size.width, 10);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PicListTableViewCell *cell = [PicListTableModel findCellWithTableView:tableView];
    cell.delegate = self;
    
    
    if (_imageList.count > 0) {
        NSDictionary *imgDic = [_imageList objectAtIndex:indexPath.section];
        NSArray *imgArray = [imgDic objectForKey:@"imgs"];
        [cell initWithParsData:imgArray intWithSection:indexPath.section];

    }
    
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark PicListTableViewCellDelegate
- (void)clickImageViewTappedWithSection:(NSInteger )section withRow:(NSInteger)row;
{
    
    NSInteger key = 0, m_section = 0;
    
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *item in _imageList) {
        NSArray *ta = [item objectForKey:@"imgs"];
        
        NSInteger count = [[item objectForKey:@"count"] integerValue];
        if (m_section < section) {
            key =  key + count;
        }
        
        [tempA addObjectsFromArray:ta];
        
        m_section++;
    }
    
    key = key + row;
    
    UIStoryboard *dyBoard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    
    HostViewController *tipsVC = [dyBoard instantiateViewControllerWithIdentifier:@"HostViewController"];
    tipsVC.tableArray = tempA;
    tipsVC.m_row = key;
    tipsVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:tipsVC animated:YES];
}

@end
