//
//  BroadcastViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/9/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "BroadcastViewController.h"
#import "MJRefresh.h"
#import "SimpleCell.h"
#import "SimpleModel.h"
#import "BroadcastInfo.h"
#import "STWebViewController.h"


@interface BroadcastViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *broadcastArray;   //广播
@property (strong, readwrite, nonatomic) MessageDAO *messageDAO;
@property (assign, nonatomic) NSInteger mPage;

@end

@implementation BroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDao];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height - 84) style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:NO tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self setupRefresh];
    [self setExtraCellLineHidden:self.tableView];
    
    _mPage = 1;
    [self requestBroadcastList];
    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)initDao{
    
    if (!self.messageDAO) {
        self.messageDAO = [[MessageDAO alloc]init];
    }
    
    _broadcastArray = [[NSMutableArray alloc] initWithCapacity:0];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _mPage = 1;
    [self requestBroadcastList];

}


// 下拉获取更多
- (void)footerRereshing
{
    _mPage ++;
    [self requestBroadcastList];
}

//广播
- (void)requestBroadcastList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:[NSNumber numberWithInteger:_mPage] forKey:@"page"];
    [dict setObject:@"20" forKey:@"size"];
    
    [_messageDAO requestBroadcast:dict completionBlock:^(NSDictionary *result) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            if ([result objectForKey:@"obj"]) {
                if (_mPage == 1) {
                    //如果请求的是第一页，则初始化array
                    [_broadcastArray removeAllObjects];
                }
                [_broadcastArray addObjectsFromArray:[result objectForKey:@"obj"]];
            }
            [self.tableView reloadData];
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];

}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_broadcastArray count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *text = [[_broadcastArray objectAtIndex:indexPath.row] objectForKey:@"description"];
    return [self calculateDesLabelheight:text] + 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

    SimpleCell *cell = [SimpleModel findCellWithTableView:tableView];
    BroadcastInfo *nInfo = [[BroadcastInfo alloc] initWithParsData:[_broadcastArray objectAtIndex:row]];
    //解析成数据模型
    [cell setCellWithCellBroadCastInfo:nInfo cellWithRow:row];
    
    return cell;

}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    BroadcastInfo *bInfo = [[BroadcastInfo alloc] initWithParsData:[_broadcastArray objectAtIndex:indexPath.row]];
    
    if (bInfo.url) {
        
        STWebViewController*dVC = CREATCONTROLLER(STWebViewController);
        dVC.urlSting = bInfo.url;
        dVC.titName = bInfo.title;
        dVC.mType = Type_Normal;
        dVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dVC animated:YES];
    }
}

// 计算DesLabl的高度
- (CGFloat)calculateDesLabelheight:(NSString *)text
{
    UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:13.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(MAINSCREEN.size.width-30, 2000);
    
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size.height;
}

//清除多余分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
