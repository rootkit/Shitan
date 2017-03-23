//
//  TipsDetailsViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-10-24.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "TipsDetailsViewController.h"
#import "ImageDAO.h"
#import "DynamicTableViewCell.h"
#import "DynamicCellModel.h"
#import "ProfileTableViewController.h"
#import "HimselfViewController.h"
#import "TipsConModel.h"
#import "TipsConTableViewCell.h"
#import "ShopMapViewController.h"
#import "CommentListViewController.h"
#import "CollectionTypeViewController.h"
#import "SGActionView.h"
#import "ShareModel.h"
#import "MLEmojiLabel.h"
#import "UserListViewController.h"
#import "MJRefresh.h"
#import "ResultDetailsViewController.h"

#define  OFFSET_X_LEFT      30      //评论或者赞（文字距离左侧的距离）
#define  OFFSET_X_RIGHT     12

@interface TipsDetailsViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger           topID;          //最新图片的ID
    NSInteger           bottomID;       //最老的图片ID
}

@property (strong, nonatomic) ImageDAO *dao;
@property (nonatomic, strong) DynamicInfo *mInfo;

//分享
@property (nonatomic, strong) NSArray *openArray;
@property (nonatomic, strong) NSArray *openImageArray;


@end

@implementation TipsDetailsViewController


- (void)initDao
{
    if (!self.dao) {
        self.dao = [[ImageDAO alloc] init];
    }
    
    _tableArray = [[NSMutableArray alloc] init];
    
    _coreDataMange = [[CoreDataManage alloc] init];
    
    //精选
    _coreDataMange.tableTag = 3;
}


//写入数据
- (void)writeDate:(NSArray *)array{
    if ([array isKindOfClass:[NSArray class]] && [array count] > 0)
    {
        [_coreDataMange insertCoreData:array];
    }
}


/**
 *  读取数据（数据库数据）
 *  无网络请求时读取、启东时先读取本地数据
 *  @return
 */
- (void)readData{
    
    //先清空
    [self.tableArray removeAllObjects];
    NSArray *array  = [_coreDataMange selectCoreData];
    
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (DynamicModelFrame *item in array) {
        [tempA addObject:item.dInfo];
    }
    [self.tableArray addObjectsFromArray:tempA];
    
    [self.tableView reloadData];
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}


#pragma mark 开始进入刷新状态
//刷新
- (void)headerRereshing
{
    self.isMore = NO;
    
    [self getTagWithImages];
}

// 下拉获取更多
- (void)footerRereshing
{
    self.isMore = YES;

    [self getTagWithImages];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"图片详情"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"图片详情"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDao];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, MAINSCREEN.size.width, MAINSCREEN.size.height) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    

    self.view.backgroundColor = BACKGROUND_COLOR;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
    if (_isHideNav) {
        [self hideNavBar:YES];
        self.tableView.frame = CGRectMake(0, 20, MAINSCREEN.size.width, MAINSCREEN.size.height - 44);
        [self setNavBarTitle:@"图片详情"];
    }
    else
    {
        self.tableView.frame = CGRectMake(0, 64, MAINSCREEN.size.width, MAINSCREEN.size.height - 44);
        //self.topHight.constant = -10.0;
    }
    
    switch (_m_Type) {
        case FistTypeTips:
        {
            [self setNavBarTitle:_bubbleV.tipName];
            //获取标签下得图片
            [self performSelector:@selector(getTagWithImages) withObject:nil afterDelay:0.2];
            // 集成刷新控件
            [self setupRefresh];
        }
            
            break;
            
        case SecondTypeTips:
        {
            [self setNavBarTitle:@"图片详情"];
            
            //获取图片信息
            [self getImagePointAndSDetails];
        }
            break;
            
        default:
            break;
    }
}


/**
 *  获取图片信息（其他入口进入需要调用）
 */
- (void)getImagePointAndSDetails
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_dyInfo.imgId forKey:@"imgId"];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    
    [_dao requestImageInfo:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            CLog(@"%@", [result objectForKey:@"obj"]);
            if ([result objectForKey:@"obj"]) {
                
                NSArray *temp = [result objectForKey:@"obj"];
                
                if (!self.isMore){
                    [self.tableArray removeAllObjects];
                    [self.tableView.header endRefreshing];
                    
                    //先清空数据
                    [_coreDataMange clearAllData];
                }
                else{
                    [self.tableView.footer endRefreshing];
                }
                
                if ([temp isKindOfClass:[NSArray class]] && [temp count] > 0) {
                    self.topId = [[[temp objectAtIndex:[temp count]-1] objectForKey:@"id"]integerValue] - 1;
                    [self.tableArray addObjectsFromArray:[self parisDataWithArray:temp]];
                    
                    [self writeDate:temp];
                    
                }
                
                if ([temp isKindOfClass:[NSDictionary class]] && [temp count] > 0) {

                    [self.tableArray addObject:[[DynamicInfo alloc] initWithParsData:(NSDictionary *)temp]];
                    NSMutableArray *t = [NSMutableArray arrayWithObjects:temp, nil];
                    [self writeDate:t];
                }

                [_tableView reloadData];
            }
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}


//获取标签下的图片
- (void)getTagWithImages
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    //信息条数
    [dict setObject:[NSNumber numberWithInt:20] forKey:@"size"];
    
    if (!_bubbleV.tipID)
    {
        if (_hostVC) {
            [_hostVC.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [dict setObject:_bubbleV.tipID forKey:@"tagId"];
    
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    //该页最大的ID
    if (self.isMore) {
        [dict setObject:[NSNumber numberWithInteger:self.topId] forKey:@"topId"];
    }
    
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_dao requestImageListByTags:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] intValue] == 200) {
            if ([result objectForKey:@"obj"]) {
                
                NSArray *temp = [result objectForKey:@"obj"];
                
                
                if (!self.isMore){
                    [self.tableArray removeAllObjects];
                    [self.tableView.header endRefreshing];
                    
                    //先清空数据
                    [_coreDataMange clearAllData];
                }
                else{
                    [self.tableView.footer endRefreshing];
                }
                
                if ([temp isKindOfClass:[NSArray class]] && [temp count] > 0) {
                    self.topId = [[[temp objectAtIndex:[temp count]-1] objectForKey:@"id"]integerValue] - 1;
                    [self.tableArray addObjectsFromArray:[self parisDataWithArray:temp]];
                    
                    [self writeDate:temp];
                }
                
                //重载
                [self.tableView reloadData];
            }
        }
        else{
            
        }
        
    }
                  setFailedBlock:^(NSDictionary *result) {
                      
                  }];
    
    
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

// 计算DesLabl的高度
- (CGFloat)calculateDesLabelheight:(NSString *)text
{
    UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:14.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(MAINSCREEN.size.width-24, 2000);
    
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size.height;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (_isShowPlace)
    {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_isShowPlace) {
        if (section == 0) {
            return 2;
        }
        return [_tableArray count];
    }
    
    return [_tableArray count];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isShowPlace) {
        if (indexPath.section == 0) {
            return 44.0;
        }
        else{
            if ([self.tableArray count] > 0) {
                
                return [self setCellWithCellInfo:[self.tableArray objectAtIndex:indexPath.row]];
            }
        }
        
    }
    else{
        return [self setCellWithCellInfo:[self.tableArray objectAtIndex:indexPath.row]];
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isShowPlace) {
        if (indexPath.section == 0) {
            TipsConTableViewCell *tipCell = [TipsConModel findCellWithTableView:tableView];
            [tipCell setCellWithCellInfo:_shopInfo setRow:indexPath.row];
            tipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            tipCell.selectionStyle = UITableViewCellSelectionStyleGray;
            return tipCell;
        }
        else{
            DynamicTableViewCell *cell = [DynamicCellModel findCellWithTableView:tableView];
            
            cell.tipsVC = self;
            cell.rVC = nil;
            cell.iVC = nil;
//            cell.dVC = nil;
            cell.sVC = nil;
            
            DynamicInfo *dInfo = [_tableArray objectAtIndex:indexPath.row];
            
            if (dInfo) {
                [cell setCellWithCellInfo:dInfo isShowfocusButton:_isShowfocus];
            }
            
            return cell;
        }
        
        
    }
    else{
        DynamicTableViewCell *cell = [DynamicCellModel findCellWithTableView:tableView];
        
        cell.tipsVC = self;
        cell.rVC = nil;
        cell.iVC = nil;
//        cell.dVC = nil;
        cell.sVC = nil;
        
        DynamicInfo *dInfo = [_tableArray objectAtIndex:indexPath.row];
        
        if (dInfo) {
            [cell setCellWithCellInfo:dInfo isShowfocusButton:_isShowfocus];
        }
        
        return cell;
    }
    
    return nil;
    
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isShowPlace) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
                    ShopMapViewController *tVC = [board instantiateViewControllerWithIdentifier:@"ShopMapViewController"];
                    tVC.sInfo = _shopInfo;
                    
                    if (_hostVC) {
                        [_hostVC.navigationController pushViewController:tVC animated:YES];
                        return;
                    }
                    
                    [self.navigationController pushViewController:tVC animated:YES];
                }
                    
                    break;
                    
                case 1:
                {
                    //拨打电话
                    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",_shopInfo.phone];
                    UIWebView * callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebview];
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
    }
}



//点击
- (void)imgaeHeadTapped:(NSString *)userID
{
    //自己就跳转到
    if ([userID isEqualToString:[AccountInfo sharedAccountInfo].userId]) {
        ProfileTableViewController *hVC = [[ProfileTableViewController alloc] init];
        hVC.isFromTabbar = NO;
        hVC.hidesBottomBarWhenPushed = YES;
        
        if (_hostVC) {
            [_hostVC.navigationController pushViewController:hVC animated:YES];
            return;
        }
        
        [self.navigationController pushViewController:hVC animated:YES];
        
    }
    else{
        
        UIStoryboard *MineStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
        HimselfViewController *hVC = [MineStoryboard instantiateViewControllerWithIdentifier:@"HimselfViewController"];
        hVC.respondentUserId = userID;
        hVC.hidesBottomBarWhenPushed = YES;
        
        if (_hostVC) {
            [_hostVC.navigationController pushViewController:hVC animated:YES];
            return;
        }
        [self.navigationController pushViewController:hVC animated:YES];
    }
}



//标签点击
- (void)clickBubbleViewWithInfo:(BubbleView *)bubleV shopWithInfo:(ShopInfo *)sInfo
{
    if(bubleV.tipType == Tip_Location)
    {
        //展现该商家的所有单品
        ResultDetailsViewController *dVC = (ResultDetailsViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[ResultDetailsViewController class]];
        dVC.sInfo = sInfo;
        //CLog(@"%@");
        dVC.hidesBottomBarWhenPushed = YES;
        
        if (_hostVC) {
            [_hostVC.navigationController pushViewController:dVC animated:YES];
            return;
        }
        [self.navigationController pushViewController:dVC animated:YES];
    }
    else{
        TipsDetailsViewController *tVC = (TipsDetailsViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[TipsDetailsViewController class]];
        tVC.bubbleV = bubleV;
        tVC.shopInfo = sInfo;
        
        //显示地点
        if (bubleV.tipType == Tip_Location) {
            tVC.isShowPlace = YES;
        }
        
        //标签点击
        tVC.m_Type = FistTypeTips;
        
        tVC.hidesBottomBarWhenPushed = YES;
        
        if (_hostVC) {
            [_hostVC.navigationController pushViewController:tVC animated:YES];
            return;
        }
        
        [self.navigationController pushViewController:tVC animated:YES];
    }
}


- (void)setHostVC:(HostViewController *)hostVC
{
    _hostVC = hostVC;
}

//关注
- (void)focusButtonTapped
{
    self.isMore = NO;
//    [self requestImagesList:_controller.cityN];
}

//喜欢(赞)
- (void)praiseButtonTapped:(PraiseInfo *)pInfo
{
    self.isMore = NO;
    //插入数据
    [_coreDataMange selectDataWithPraise:pInfo];
    
    [self performSelector:@selector(readData) withObject:nil afterDelay:0.4];
    
    
//    switch (_m_Type) {
//        case FistTypeTips:
//        {
//            //获取标签下得图片
//            [self getTagWithImages];
//        }
//            
//            break;
//            
//        case SecondTypeTips:
//        {
//            //获取图片信息
//            [self getImagePointAndSDetails];
//        }
//            break;
//            
//            default:
//            break;
//    }
    
}


//取消(赞)
- (void)cancelPraise:(PraiseInfo *)pInfo
{
    self.isMore = NO;
    
    //清除数据
    [_coreDataMange clearDataWithPraise:pInfo];
    [self performSelector:@selector(readData) withObject:nil afterDelay:0.4];
    
    
//    switch (_m_Type) {
//        case FistTypeTips:
//        {
//            //获取标签下得图片
//            [self getTagWithImages];
//        }
//            
//            break;
//            
//        case SecondTypeTips:
//        {
//            //获取图片信息
//            [self getImagePointAndSDetails];
//        }
//            break;
//            
//        default:
//            break;
//    }
}


//评论图片
- (void)commentsImage:(DynamicInfo *)dInfo
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    CommentListViewController *dVC = [board instantiateViewControllerWithIdentifier:@"CommentListViewController"];
    dVC.hidesBottomBarWhenPushed = YES;
    dVC.imageID = dInfo.imgId;
    dVC.userID = dInfo.userId;
    dVC.isPopKeyboard = YES;
    
    //入口来源
    dVC.mType = OtherType;
    
    if (_hostVC) {
        [_hostVC.navigationController pushViewController:dVC animated:YES];
        return;
    }
    
    [self.navigationController pushViewController:dVC animated:YES];
}

//收藏
- (void)collectionTypeChoose:(DynamicInfo *)dInfo
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];

    CollectionTypeViewController *coVC = [board instantiateViewControllerWithIdentifier:@"CollectionTypeViewController"];
    
    coVC.imageId = dInfo.imgId;
    coVC.hidesBottomBarWhenPushed = YES;
    
    if (_hostVC) {
        [_hostVC.navigationController pushViewController:coVC animated:YES];
        return;
    }
    
    [self.navigationController pushViewController:coVC animated:NO];
}

- (void)summarizeShareData{
    NSMutableArray *tA = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tB = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
    {
        [tA addObject:@"QQ好友"];
        [tA addObject:@"QQ空间"];
        
        [tB addObject:[UIImage imageNamed:@"sns_icon_1"]];
        [tB addObject:[UIImage imageNamed:@"sns_icon_2"]];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]])
    {
        [tA addObject:@"微信好友"];
        [tA addObject:@"微信朋友圈"];
        
        [tB addObject:[UIImage imageNamed:@"sns_icon_4"]];
        [tB addObject:[UIImage imageNamed:@"sns_icon_5"]];
    }
    
    
    
    if ([_mInfo.userId isEqualToString:[AccountInfo sharedAccountInfo].userId])
    {
        [tA addObject:@"删除"];
        [tB addObject:[UIImage imageNamed:@"sns_icon_6"]];
    }
    else
    {
        //0为普通用户，1为管理员，2为超级管理员
        if ([AccountInfo sharedAccountInfo].userType != 0) {
            [tA addObject:@"举报"];
            [tB addObject:[UIImage imageNamed:@"sns_icon_7"]];
            
            [tA addObject:@"隐藏"];
            [tB addObject:[UIImage imageNamed:@"sns_icon_8"]];
        }
        else
        {
            [tA addObject:@"举报"];
            [tB addObject:[UIImage imageNamed:@"sns_icon_7"]];
        }
    }
    
    
    _openArray = tA;
    _openImageArray = tB;
}


//更多
- (void)moreButtonTapped:(DynamicInfo *)dInfo
{
    _mInfo = dInfo;
    
    [self summarizeShareData];
    
    
    [SGActionView sharedActionView].style = SGActionViewStyleLight;
    [SGActionView showGridMenuWithTitle:nil
                             itemTitles:_openArray
                                 images:_openImageArray
                         selectedHandle:^(NSInteger index) {
                             [self didClickOnImageIndex:index];
                         }];
    
}

- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    if (imageIndex == 0)
    {
        return;
    }
    
    
    NSString *description = @"美食推荐";
    
    NSArray *tagsArray = _mInfo.tags;
    
    if (_mInfo.tags != nil) {
        for (TipInfo *tInfo in tagsArray) {
            if (tInfo.tipType == Tip_FoodN) {
                description = [description stringByAppendingString:[NSString stringWithFormat:@":%@", tInfo.title]];
            }
        }
        
        for (TipInfo *tInfo in tagsArray) {
            if (tInfo.tipType == Tip_Location) {
                description = [description stringByAppendingString:[NSString stringWithFormat:@" 地点:%@", tInfo.title]];
            }
        }
        
        for (TipInfo *tInfo in tagsArray) {
            if (tInfo.tipType == Tip_Normal) {
                description = [description stringByAppendingString:[NSString stringWithFormat:@" #%@", tInfo.title]];
            }
        }
    }
    
    
    NSString * name = [_openArray objectAtIndex:imageIndex-1];
        
    if ([name isEqualToString:@"QQ好友"]) {
        //QQ好友
        //跳转链接
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=QQ&uid=%@",_mInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:_mInfo.imgUrl]]];
        
        [[ShareModel getInstance] qqFriendsShareMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"QQ空间"]) {
        //QQ空间
        //分享跳转URL
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=Qzone&uid=%@",_mInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:_mInfo.imgUrl]]];
        
        [[ShareModel getInstance] qqZoneShareMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"微信好友"]) {
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=Weixin&uid=%@",_mInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:_mInfo.imgUrl]]];
        
        [[ShareModel getInstance] wechatFriendsMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"微信朋友圈"]) {
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=Weixin&uid=%@",_mInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:_mInfo.imgUrl]]];
        
        [[ShareModel getInstance] wechatCircleMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"删除"]) {
        //删除图片
        [self deleteImage];
    }
    
    if ([name isEqualToString:@"举报"]) {
        //举报
        [self reportImage];
    }
    
    if ([name isEqualToString:@"隐藏"]) {
        //隐藏图片
        [self hideImage];
    }

}


//隐藏图片
- (void)hideImage
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:_mInfo.imgId forKey:@"imgId"];
    [dic setObject:_mInfo.userId forKey:@"userId"];
    
    [_dao requestHideImage:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            //刷新
            [self performSelector:@selector(getTagWithImages) withObject:nil afterDelay:0.2];
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}

//删除图片
- (void)deleteImage
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:_mInfo.imgId forKey:@"imgId"];
    [dic setObject:_mInfo.userId forKey:@"userId"];
    
    [_dao requestDeleteImage:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            //刷新
            [self performSelector:@selector(getTagWithImages) withObject:nil afterDelay:0.2];
            MET_MIDDLE(@"删除成功");

        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
    
}

//举报图片
- (void)reportImage
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:_mInfo.imgId forKey:@"imgId"];
    [dic setObject:_mInfo.userId forKey:@"userId"];
    
    [_dao requestReportPic:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            //刷新
            MET_MIDDLE(@"举报成功");
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}

//评论列表
- (void)loadCommentListView:(NSString *)imageID imageReleasedID:(NSString *)userID;
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    CommentListViewController *dVC = [board instantiateViewControllerWithIdentifier:@"CommentListViewController"];
    dVC.hidesBottomBarWhenPushed = YES;
    dVC.imageID = imageID;
    dVC.userID = userID;
    
    //入口来源
    dVC.mType = OtherType;
    
    if (_hostVC) {
        [_hostVC.navigationController pushViewController:dVC animated:YES];
        return;
    }

    [self.navigationController pushViewController:dVC animated:YES];
}

/******************************************计算高度 *****************************************/
// 赋值
- (CGFloat)setCellWithCellInfo:(DynamicInfo *)d_Info
{
    CGFloat m_hight = 60 + MAINSCREEN.size.width;   //顶部高度跟图片高度
    
    /****************************************  图片描述    ***********************************************/
    if ([d_Info.imgDesc length] > 0) {
        //底部view距离图片的高度
        m_hight += [self calculateDesLabelheight:m_hight desLabel:d_Info.imgDesc];
    }
    
    /**************************************   赞过得用户列表   *******************************************/
    if(d_Info.praiseCount > 0)
    {
        m_hight += [self setPraise:d_Info.persInfo currentHeight:m_hight];
    }
    
    /**************************************   评论列表   *******************************************/
    if (d_Info.commentCount > 0) {
        m_hight +=  [self setComments:d_Info.comInfo imageAuthor:d_Info.userId currentHeight:m_hight commentsNum:d_Info.commentCount];
    }
    
    return m_hight+12+45+5+15 + 20;
    
}

// 计算DesLabl的高度
- (CGFloat)calculateDesLabelheight:(CGFloat)height desLabel:(NSString *)text
{
    
    MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
    praisLabel.numberOfLines = 0;
    praisLabel.font = [UIFont systemFontOfSize:14.0f];
    praisLabel.textAlignment = NSTextAlignmentLeft;
    praisLabel.emojiText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    praisLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    praisLabel.customEmojiPlistName = @"expression";
    
    CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_RIGHT*2];
    
    if (size.height > 0.0) {
        return size.height + 15.0;
    }
    
    return 0.0;
}

//设置赞
- (CGFloat)setPraise:(NSArray *)cArray currentHeight:(CGFloat)mHeight
{
    MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
    praisLabel.numberOfLines = 0;
    praisLabel.font = [UIFont systemFontOfSize:14.0f];
    praisLabel.textAlignment = NSTextAlignmentLeft;
    
    //排序（以时间降序排列）
    NSSortDescriptor *sorter  = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sorter count:1];
    //排列后的数组（时间从小到大排列）
    NSMutableArray *sortArray = [[NSMutableArray alloc] initWithArray:[cArray sortedArrayUsingDescriptors:sortDescriptors]];
    //倒序
    sortArray = (NSMutableArray *)[[sortArray reverseObjectEnumerator] allObjects];
    
    if ([sortArray count] > 9) {
        praisLabel.emojiText = [NSString stringWithFormat:@"共%lu人赞过", (unsigned long)sortArray.count];
    }
    else{
        NSMutableArray * nickArray = [[NSMutableArray alloc] init];
        for (PraiseInfo *pInfo in cArray) {
            [nickArray addObject:pInfo.nickName];
        }
        praisLabel.emojiText = [nickArray componentsJoinedByString:@"，"];
    }
    
    CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
    
    if (size.height > 0.0) {
        return size.height + 12.0;
    }
    
    return 0.0;
}

//设置评论
- (CGFloat)setComments:(NSArray *)cArray
           imageAuthor:(NSString *)authorID
         currentHeight:(CGFloat)mHeight
           commentsNum:(NSUInteger)mCount
{
    NSInteger i = 0;
    CGFloat tempHeight = 0.0;
    
    //查看更多评论
    for(CommentInfo *cInfo in cArray)
    {
        MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
        praisLabel.numberOfLines = 0;
        praisLabel.font = [UIFont systemFontOfSize:14.0f];
        praisLabel.textAlignment = NSTextAlignmentLeft;
        praisLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        praisLabel.customEmojiPlistName = @"expression";
        
        NSString *tempS = @"";
        
        if (!cInfo.parentCommentId || [cInfo.commentedUserId isEqualToString:cInfo.commentUserId]) {
            tempS = [NSString stringWithFormat:@"%@: %@", cInfo.commentUserNickname, cInfo.content];
            
            praisLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
            
            tempHeight += size.height+4;
        }
        else
        {
            MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
            praisLabel.numberOfLines = 0;
            praisLabel.font = [UIFont systemFontOfSize:14.0f];
            praisLabel.textAlignment = NSTextAlignmentLeft;
            praisLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
            praisLabel.customEmojiPlistName = @"expression";
            
            tempS = [NSString stringWithFormat:@"%@ 回复 %@: %@", cInfo.commentUserNickname, cInfo.commentedUserNickname, cInfo.content];
            
            praisLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
            
            tempHeight += size.height+4;
        }
        
        CLog(@"%@", tempS);
        i++;
    }
    
    if(mCount > 4)
    {
        MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
        praisLabel.numberOfLines = 0;
        praisLabel.font = [UIFont systemFontOfSize:14.0f];
        praisLabel.textAlignment = NSTextAlignmentLeft;
        
        praisLabel.emojiText = [NSString stringWithFormat:@"查看全部 %ld 条评论", (long)mCount];
        
        CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
        
        tempHeight += size.height;
    }
    
    
    if (tempHeight > 0.0) {
        return 15+ tempHeight;
    }
    
    return 0.0;
}



//解析数据
- (NSArray *)parisDataWithArray:(NSArray *)array
{
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSDictionary *item in array) {
        DynamicInfo *dInfo = [[DynamicInfo alloc] initWithParsData:item];
        [tempA addObject:dInfo];
    }
    
    return tempA;
}



//图片赞列表
- (void)imagePraisList:(NSString *)imageId
{
    UIStoryboard *mineStroyboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    UserListViewController *userListVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];
    
    userListVC.respondentUserId = [AccountInfo sharedAccountInfo].userId;
    userListVC.hidesBottomBarWhenPushed = YES;
    userListVC.userListType = PraiseList;
    userListVC.imageId = imageId;
    
    if (_hostVC) {
        [_hostVC.navigationController pushViewController:userListVC animated:YES];
        return;
    }
    
    [self.navigationController pushViewController:userListVC animated:YES];
}


@end
