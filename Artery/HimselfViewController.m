//
//  HimselfViewController.m
//  Shitan
//
//  Created by 刘敏 on 14/12/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "HimselfViewController.h"
#import "ImageDAO.h"
#import "FindFriendsViewController.h"
#import "SettingViewController.h"
#import "CollectionDAO.h"
#import "FavCollectionCell.h"
#import "NewFavCollectionCell.h"
#import "FavoriteDetailViewController.h"
#import "FavoriteCreateViewController.h"
#import "PersonalProfileViewController.h"
#import "UserListViewController.h"
#import "HimselfView.h"
#import "UserRelationshipDAO.h"
#import "PicListTableViewCell.h"
#import "PicListTableModel.h"
#import "TipsDetailsViewController.h"
#import "DynamicInfo.h"
#import "MJRefresh.h"

#import "HostViewController.h"


@interface HimselfViewController ()<PicListTableViewCellDelegate>
{
    UIStoryboard *mineStroyboard;
    NSInteger indexBtn;
}

@property (nonatomic, strong) HimselfView* topView;

@property (nonatomic, strong) ImageDAO *imageDao;
@property (nonatomic, strong) CollectionDAO *favoriteDao;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) NSArray *favArray;

//图片日期数据
@property (nonatomic, strong) NSMutableArray *dateArray;

//图片列表数据
@property (nonatomic, strong) NSMutableArray *imageList;

@end

@implementation HimselfViewController


- (void)viewWillAppear:(BOOL)animated
{
    if(indexBtn == 0)
    {
        if ([UIDevice isRunningOniPhone4]) {
            [self performSelector:@selector(calculatePicViewHeight) withObject:nil afterDelay:0.2];
        }
        else{
            [self updatePicView];
        }
    }
    else if(indexBtn == 1){
        if ([UIDevice isRunningOniPhone4]) {
            [self performSelector:@selector(calculateFavViewHeight) withObject:nil afterDelay:0.2];
        }
        else{
            [self updateFavView];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始为第一个按钮
    indexBtn = 0;
    
    _foodMenuWidth.constant = _favMenuWidth.constant = MAINSCREEN.size.width/2;
    
    [self initDao];
    
    mineStroyboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    
    //修正顶部坐标体系
    [ResetFrame resetScrollView:_scrollView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    _scrollView.backgroundColor = BACKGROUND_COLOR;
    
    
    [self registerCell];
    
    _picTableView.hidden = YES;
    
    //顶部个人资料
    _topView = [[HimselfView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 215)];
    _topView.userInteractionEnabled = YES;
    _topView.controller = self;
    [self.scrollView addSubview:_topView];
    
    
    // UITableView的宽度
    _picListViewWidth.constant = MAINSCREEN.size.width - 20;
    //    self.scrollView.contentSize = CGSizeMake(MAINSCREEN.size.width, MAINSCREEN.size.height-43.5);
    
    NSLayoutConstraint *topViewVerticalSpace =  [NSLayoutConstraint constraintWithItem:_btnView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    [self.scrollView  addConstraint:topViewVerticalSpace];
    
    
    //获取用户信息
    [self requestUserInfo];
    
    //获取用户的发布时间
    [self getHimselfPublishTimes];
    
    [self refreshTopView];
    
    // 集成刷新控件
    [self setupRefresh];
    
}

//刷新个人资料
- (void)refreshTopView
{
    [_topView refreshOneselfView];
}


#pragma mark - 初始化
- (void)initDao
{
    if (!_imageDao) {
        _imageDao = [[ImageDAO alloc] init];
    }
    
    if (!self.favoriteDao) {
        self.favoriteDao = [[CollectionDAO alloc] init];
    }
    
    if (!self.userDao)
    {
        self.userDao = [[UserRelationshipDAO alloc] init];
    }
    
    _dateArray = [[NSMutableArray alloc] init];
    _imageList = [[NSMutableArray alloc] init];
}

//注册CollectionViewCell
- (void)registerCell{
    
    //注册收藏Cell
    [_favCollectionView registerClass:[FavCollectionCell class] forCellWithReuseIdentifier:@"FavCollectionCell"];
    
    //注册新建收藏Cell
    [_favCollectionView registerClass:[NewFavCollectionCell class] forCellWithReuseIdentifier:@"NewFavCollectionCell"];
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
}



#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    CLog(@"下拉刷新");
    
    //获取用户信息
    [self requestUserInfo];
}


- (void)updatePicView
{
    [self performSelector:@selector(calculatePicViewHeight) withObject:nil afterDelay:0.0];
}

//更新收藏夹
- (void)updateFavView
{
    [self performSelector:@selector(calculateFavViewHeight) withObject:nil afterDelay:0.0];
}




#pragma mark 网络请求
// 获取用户信息
- (void)requestUserInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dict setObject:_respondentUserId forKey:@"followedUserId"];
    [dict setObject:@"true" forKey:@"statistics"];
    
    [_userDao requestUserInfo:dict
              completionBlock:^(NSDictionary *result) {
                  if ([[result objectForKey:@"code"] integerValue] == 200) {
                      
                      _perInfo = [[PersonalInfo alloc] initWithParsData:[result objectForKey:@"obj"]];
                      
                      _topView.hasFollow = _perInfo.hasFollow;
                      
                      //界面刷新
                      [self refreshTopView];
                      
                      [self setNavBarTitle:_perInfo.nickname];
                      
                      [self.scrollView.header endRefreshing];
                  }
                  else
                  {
                      MET_MIDDLE([result objectForKey:@"msg"]);
                      //界面刷新
                      [self refreshTopView];
                  }
              }
               setFailedBlock:^(NSDictionary *result) {
                   //界面刷新
                   [self refreshTopView];
               }];
}


//获取发布图片的日期
- (void)getHimselfPublishTimes
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_respondentUserId forKey:@"userId"];
    
    [_imageDao requestPublishTimes:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            if ([result objectForKey:@"obj"] && [[result objectForKey:@"obj"] count] > 0) {
                
                _dateArray = [[NSMutableArray alloc] initWithArray:[result objectForKey:@"obj"]];
                
                [self getUserImgs];
                
                [self removePromptView];
            }
            else{
                [self addPromptView];
            }
        }
        else
        {
            [self addPromptView];
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
        MET_MIDDLE([result objectForKey:@"msg"]);
        
    }];
}

- (void)getUserImgs
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:_respondentUserId forKey:@"userId"];
    
    NSString *dateS = [_dateArray componentsJoinedByString:@","];
    [dic setObject:dateS forKey:@"dates"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_imageDao requestFoodDiary:requestDict completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            if ([result objectForKey:@"obj"]) {
                
                [self.imageList addObjectsFromArray:[result objectForKey:@"obj"]];
                
                [_picTableView reloadData];
                
                _picTableView.hidden = NO;
                
                if ([UIDevice isRunningOniPhone4]) {
                    [self performSelector:@selector(calculatePicViewHeight) withObject:nil afterDelay:0.2];
                }
                else{
                    [self updatePicView];
                }
            }
        }
        else
        {
            CLog(@"%@", [result objectForKey:@"msg"]);
            //            MET_MIDDLE([result objectForKey:@"msg"])
            [self addPromptView];
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}



//获取用户收藏夹列表
- (void)getFavoriteList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_respondentUserId forKey:@"userId"];
    [_favoriteDao userFavorite2:dict completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            if ([result objectForKey:@"obj"]) {
                _favArray = [result objectForKey:@"obj"];
                [self updateFavView];
                [_favCollectionView reloadData];
                
            }
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLog(@"%ld", (long)indexPath.section);
    
    NSDictionary *imgDic = [_imageList objectAtIndex:indexPath.section];
    NSInteger count = [[imgDic objectForKey:@"count"] integerValue];
    NSInteger i = count/3;
    NSInteger j = count%3;
    
    CGFloat imageWidth = (MAINSCREEN.size.width-50.0)/3.0;
    
    if (j > 0) {
        j = 1;
    }
    
    CGFloat m_cellHight = 10.0 + ((i+j)*imageWidth + (i+j-1)*5.0) + 10.0;
    
    return m_cellHight;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 40)];
    [headerView setBackgroundColor:MINE_FAVORITE_BACKGROUND_COLOR];
    UILabel *headerLab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    headerLab1.textColor = MAIN_TIME_COLOR;
    headerLab1.font = [UIFont systemFontOfSize:14.0f];
    
    UILabel *headerLab2 = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width-50, 10, 100, 30)];
    headerLab2.textColor = MAIN_TIME_COLOR;
    headerLab2.font = [UIFont systemFontOfSize:14.0f];
    
    NSDictionary *imgDic = [_imageList objectAtIndex:section];
    if (imgDic) {
        CLog(@"%@", imgDic);
        headerLab1.text = [NSString stringWithFormat:@"%@", [imgDic objectForKey:@"date"]];
        headerLab2.text = [NSString stringWithFormat:@"%@张", [imgDic objectForKey:@"count"]];
        [headerView addSubview:headerLab1];
        [headerView addSubview:headerLab2];
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
    NSDictionary *imgDic = [_imageList objectAtIndex:indexPath.section];
    NSArray *imgArray = [imgDic objectForKey:@"imgs"];
    [cell initWithParsData:imgArray intWithSection:indexPath.section];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - collectionView data source
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_favArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat m_unit = (MAINSCREEN.size.width-36)/2;
    CGFloat m_Width = m_unit  + (m_unit - 16)/3.0 + 36;
    
    return CGSizeMake(m_unit, m_Width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    
    static NSString *favoriteCellIdentifier = @"FavCollectionCell";
    
    FavCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:favoriteCellIdentifier forIndexPath:indexPath];
    
    FavInfo *fInfo = [[FavInfo alloc] initWithParsData:[_favArray objectAtIndex:row]];
    [cell initWithParsData:fInfo];
    
    return cell;
}


#pragma mark - collectionView delegete
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FavoriteDetailViewController *favoriteDetailVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"FavoriteDetailViewController"];
    favoriteDetailVC.hidesBottomBarWhenPushed = YES;
    favoriteDetailVC.fInfo = [[FavInfo alloc] initWithParsData:[_favArray objectAtIndex:indexPath.row]];
    favoriteDetailVC.isMyself = NO;      //不是自己
    
    [self.navigationController pushViewController:favoriteDetailVC animated:YES];
    
    
}

#pragma mark - 导航栏按钮响应事件
//点击左上角添加关注好友按钮
- (void)addButtonTouch:(id)sender{
    FindFriendsViewController *findFriendsVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"FindFriendsViewController"];
    findFriendsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:findFriendsVC animated:YES];
}


//设置按钮
- (void)settingButtonTouch:(id)sender
{
    SettingViewController *setVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}


#pragma mark 中间按钮切换
//点击查图片列表
- (IBAction)picListButonTouch:(id)sender {
    
    [self showPromptView];
    
    _favoriteListButton.selected = NO;
    _picListButton.selected = YES;
    indexBtn = 0;
    if (_dateArray.count > 0) {
        _picTableView.hidden = NO;
    }else{
        _picTableView.hidden = YES;
    }
    _favCollectionView.hidden = YES;
    
    //整个ScrollView的滑动高度
    [self updatePicView];
}

// 点击查看收藏
- (IBAction)favoriteListButtonTouch:(id)sender {
    
    [self hidePromptView];
    
    _favoriteListButton.selected = YES;
    _picListButton.selected = NO;
    indexBtn = 1;
    _picTableView.hidden = YES;
    _favCollectionView.hidden = NO;
    
    if (!_isFirst) {
        [self getFavoriteList];
    }
    else
    {
        //整个ScrollView的滑动高度
        [self updateFavView];
    }
    
}


// 计算我的美食日记的表格高度
- (void)calculatePicViewHeight
{
    CGFloat totalHight = 0.0;
    CGFloat imageWidth = (MAINSCREEN.size.width-50.0)/3.0;
    
    for (NSDictionary *item in _imageList) {
        NSInteger count = [[item objectForKey:@"count"] integerValue];
        NSInteger i = count/3;      //商
        NSInteger j = count%3;      //模
        
        if (j > 0) {
            j = 1;
        }
        
        //表格头40
        //顶部12
        //每一行高度imageWidth,间距为5
        //footer10
        
        CGFloat m_cellHight = 70.0 + ((i+j)*imageWidth + (i+j-1)*5.0);
        
        totalHight += m_cellHight;
    }
    
    //表格的高度
    _picListViewHeight.constant = totalHight;
    _displayViewHight.constant = _picListViewHeight.constant + 12.0;
    
    CLog(@"%02f", MAINSCREEN.size.height);
    //整个ScrollView的滑动高度
    if (_displayIntervalTopHight.constant+ _displayViewHight.constant < MAINSCREEN.size.height-44) {
        
        CGFloat tempHight = MAINSCREEN.size.height - _displayIntervalTopHight.constant-43.5;
        
        if(_displayViewHight.constant < tempHight)
        {
            _displayViewHight.constant = tempHight;
        }
    }
    
    //整个ScrollView的滑动高度
    self.scrollView.contentSize = CGSizeMake(MAINSCREEN.size.width, _displayIntervalTopHight.constant+ _displayViewHight.constant);
    
}


//计算收藏夹的高度（CollectionView）
- (void)calculateFavViewHeight{
    
    CGFloat m_unit = (MAINSCREEN.size.width-36)/2;
    CGFloat m_Width = m_unit  + (m_unit - 16)/3.0 + 36;
    CGFloat fad = ([_favArray count]/2 + [_favArray count]%2) * (m_Width+12);
    
    _favoriteListViewHeight.constant = fad;
    //底部显示区域的高度
    _displayViewHight.constant = fad + 12;
    
    if (isIOS8){
        //整个ScrollView的滑动高度
        if (_displayIntervalTopHight.constant+ _displayViewHight.constant < MAINSCREEN.size.height-44) {
            _displayViewHight.constant = MAINSCREEN.size.height - _displayIntervalTopHight.constant-43.5;
        }
    }
    else
    {
        
        CLog(@"%02f", _displayIntervalTopHight.constant+ _displayViewHight.constant);
        //整个ScrollView的滑动高度
        if (_displayIntervalTopHight.constant+ _displayViewHight.constant < MAINSCREEN.size.height-44) {
            _displayViewHight.constant = MAINSCREEN.size.height - _displayIntervalTopHight.constant;
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(MAINSCREEN.size.width, _displayIntervalTopHight.constant+ _displayViewHight.constant);
    
}


//编辑个人资料
- (void)editorButonTouch
{
    //编辑个人资料
    PersonalProfileViewController *perProVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"PersonalProfileViewController"];
    perProVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:perProVC animated:YES];
}

//打开粉丝列表
- (void)openFansList
{
    UserListViewController *userListVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];
    
    userListVC.respondentUserId = _respondentUserId;
    userListVC.hidesBottomBarWhenPushed = YES;
    userListVC.userListType = FansList;
    [self.navigationController pushViewController:userListVC animated:YES];
}

//打开关注列表
- (void)openAttentionList{
    UserListViewController *userListVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];
    
    userListVC.respondentUserId = _respondentUserId;
    userListVC.hidesBottomBarWhenPushed = YES;
    userListVC.userListType = FollowList;
    [self.navigationController pushViewController:userListVC animated:YES];
}


#pragma mark 更新界面高度
- (void)changeInterfaceHeight:(CGFloat )topViewHight
{
    [self.topView setFrame:CGRectMake(0, 0, MAINSCREEN.size.width, topViewHight)];
    
    //中间菜单距离顶部高度
    _topViewHight.constant = topViewHight +10;
    //计算底部显示区域跟顶部之间的距离
    _displayIntervalTopHight.constant = _topViewHight.constant + 40;
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


#pragma mark 增加提示语句
- (void)addPromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x1024];
    if (!titLabel) {
        titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, MAINSCREEN.size.width, 30)];
        titLabel.textAlignment = NSTextAlignmentCenter;
        titLabel.tag = 0x1024;
    }
    
    titLabel.text = @"无美食图片";
    [titLabel setFont:[UIFont systemFontOfSize:18.0]];
    [titLabel setTextColor:[UIColor lightGrayColor]];
    [_displayView addSubview:titLabel];
}

//删除提示语句
- (void)removePromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x1024];
    if (titLabel) {
        [titLabel removeFromSuperview];
    }
}

- (void)hidePromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x1024];
    if (titLabel) {
        [titLabel setHidden:YES];
    }
}

- (void)showPromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x1024];
    if (titLabel) {
        [titLabel setHidden:NO];
    }
}

@end
