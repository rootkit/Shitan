//
//  SpecialViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/4/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "SpecialViewController.h"
#import "ColumnDAO.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MLEmojiLabel.h"
#import "STWebViewController.h"
#import "DynamicInfo.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "SGActionView.h"
#import "ShareModel.h"
#import "PhotoViewController.h"
#import "TipsDetailsViewController.h"
#import "DynamicTableViewCell.h"
#import "DynamicCellModel.h"
#import "MJRefresh.h"
#import "TopSpecialCell.h"
#import "TopSpecialModel.h"
#import "SmallImageCell.h"
#import "SmallImageModel.h"
#import "CommentListViewController.h"
#import "ProfileTableViewController.h"
#import "HimselfViewController.h"
#import "CollectionTypeViewController.h"
#import "UserListViewController.h"

#define  OFFSET_X_LEFT      30      //评论或者赞（文字距离左侧的距离）
#define  OFFSET_X_RIGHT     12


#define BROWER_HEIGHT 65.0f
#define COVER_HEIGHT 49.0f
#define STATUSBAR_HEIGHT 20.0f

#define INSPECT_ALL_ARTICLE @"inspect_all_article"


/**
 专题枚举
 */
typedef enum _ShowType
{
    STHotType = 0,                  //热门
    STNewType = 1                   //最新
}STShowType;


@interface SpecialViewController () <MLEmojiLabelDelegate, TTTAttributedLabelDelegate, UITableViewDataSource, UITableViewDelegate, SmallImageCellDelegate>

@property (nonatomic, strong) ColumnDAO *dao;
@property (nonatomic, strong) UIView *menuV;        //菜单

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *setBtn;

@property (nonatomic, assign) STShowType mType;
@property (nonatomic, assign) NSUInteger mPage;

@property (nonatomic, assign) BOOL isBig;
@property (nonatomic, assign) BOOL isMore;

@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, strong) NSMutableArray *hotArray;

@property (nonatomic, assign) NSInteger HEADER_HIGH;

//分享
@property (nonatomic, strong) NSArray *openArray;
@property (nonatomic, strong) NSArray *openImageArray;

@property (nonatomic, strong) DynamicInfo *mInfo;

@property (strong, nonatomic) ImageDAO *mDao;


@end

@implementation SpecialViewController


- (void)initDAO
{
    if (!_dao)
    {
        _dao = [[ColumnDAO alloc] init];
    }
    
    
    if (!_mDao) {
        _mDao = [[ImageDAO alloc] init];
    }
    _newsArray = [[NSMutableArray alloc] init];
    _hotArray = [[NSMutableArray alloc] init];
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
    
    NSArray *array  = [_coreDataMange selectCoreData];
    
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (DynamicModelFrame *item in array) {
        [tempA addObject:item.dInfo];
    }
    
    
    if (_mType == STHotType) {
        //先清空
        [self.hotArray removeAllObjects];
        [self.hotArray addObjectsFromArray:tempA];
    }
    else{
        //先清空
        [self.newsArray removeAllObjects];
        [self.newsArray addObjectsFromArray:tempA];
    }
    
    [self.tableView reloadData];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDAO];
    
    [self setNavBarTitle:_bInfo.title];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateComments:)
                                                 name:@"SPECIAL_COMMENTS_UPDATE"
                                               object:nil];
    
    //图片发布完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(picturesReleasedComplete) name:@"SP_PICTURESRELEASEDCOMPLETE" object:nil];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(get_more) forControlEvents:UIControlEventTouchUpInside];
    [self setNavBarRightBtn:rightBtn];

    
    [self addBottomView];
    
    _coreDataMange = [[CoreDataManage alloc] init];
    
    //精选
    _coreDataMange.tableTag = 3;
    
    
    _isMore = YES;
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    //默认最热
    _mType = STHotType;
    _mPage = 1;
    
    [self setupRefresh];
}


- (void)addBottomView
{
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationController.view.frame.size.height - COVER_HEIGHT, MAINSCREEN.size.width,COVER_HEIGHT)];
    coverView = coverView;
    coverView.backgroundColor = BACKGROUND_COLOR;
    coverView.alpha = 0.95;
    [self.view addSubview:coverView];
    
    UIButton *poButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [poButton setBackgroundImage:@"btn38_red.png" setSelectedBackgroundImage:@"btn38_grey.png"];
    [poButton setTitle:@"我也要PO图" forState:UIControlStateNormal];
    
    poButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    
    CGFloat mH = self.navigationController.view.frame.size.height - COVER_HEIGHT + 6.5;
    
    poButton.frame = CGRectMake((MAINSCREEN.size.width - 150)/2, mH, 150, 36);
    poButton.layer.cornerRadius = 3;
    poButton.layer.masksToBounds = YES;
    [poButton addTarget:self action:@selector(poPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:poButton];
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    [self.tableView.header beginRefreshing];
}


#pragma mark - 下拉刷新更新数据
- (void)headerRereshing{
    _mPage = 1;
    _isMore = YES;
    if (_mType == STHotType) {
        [_hotArray removeAllObjects];
    }
    else if(_mType == STNewType)
    {
        [_newsArray removeAllObjects];
    }
    //获取人气最高的第一页
    [self getPOSpecialImgs:_mType pageOfNO:_mPage];
}



#pragma mark - 上拉刷新更多数据
- (void)footerRereshing{
    if (_isMore) {
        [self getPOSpecialImgs:_mType pageOfNO:_mPage];
    }
    else
        [self.tableView.footer endRefreshing];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else{
        if (_isBig) {
            if (_mType == STHotType) {
                return _hotArray.count;
            }
            else
                return _newsArray.count;
        }
        else
            return 1;
        
    }
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TopSpecialCell *tCell = [TopSpecialModel findCellWithTableView:tableView];
        return [tCell setTopSpecialCellWithCellInfo:_bInfo];
        CLog(@"%@",self.bInfo);
        
    }
    else if(indexPath.section == 1)
    {
        if (_isBig) {
            
            DynamicInfo *dInfo = nil;
            if (_mType == STHotType) {
                dInfo = _hotArray[indexPath.row];
            }
            else
                dInfo = _newsArray[indexPath.row];
            
            return [self calculateCellHighWithCellInfo:dInfo];
        }
        else{
            NSArray *temp = nil;
            if (_mType == STHotType) {
                temp = _hotArray;
            }
            else
                temp = _newsArray;
            
            return [self calculationSmallPictureHigh:temp];
        }
    }
    
    return 200;
}


//计算小图模式的行高
- (CGFloat)calculationSmallPictureHigh:(NSArray *)array
{
    //计算高度
    NSUInteger mx = array.count/3;  //商
    NSUInteger my = array.count%3;  //余数
    
    
    if(my != 0)
    {
        mx++;
    }
    //单个图片宽度
    CGFloat singleW = (MAINSCREEN.size.width - 10 * 4 ) / 3 + 10;
    return singleW*mx +10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else
        return 40;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [_menuV removeFromSuperview];
    
    if (!_menuV) {
        _menuV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 40)];
    }
    else{
        [_menuV setFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 40)];
    }
    
    [_menuV setBackgroundColor:[UIColor whiteColor]];
    _menuV.userInteractionEnabled = YES;
    
    //三个按钮
    [_leftButton removeFromSuperview];
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (MAINSCREEN.size.width-50)/2, 39.5)];
        _leftButton.selected = YES;
    }
    else{
        [_leftButton setFrame:CGRectMake(0, 0, (MAINSCREEN.size.width-50)/2, 39.5)];
    }

    [_leftButton setTitle:@"最热" forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateHighlighted];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateSelected];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_normal.png"] forState:UIControlStateNormal];
    [_leftButton setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [_leftButton setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_menuV addSubview:_leftButton];
    
    [_rightButton removeFromSuperview];
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake((MAINSCREEN.size.width-50)/2, 0, (MAINSCREEN.size.width-50)/2, 39.5)];
    }
    else{
        [_rightButton setFrame:CGRectMake((MAINSCREEN.size.width-50)/2, 0, (MAINSCREEN.size.width-50)/2, 39.5)];
    }
    
    [_rightButton addTarget:self action:@selector(rightBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateHighlighted];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_selected.png"] forState:UIControlStateSelected];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"btn_white_bg_normal.png"] forState:UIControlStateNormal];
    [_rightButton setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
    [_rightButton setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_rightButton setTitle:@"最新" forState:UIControlStateNormal];
    [_menuV addSubview:_rightButton];
    
    
    
    [_setBtn removeFromSuperview];
    if (!_setBtn) {
        _setBtn = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width-50, 0, 50, 40)];
    }
    else{
        [_setBtn setFrame:CGRectMake(MAINSCREEN.size.width-50, 0, 50, 40)];
    }
    
    [_setBtn setImage:[UIImage imageNamed:@"icon_btn_31.png"] forState:UIControlStateHighlighted];
    [_setBtn setImage:[UIImage imageNamed:@"icon_btn_31.png"] forState:UIControlStateSelected];
    [_setBtn setImage:[UIImage imageNamed:@"icon_btn_36.png"] forState:UIControlStateNormal];
    
    
    [_setBtn addTarget:self action:@selector(settingBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_menuV addSubview:_setBtn];
    
    UIImageView *lineV = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width-50, 0, 0.5, 40)];
    [lineV setImage:[UIImage imageNamed:@"bg_dynamic_operations.png"]];
    [lineV setBackgroundColor:[UIColor lightGrayColor]];
    [_menuV addSubview:lineV];

    return _menuV;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TopSpecialCell *tCell = [TopSpecialModel findCellWithTableView:tableView];
        [tCell setTopSpecialCellWithCellInfo:_bInfo];
        tCell.controller = self;
        return tCell;
    }
    else{
        if (_isBig) {
            DynamicTableViewCell *cell = [DynamicCellModel findCellWithTableView:tableView];
            DynamicInfo *dInfo = nil;
            if (_mType == STHotType) {
                dInfo = _hotArray[indexPath.row];
            }
            else
                dInfo = _newsArray[indexPath.row];
            
            cell.sVC = self;
            cell.iVC = nil;
            cell.tipsVC = nil;
            cell.rVC = nil;

            
            [cell setCellWithCellInfo:dInfo isShowfocusButton:YES];
            return cell;
        }
        else{
            SmallImageCell *sCell = [SmallImageModel findCellWithTableView:tableView];
            sCell.delegate = self;
            NSArray *temp = nil;
            if (_mType == STHotType) {
                temp = _hotArray;
            }
            else
                temp = _newsArray;
            
            [sCell setSmallImageCellWithCellInfo:temp];
            return sCell;
        }
    }

    return nil;
    
}

- (void)jumpToWebView
{
    STWebViewController*dVC = CREATCONTROLLER(STWebViewController);
    dVC.mType = Type_Special;
    dVC.bInfo = _bInfo;
    
    [self.navigationController pushViewController:dVC animated:YES];
}


//最热
- (void)leftBtnTapped:(UIButton *)sender
{
    sender.selected = YES;
    _rightButton.selected = NO;
    _mType = STHotType;
    
    //先清空数据
    [_coreDataMange clearAllData];
    [_hotArray removeAllObjects];

    if (_hotArray.count == 0) {
        _mPage = 1;
        //获取人气最高的第一页
        [self getPOSpecialImgs:_mType pageOfNO:_mPage];
    }
    
    [_tableView reloadData];
}

//最新
- (void)rightBtnTapped:(UIButton *)sender
{
    sender.selected = YES;
    _leftButton.selected = NO;

    _mType = STNewType;
    
    //先清空数据
    [_coreDataMange clearAllData];
    [_newsArray removeAllObjects];
    
    if (_newsArray.count == 0) {
        _mPage = 1;
        //获取人气最高的第一页
        [self getPOSpecialImgs:_mType pageOfNO:_mPage];
    }
    
    [_tableView reloadData];
}

//切换大小图
- (void)settingBtnTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _isBig = sender.selected;
    
    [_tableView reloadData];

}


#pragma mark - SmallImageCellDelegate
- (void)smallImageCellSelectItem:(DynamicInfo *)dInfo
{
    TipsDetailsViewController *tipsVC = (TipsDetailsViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[TipsDetailsViewController class]];
    tipsVC.dyInfo = dInfo;
    tipsVC.hidesBottomBarWhenPushed = YES;
    
    //美食日记图片点击
    tipsVC.m_Type = SecondTypeTips;
    
    [self.navigationController pushViewController:tipsVC animated:YES];
}


- (void)getPOSpecialImgs:(NSUInteger)sort pageOfNO:(NSUInteger)page
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:_bInfo.specialId forKey:@"specialId"];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dic setObject:@"21" forKey:@"size"];
    
    [dic setObject:[NSNumber numberWithInteger:sort] forKey:@"sort"];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_dao SpecialImgsList:requestDict completionBlock:^(NSDictionary *result) {
        if (result.code == 200) {
            NSArray *temp = (NSArray *)result.obj;
            
            CLog(@"%@",temp);
            
            if (_mPage == 1) {
                //先清空数据
                [_coreDataMange clearAllData];
                
                if (sort == STHotType) {
                    [_hotArray removeAllObjects];
                }
                
                if (sort == STNewType) {
                    [_newsArray removeAllObjects];
                }
                
            }
            
            if (temp.count >= 21) {
                _isMore = YES;
                _mPage ++;
            }
            else{
                _isMore = NO;
            }
            
            if (temp && [temp isKindOfClass:[NSArray class]]) {
                
                switch (sort) {
                    case STHotType:
                        [_hotArray addObjectsFromArray:[self parisDataWithArray:temp]];
                        [self writeDate:temp];
                        break;
                        
                    case STNewType:
                        [_newsArray addObjectsFromArray:[self parisDataWithArray:temp]];
                        [self writeDate:temp];
                        break;
                        
                    default:
                        break;
                }
                
                [_tableView reloadData];

            }
        }
        else if(result.code == 500)
        {
            MET_MIDDLE(result.msg);
        }
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
    
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
    
    _openArray = tA;
    _openImageArray = tB;
}


//获取更多
- (void)get_more{
    [self summarizeShareData];
    
    [SGActionView sharedActionView].style = SGActionViewStyleLight;
    [SGActionView showGridMenuWithTitle:nil
                             itemTitles:_openArray
                                 images:_openImageArray
                         selectedHandle:^(NSInteger index)  {
                             [self didClickOnImageIndex:index];
                         }];
}

//我要po图
- (void)poPicture{
    
    //创建
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //添加字典
    [dictionary setObject:_bInfo.mTag forKey:@"MTAG"];
    [dictionary setObject:_bInfo.specialId forKey:@"TAGID"];
    theAppDelegate.PODict = dictionary;
    theAppDelegate.isPO = YES;
    
    
    PhotoViewController *caVC = (PhotoViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"CameraStoryboard" class:[PhotoViewController class]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:caVC];
    
    [self presentViewController:nav animated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    if (imageIndex == 0)
    {
        return;
    }
    
    NSString *description = _bInfo.shareDesc;
    //跳转链接
    NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/view/special/special.html?specialId=%@",_bInfo.specialId]];
    //图片DATA
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_bInfo.shareImgUrl]];
    
    NSString * name = [_openArray objectAtIndex:imageIndex-1];
    if ([name isEqualToString:@"QQ好友"]) {
        [[ShareModel getInstance] qqFriendsShareMessageWithUrl:url thumbnail:imageData describe:description title:_bInfo.shareTitle];
    }
    
    if ([name isEqualToString:@"QQ空间"]) {
        [[ShareModel getInstance] qqZoneShareMessageWithUrl:url thumbnail:imageData describe:description title:_bInfo.shareTitle];
    }
    
    if ([name isEqualToString:@"微信好友"]) {
        [[ShareModel getInstance] wechatFriendsMessageWithUrl:url thumbnail:imageData describe:description title:_bInfo.shareTitle];
    }
    
    if ([name isEqualToString:@"微信朋友圈"]) {
        [[ShareModel getInstance] wechatCircleMessageWithUrl:url thumbnail:imageData describe:_bInfo.shareTitle title:_bInfo.shareTitle];
    }
}


#pragma mark - MLEmojiLabelDelegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"点击了某个自添加链接%@",url);
}


- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    NSLog(@"点击了某个自添加链接%@",addressComponents);
}



- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    NSString *status = [components objectForKey:@"inspect_article"];
    
    if ([status isEqualToString:INSPECT_ALL_ARTICLE]) {
        STWebViewController*dVC = CREATCONTROLLER(STWebViewController);
        dVC.mType = Type_Special;
        dVC.bInfo = _bInfo;
        [self.navigationController pushViewController:dVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/******************************************计算高度 *****************************************/
// 赋值
- (CGFloat)calculateCellHighWithCellInfo:(DynamicInfo *)d_Info
{
    CGFloat m_hight = 60 + MAINSCREEN.size.width;   //顶部高度跟图片高度
    
    /****************************************  图片描述    ***********************************************/
    if ([d_Info.imgDesc length] > 0) {
        //底部view距离图片的高度
        CLog(@"%02f", [self calculateDesLabelheight:m_hight desLabel:d_Info.imgDesc]);
        m_hight += [self calculateDesLabelheight:m_hight desLabel:d_Info.imgDesc];
    }
    
    /**************************************   赞过得用户列表   *******************************************/
    if(d_Info.praiseCount > 0)
    {
        CLog(@"%02f", [self setPraise:d_Info.persInfo currentHeight:m_hight]);
        m_hight += [self setPraise:d_Info.persInfo currentHeight:m_hight];
    }
    
    /**************************************   评论列表   *******************************************/
    if (d_Info.commentCount > 0) {
        
        CLog(@"%02f", [self setComments:d_Info.comInfo imageAuthor:d_Info.userId currentHeight:m_hight commentsNum:d_Info.commentCount]);
        m_hight +=  [self setComments:d_Info.comInfo imageAuthor:d_Info.userId currentHeight:m_hight commentsNum:d_Info.commentCount];
    }
    
    //最后40为评分的高度
    return m_hight+12+45+5+15 +20;
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



/****************************************  公共方法 *************************************/
//点击
- (void)imgaeHeadTapped:(NSString *)userID
{
    if (!theAppDelegate.isLogin) {
        STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
        STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
        nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        nc.view.layer.shadowOpacity = 0.2;
        
        [self presentViewController:nc animated:YES completion:nil];
        
        return;
    }

    
    //自己就跳转到
    if ([userID isEqualToString:[AccountInfo sharedAccountInfo].userId]) {
        ProfileTableViewController *hVC = [[ProfileTableViewController alloc] init];
        hVC.isFromTabbar = NO;
        hVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hVC animated:YES];
        
    }
    else{
        
        UIStoryboard *MineStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
        HimselfViewController *hVC = [MineStoryboard instantiateViewControllerWithIdentifier:@"HimselfViewController"];
        hVC.respondentUserId = userID;
        hVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hVC animated:YES];
    }
}



//标签点击
- (void)clickBubbleViewWithInfo:(BubbleView *)bubleV shopWithInfo:(ShopInfo *)sInfo
{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    
    TipsDetailsViewController *tVC = [board instantiateViewControllerWithIdentifier:@"TipsDetailsViewController"];
    
    tVC.bubbleV = bubleV;
    tVC.shopInfo = sInfo;
    
    if (bubleV.tipType == Tip_Location) {
        tVC.isShowPlace = YES;
    }
    
    tVC.m_Type = FistTypeTips;
    
    tVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:tVC animated:YES];
}

//关注
- (void)focusButtonTapped
{

}

//喜欢(赞)
- (void)praiseButtonTapped:(PraiseInfo *)pInfo
{
    _mPage = 1;
    _isMore = YES;
    if (_mType == STHotType) {
        [_hotArray removeAllObjects];
    }
    else if(_mType == STNewType)
    {
        [_newsArray removeAllObjects];
    }
    
    //插入数据
    [_coreDataMange selectDataWithPraise:pInfo];
    
    [self performSelector:@selector(readData) withObject:nil afterDelay:0.4];
}


//取消(赞)
- (void)cancelPraise:(PraiseInfo *)pInfo
{
    _mPage = 1;
    _isMore = YES;
    if (_mType == STHotType) {
        [_hotArray removeAllObjects];
    }
    else if(_mType == STNewType)
    {
        [_newsArray removeAllObjects];
    }
    
    
    //清除数据
    [_coreDataMange clearDataWithPraise:pInfo];
    [self performSelector:@selector(readData) withObject:nil afterDelay:0.4];
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
    dVC.mType = SpecialType;
    
    [self.navigationController pushViewController:dVC animated:YES];
}

//收藏
- (void)collectionTypeChoose:(DynamicInfo *)dInfo
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    
    CollectionTypeViewController *coVC = [board instantiateViewControllerWithIdentifier:@"CollectionTypeViewController"];
    
    coVC.imageId = dInfo.imgId;
    coVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:coVC animated:NO];
}



- (void)summarizeShareDataA{
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
    
    [self summarizeShareDataA];
    
    
    [SGActionView sharedActionView].style = SGActionViewStyleLight;
    [SGActionView showGridMenuWithTitle:nil
                             itemTitles:_openArray
                                 images:_openImageArray
                         selectedHandle:^(NSInteger index) {
                             [self didClickOnImageIndexA:index];
                         }];
    
}




- (void)didClickOnImageIndexA:(NSInteger)imageIndex
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
    
    [_mDao requestHideImage:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            //刷新
            [self performSelector:@selector(headerRereshing) withObject:nil afterDelay:0.2];
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
    
    [_mDao requestDeleteImage:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            //刷新
            [self performSelector:@selector(headerRereshing) withObject:nil afterDelay:0.2];
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
    
    [_mDao requestReportPic:dic completionBlock:^(NSDictionary *result) {
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
    dVC.mType = SpecialType;
    
    [self.navigationController pushViewController:dVC animated:YES];
}

//更新评论
- (void)updateComments:(NSNotification *)notification
{
    //插入数据
    [_coreDataMange selectDataWithComment:notification.object];
    
    [self performSelector:@selector(readData) withObject:nil afterDelay:0.5];
}



- (void)imagePraisList:(NSString *)imageId
{
    UIStoryboard *mineStroyboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    UserListViewController *userListVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];
    
    userListVC.respondentUserId = [AccountInfo sharedAccountInfo].userId;
    userListVC.hidesBottomBarWhenPushed = YES;
    userListVC.userListType = PraiseList;
    userListVC.imageId = imageId;
    
    [self.navigationController pushViewController:userListVC animated:YES];
}

//PO图完成后调用
- (void)picturesReleasedComplete
{
    _rightButton.selected = YES;
    _leftButton.selected = NO;
    
    _mType = STNewType;
    
    if (_newsArray.count == 0) {
        _mPage = 1;
        [self.tableView.header beginRefreshing];
        //获取人气最高的第一页
        [self getPOSpecialImgs:_mType pageOfNO:_mPage];
    }
    
    [_tableView reloadData];
}

@end
