//
//  OneselfViewController.m
//  Artery
//
//  Created by 刘敏 on 14-11-21.
//  Copyright (c) 2014年 刘 敏. All rights reserved.
//  自己的个人资料页面（入口有两个：1、Tabbar  2、动态或者消息模块进来的）

#import "OneselfViewController.h"
#import "FindFriendsViewController.h"
#import "PersonalProfileViewController.h"
#import "SettingViewController.h"
#import "MessageViewController.h"
#import "UserListViewController.h"
#import "FavoriteCreateViewController.h"
#import "FavoriteDetailViewController.h"
#import "UserRelationshipDAO.h"
#import "OneselfView.h"
#import "FavViewController.h"
#import "PersonalPicViewController.h"
#import "DynamicInfoViewController.h"


@interface OneselfViewController () <FavViewControllerDelegate, PersonalPicViewControllerDelegate>
{
    
    UIStoryboard *mineStroyboard;
    BOOL  isFirst;
    NSInteger indexBtn;
}


@property (nonatomic, strong) OneselfView *topView;
@property (nonatomic, strong) UserRelationshipDAO *userDao;


@property (nonatomic, strong) NSArray *userFavorites;       //收藏夹列表

@property (nonatomic, strong) FavViewController *favoriteListView;
@property (nonatomic, strong) PersonalPicViewController *picView;

@property (nonatomic, assign) CGFloat firstViewHight;      //我的美食日记View的高度
@property (nonatomic, assign) CGFloat secondViewHight;     //我的收藏View的高度

@end

@implementation OneselfViewController


- (void)initDao
{
    if (!self.userDao) {
        self.userDao = [[UserRelationshipDAO alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //第一次不获取
    if (isFirst)
    {
        //界面刷新
        [self refreshTopView];
        [self setNaviBarTitle:[AccountInfo sharedAccountInfo].nickname];
    }
    else{
        //第一次进来执行
        [self diaryBtnTapped:nil];
    }

    isFirst = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    mineStroyboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    _scrollView.backgroundColor = BACKGROUND_COLOR;

    //修正顶部坐标体系
    [UtilityFunc resetScrlView:_scrollView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self setNaviBarTitle:[AccountInfo sharedAccountInfo].nickname];

    if (_isFromTabbar) {
        [self setNaviBarLeftBtn:[DMNaviBarView createImgNaviBarBtnByImgNormal:@"add_icon.png" imgHighlight:nil imgSelected:nil target:self action:@selector(addButtonTouch:)]];
        [self addMessageButton];
        
        [self setNaviBarRightBtn:[DMNaviBarView createImgNaviBarBtnByImgNormal:@"icon_settings.png" imgHighlight:nil imgSelected:nil target:self action:@selector(settingButtonTouch:)]];
    }
    
    indexBtn = 0;
    
    //顶部个人资料
    _topView = [[OneselfView alloc] initWithFrame:CGRectMake(0, 0, 320, 215)];
    _topView.controller = self;
    [self.scrollView addSubview:_topView];
    
    [self.scrollView setContentSize:CGSizeMake(320, 800)];

    //界面刷新
    [self refreshTopView];
    
    
    //我的美食日记
    _picView = [mineStroyboard instantiateViewControllerWithIdentifier:@"PersonalPicViewController"];
    _picView.userID = [AccountInfo sharedAccountInfo].userId;
    _picView.view.frame = CGRectZero;
    _picView.view.translatesAutoresizingMaskIntoConstraints = NO;
    _picView.delegate = self;
    [_picView.view setBackgroundColor:BACKGROUND_COLOR];
    
    //收藏列表
    _favoriteListView = [mineStroyboard instantiateViewControllerWithIdentifier:@"FavViewController"];
    _favoriteListView.userID = [AccountInfo sharedAccountInfo].userId;
    _favoriteListView.view.frame = CGRectZero;
    _favoriteListView.view.translatesAutoresizingMaskIntoConstraints = NO;
    _favoriteListView.delegate = self;
    [_favoriteListView.view setBackgroundColor:BACKGROUND_COLOR];
    
    
//     _favoriteListViewHeight = [NSLayoutConstraint constraintWithItem:_favoriteListView.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:100];
//    [_favoriteListView.view addConstraint:_favoriteListViewHeight];
    
    
    
    
    
    
    
    
    
    
    
    
    //初始化DAO
    [self initDao];
    
    //获取用户信息
    [self requestUserInfo];
    
    //获取用户图片列表
//    [self getFavoriteList];
    
    //初始化菜单
    [self initMenuView];
    
    
}

//初始化菜单
- (void)initMenuView
{
    _diaryBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _topViewHight +15, 160, 35)];
    [_diaryBtn setTitle:@"我的美食日记" forState:UIControlStateNormal];
    [_diaryBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_diaryBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
    [_diaryBtn setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    [_diaryBtn setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    
    [_diaryBtn setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_normal.png"] forState:UIControlStateNormal];
    [_diaryBtn setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateHighlighted];
    [_diaryBtn setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateSelected];
    [_diaryBtn addTarget:self action:@selector(diaryBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    _diaryBtn.selected = YES;
    [self.scrollView addSubview:_diaryBtn];
    
    _collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, _topViewHight +15, 160, 35)];
    [_collectionBtn setTitle:@"收集我想吃的" forState:UIControlStateNormal];
    [_collectionBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
    [_collectionBtn setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    [_collectionBtn setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_normal.png"] forState:UIControlStateNormal];
    [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateHighlighted];
    [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateSelected];
    [_collectionBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_collectionBtn addTarget:self action:@selector(collectionBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    _collectionBtn.selected = NO;
    [self.scrollView addSubview:_collectionBtn];
}


//刷新
- (void)refreshMenuView
{
    [_diaryBtn setFrame:CGRectMake(0, _topViewHight +15, 160, 35)];
    [_collectionBtn setFrame:CGRectMake(160, _topViewHight +15, 160, 35)];
    [_midLineV setFrame:CGRectMake(155, _topViewHight +15, 10, 35)];
    
    [self refreshContentSizeOfScrollView];
    
    if (indexBtn == 0) {
        [_picView.view setFrame:CGRectMake(0, _topViewHight+51, 320, 100)];
    }
    else if (indexBtn == 1){
        [_favoriteListView.view setFrame:CGRectMake(0, _topViewHight+51, 320, 100)];
    }
    
}

#pragma mark - 导航栏按钮响应事件
//添加消息按钮
- (void)addMessageButton
{
    UIButton *msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    msgButton.frame = CGRectMake(224, 23, 60, 39);
    [msgButton setImage:[UIImage imageNamed:@"bell_icon.png"] forState:UIControlStateNormal];
    msgButton.backgroundColor = [UIColor clearColor];
    [msgButton addTarget:self action:@selector(msgButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.m_Navbar addSubview:msgButton];
}


//消息按钮
- (void)msgButtonTapped:(id)sender
{
    UIStoryboard *msgStroyboard = [UIStoryboard storyboardWithName:@"MessageStoryboard" bundle:nil];
    
    MessageViewController *msgVC = [msgStroyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    msgVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:msgVC animated:YES];
}

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


#pragma mark - 常规按钮响应事件
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

    userListVC.respondentUserId = [AccountInfo sharedAccountInfo].userId;
    userListVC.hidesBottomBarWhenPushed = YES;
    userListVC.userListType = FansList;
    [self.navigationController pushViewController:userListVC animated:YES];
}

//打开关注列表
- (void)openAttentionList
{
    UserListViewController *userListVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];

    userListVC.respondentUserId = [AccountInfo sharedAccountInfo].userId;
    userListVC.hidesBottomBarWhenPushed = YES;
    userListVC.userListType = FollowList;
    [self.navigationController pushViewController:userListVC animated:YES];
}



#pragma mark - 菜单按钮响应事件
//我的美食日记
- (void)diaryBtnTapped:(id)sender
{
    _collectionBtn.selected = NO;
    _diaryBtn.selected = YES;
    
    indexBtn = 0;
    [_favoriteListView.view removeFromSuperview];
    [self.scrollView addSubview:_picView.view];
    [_picView.view setFrame:CGRectZero];
    
    [self refreshContentSizeOfScrollView];
}

//收藏列表
- (void)collectionBtnTapped:(id)sender
{
    _collectionBtn.selected = YES;
    _diaryBtn.selected = NO;
    
    [_picView.view removeFromSuperview];
    indexBtn = 1;
    [self.scrollView addSubview:_favoriteListView.view];
    [_favoriteListView.view setFrame:CGRectZero];
    
    [self refreshContentSizeOfScrollView];
}

#pragma mark 网络请求
// 获取用户信息
- (void)requestUserInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];

    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dict setObject:@"true" forKey:@"statistics"];
    
    [_userDao requestUserInfo:dict
              completionBlock:^(NSDictionary *result) {
                  if ([[result objectForKey:@"code"] integerValue] == 200) {
                      //更新账户信息
                      [[AccountInfo sharedAccountInfo] parsAccountData:[result objectForKey:@"obj"]];
                      
                      //界面刷新
                      [self refreshTopView];
                  }
                  else
                  {
                      MET_MIDDLE([result objectForKey:@"msg"])
                      //界面刷新
                      [self refreshTopView];
                  }
              }
               setFailedBlock:^(NSDictionary *result) {
                   //界面刷新
                   [self refreshTopView];
               }];
}


#pragma mark 更新界面高度
- (void)changeInterfaceHeight
{
    [self.topView setFrame:CGRectMake(0, 0, 320, _topViewHight)];
    
    [self performSelector:@selector(refreshMenuView) withObject:nil afterDelay:0.1];
}

#pragma mark  FavViewControllerDelegate
- (void)jumpFavoriteCreateView
{
    FavoriteCreateViewController *favoriteCreateVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"FavoriteCreateViewController"];
    favoriteCreateVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:favoriteCreateVC animated:YES];
}


// 进入收藏夹详情
- (void)jumpFavoriteDetailView:(FavInfo *)fInfo
{
    FavoriteDetailViewController *favoriteDetailVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"FavoriteDetailViewController"];
    favoriteDetailVC.hidesBottomBarWhenPushed = YES;
    favoriteDetailVC.fInfo = fInfo;
    [self.navigationController pushViewController:favoriteDetailVC animated:YES];
}


//收集我想吃的view的高度
- (void)updateFatherViewHight:(CGFloat)mhight
{
    CLog(@"%02f", mhight);
    _secondViewHight = mhight;
    
//    _favoriteListViewHeight.constant = mhight;
    
    [self refreshContentSizeOfScrollView];
}


#pragma mark  PersonalPicViewControllerDelegate
- (void)jumpImageDetails:(DynamicInfo *)dInfo
{
    UIStoryboard *dynaBoard = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    DynamicInfoViewController *dyInfoVC = [dynaBoard instantiateViewControllerWithIdentifier:@"DynamicInfoViewController"];
    dyInfoVC.dyInfo = dInfo;
    dyInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dyInfoVC animated:YES];
}


//我的美食日记View的高度
- (void)calculatePersonalPicViewHight:(CGFloat)mhight
{
    _firstViewHight = mhight;
    [self refreshContentSizeOfScrollView];
}

//刷新个人资料
- (void)refreshTopView
{
    [_topView refreshOneselfView];
    [self refreshContentSizeOfScrollView];
}


//重新计算scrollView的ContentSize
- (void)refreshContentSizeOfScrollView
{
    if (indexBtn == 0) {
        [self.scrollView setContentSize:CGSizeMake(320, _topViewHight+_firstViewHight+50 +1)];
    }
    else if (indexBtn == 1)
    {
        [self.scrollView setContentSize:CGSizeMake(320, _topViewHight+_secondViewHight+50+1)];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
