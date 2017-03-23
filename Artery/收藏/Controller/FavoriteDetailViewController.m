//
//  FavoriteDetailViewController.m
//  Shitan
//
//  Created by Jia HongCHI on 14-10-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FavoriteDetailViewController.h"
#import "CollectionDAO.h"
#import "TipsTableViewCell.h"
#import "TipsTableViewModel.h"
#import "ProfileTableViewController.h"
#import "HimselfViewController.h"
#import "FavTitleViewController.h"
#import "FavDescribeViewController.h"
#import "MJRefresh.h"
#import "TipsDetailsViewController.h"


@interface FavoriteDetailViewController ()<FavTitleViewControllerDelegate, FavDescribeViewControllerDelegate>
{
    UIStoryboard        *board;
}

@property (nonatomic, strong) CollectionDAO *dao;


@end

@implementation FavoriteDetailViewController


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
    [self getImagesList];
}

// 下拉获取更多
- (void)footerRereshing
{
    self.isMore = YES;
    [self getImagesList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"收藏夹"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"收藏夹"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDao];
    
    _favoriteTitleLabel.text = _fInfo.title;
    _favoriteDescLabel.text = _fInfo.favoriteDesc;
    
    board = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    
    [self setNavBarTitle:_fInfo.title];
    
    
    [ResetFrame resetScrollView:_tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    //判断是不是自己（自己才会有删除按钮、标题跟简介）
    if(_isMyself)
    {
        //删除按钮
        [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"删除" target:self action:@selector(deleteButtonTapped:)]];
        _topviewHight.constant = MAINSCREEN.size.width;
    }
    else{
        [_topView setFrame:CGRectZero];
        [_topView removeFromSuperview];
    }
    
    _tableView.backgroundColor = BACKGROUND_COLOR;
    
    [self getImagesList];
    
    [self setExtraCellLineHidden:self.tableView];
    
    // 集成刷新控件
    [self setupRefresh];
}

//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - request
- (void)initDao
{
    if (!self.dao) {
        self.dao = [[CollectionDAO alloc] init];
    }
    _tableArray = [[NSMutableArray alloc] init];
}


//增加提示语句
- (void)addPromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (!titLabel) {
        titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, MAINSCREEN.size.width, 30)];
        titLabel.textAlignment = NSTextAlignmentCenter;
        titLabel.tag = 0x128;
    }
    
    titLabel.text = @"无收藏图片";
    [titLabel setFont:[UIFont systemFontOfSize:18.0]];
    [titLabel setTextColor:[UIColor lightGrayColor]];
    [self.tableView addSubview:titLabel];
}

//删除提示语句
- (void)removePromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (titLabel) {
        [titLabel removeFromSuperview];
    }
}




//获取收藏夹图片
- (void)getImagesList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dict setObject:_fInfo.favoriteId forKey:@"favoriteId"];
    [dict setObject:@"20" forKey:@"size"];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    //该页最大的ID
    if (self.isMore) {
        [dict setObject:[NSNumber numberWithInteger:self.topId] forKey:@"topId"];
    }
    
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    
    [_dao requestFavoriteImgs:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] intValue] == 200) {
            if ([result objectForKey:@"obj"]) {
                
                NSArray *temp = [result objectForKey:@"obj"];
                
                
                if (!self.isMore) {
                    [self.tableArray removeAllObjects];
                    [self.tableView.header endRefreshing];
                }
                else{
                    [self.tableView.footer endRefreshing];
                }
                
                if ([temp isKindOfClass:[NSArray class]] && [temp count] > 0) {
                    self.topId = [[[temp objectAtIndex:[temp count]-1] objectForKey:@"id"]integerValue] - 1;
                    [self.tableArray addObjectsFromArray:temp];
                    
                    [self removePromptView];
                    
                }
                else{
                    if ([self.tableArray count] == 0) {
                        [self addPromptView];
                    }
                    
                }
                
                //重载
                [self.tableView reloadData];
            }
        }
        else
        {
            if (!self.isMore) {
                [self.tableView.header endRefreshing];
            }
            else{
                [self.tableView.footer endRefreshing];
            }
        }
    }
               setFailedBlock:^(NSDictionary *result) {
                   if (!self.isMore) {
                       [self.tableView.header endRefreshing];
                   }
                   else{
                       [self.tableView.footer endRefreshing];
                   }
                   
               }];
}

//删除收藏夹
- (void)deleteFavorites{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_fInfo.favoriteId forKey:@"favoriteId"];
    
    [_dao deleteFavorite:dict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] intValue] == 200) {
            MET_MIDDLE(@"删除成功");
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
    
}



// 计算DesLabl的高度
- (CGFloat)calculateDesLabelheight:(NSString *)text
{
    UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:14.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(MAINSCREEN.size.width-24, 2000);
    
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size.height;
}


- (void)deleteButtonTapped:(id)sender
{
    AlertWithTitleAndMessageAndUnits(nil, @"是否要继续删除该收藏夹", self, @"确定", nil);
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
    return [_tableArray count];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicInfo *dInfo = [[DynamicInfo alloc] initWithParsData:[self.tableArray objectAtIndex:indexPath.row]];
    
    if ([dInfo.imgDesc length] > 0) {
        return [self calculateDesLabelheight:dInfo.imgDesc] +32 + MAINSCREEN.size.width + 70;
    }
    
    return MAINSCREEN.size.width + 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TipsTableViewCell *cell = [TipsTableViewModel findCellWithTableView:tableView];
    
    cell.favController = self;
    DynamicInfo *dInfo = [[DynamicInfo alloc] initWithParsData:[_tableArray objectAtIndex:indexPath.row]];
    
    if (dInfo) {
        [cell setCellWithCellInfo:dInfo isShowfocusButton:_isShowfocus];
    }
    
    return cell;
}


//标签点击
- (void)clickBubbleViewWithInfo:(BubbleView *)bubleV shopWithInfo:(ShopInfo *)sInfo
{
    UIStoryboard *mboard = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    TipsDetailsViewController *tVC = [mboard instantiateViewControllerWithIdentifier:@"TipsDetailsViewController"];
    tVC.bubbleV = bubleV;
    
    if (bubleV.tipType == Tip_Location) {
        tVC.isShowPlace = YES;
    }
    
    //收藏夹图片点击
    tVC.m_Type = FistTypeTips;
    
    tVC.shopInfo = sInfo;
    tVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tVC animated:YES];
}



//点击
- (void)imgaeHeadTapped:(DynamicInfo *)dInfo
{
    //自己就跳转到
    if ([dInfo.userId isEqualToString:[AccountInfo sharedAccountInfo].userId]) {
        ProfileTableViewController *hVC = [[ProfileTableViewController alloc] init];
        hVC.isFromTabbar = NO;
        hVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hVC animated:YES];
        
    }
    else{
        
        UIStoryboard *MineStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
        HimselfViewController *hVC = [MineStoryboard instantiateViewControllerWithIdentifier:@"HimselfViewController"];
        hVC.respondentUserId = dInfo.userId;
        hVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hVC animated:YES];
    }
}


//更新文件夹标题
- (IBAction)updateTitle:(id)sender
{
    FavTitleViewController *hVC = [board instantiateViewControllerWithIdentifier:@"FavTitleViewController"];
    hVC.favInfo = _fInfo;
    hVC.delegate = self;
    hVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hVC animated:YES];
}


//更新文件夹简介
- (IBAction)updateDescribe:(id)sender
{
    FavDescribeViewController *hVC = [board instantiateViewControllerWithIdentifier:@"FavDescribeViewController"];
    hVC.favInfo = _fInfo;     //描述
    hVC.delegate = self;
    hVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hVC animated:YES];
}


#pragma mark  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            CLog(@"取消");
            break;
            
        case 1:
            //删除收藏夹
            [self deleteFavorites];
            break;
            
        default:
            
            break;
    }
}


#pragma mark FavTitleViewControllerDelegate
- (void)updateFavTitle:(NSString *)title
{
    self.fInfo.title = title;
    
    [self.favoriteTitleLabel setText:title];
}

#pragma mark FavDescribeViewControllerDelegate
- (void)updateFavDescribe:(NSString *)describe
{
    self.fInfo.favoriteDesc = describe;
    
    [self.favoriteDescLabel setText:describe];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
