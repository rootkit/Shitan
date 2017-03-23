//
//  NoticeViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/9/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "NoticeViewController.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "MessageDAO.h"
#import "MessageInfo.h"
#import "STWebViewController.h"
#import "HimselfViewController.h"
#import "MJRefresh.h"
#import "WeiboFollowedViewController.h"
#import "AddressBookViewController.h"
#import "ProfileTableViewController.h"
#import "TipsDetailsViewController.h"

@interface NoticeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, readwrite, nonatomic) MessageDAO *messageDAO;

@property (nonatomic, weak) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *msgArray;         //消息
@property (assign, nonatomic) NSInteger mPage;

@end

@implementation NoticeViewController

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
    [self requestMsgList];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)initDao{
    
    if (!self.messageDAO) {
        self.messageDAO = [[MessageDAO alloc] init];
    }
    
    _msgArray = [[NSMutableArray alloc] initWithCapacity:0];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _mPage = 1;
    [self requestMsgList];
}


// 下拉获取更多
- (void)footerRereshing
{
    _mPage ++;
    [self requestMsgList];
}



- (void)requestMsgList
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

    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"receiverId"];
    [dict setObject:[NSNumber numberWithInteger:_mPage] forKey:@"page"];
    [dict setObject:@"20" forKey:@"size"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_messageDAO requestMsgGet:requestDict completionBlock:^(NSDictionary *result) {
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            if ([result objectForKey:@"obj"]) {
                if (_mPage == 1) {
                    //如果请求的是第一页，则初始化array
                    [_msgArray removeAllObjects];
                }
                [_msgArray addObjectsFromArray:[result objectForKey:@"obj"]];
            }
            [self.tableView reloadData];
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
        
        
    } setFailedBlock:^(NSDictionary *result) {
        CLog(@"失败");
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_msgArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    MessageCell *cell = [MessageModel findCellWithTableView:tableView];
    //解析成数据模型
    MessageInfo *mesInfo = [[MessageInfo alloc] initWithParsData:[_msgArray objectAtIndex:row]];
    [cell setCellWithCellInfo:mesInfo cellWithRow:row];
    
    return cell;
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageInfo *msgInfo = [[MessageInfo alloc] initWithParsData:[_msgArray objectAtIndex:indexPath.row]];
    
    if (msgInfo.messageType == M_Welcome) {
        
        STWebViewController *dVC = CREATCONTROLLER(STWebViewController);
        dVC.urlSting = msgInfo.extra;
        dVC.titName = @"欢迎加入食探";
        dVC.mType = Type_Normal;
        dVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dVC animated:YES];
        
        return;
    }
    else if (msgInfo.messageType == M_ImgDelete || msgInfo.messageType == M_Praise || msgInfo.messageType == M_CommentOnImg || msgInfo.messageType == M_CommentOnComment) {
        //当为类型4、6、7、8时，进入图片详情页
        
        //评论
        TipsDetailsViewController *tipsVC = (TipsDetailsViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[TipsDetailsViewController class]];
        
        
        DynamicInfo *tempInfo = [[DynamicInfo alloc] init];
        tempInfo.imgId = msgInfo.imgId;
        tempInfo.imgUrl = msgInfo.extra;
        tempInfo.userId = msgInfo.receiverId;
        
        tipsVC.dyInfo = tempInfo;
        tipsVC.hidesBottomBarWhenPushed = YES;
        
        //美食日记图片点击
        tipsVC.m_Type = SecondTypeTips;
        
        [self.navigationController pushViewController:tipsVC animated:YES];
        return;
    }
    else
    {
        //当为类型2、3、5、9、10时，进入他人主页
        CLog(@"%@", [_msgArray objectAtIndex:indexPath.row]);
        
        if ([[AccountInfo sharedAccountInfo].userId isEqualToString:[[_msgArray objectAtIndex:indexPath.row] objectForKey:@"senderId"]]) {
            ProfileTableViewController *hVC = [[ProfileTableViewController alloc] init];
            hVC.isFromTabbar = NO;
            [self.navigationController pushViewController:hVC animated:YES];
        }
        else{
            //关注应该跳转到Himself
            UIStoryboard *MineStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
            HimselfViewController *hVC = [MineStoryboard instantiateViewControllerWithIdentifier:@"HimselfViewController"];
            hVC.respondentUserId = [[_msgArray objectAtIndex:indexPath.row] objectForKey:@"senderId"];
            hVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hVC animated:YES];
        }
        
        
        return;
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
