//
//  RMMerchantsViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/8/12.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RMMerchantsViewController.h"
#import "ParallaxHeaderView.h"
#import "RMAddressViewController.h"
#import "ShopToolCell.h"
#import "ToolModelFrame.h"
#import "RecommendDAO.h"
#import "DishesInfo.h"
#import "RecommendModelFrame.h"
#import "ShopRecommendCell.h"
#import "RMAddressViewController.h"
#import "PrimersCell.h"
#import "PrimersModelFrame.h"
#import "SGActionView.h"
#import "CollectionDAO.h"
#import "ShareModel.h"

#define HEAD_IMAGE_HIGH_IPHONE5         180.0f
#define HEAD_IMAGE_HIGH_IPHONE6         211.0f
#define HEAD_IMAGE_HIGH_IPHONE_Plus     233.0f

@interface RMMerchantsViewController ()<UITableViewDataSource, UITableViewDelegate, ShopToolViewDelegate>

@property (nonatomic, strong) RecommendDAO *dao;

@property (nonatomic, weak) UIImageView *navView;
@property (nonatomic, weak) UIButton *buttonBack;
@property (nonatomic, weak) UILabel *navTit;

@property (nonatomic, weak) ParallaxHeaderView *headV;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *comArray;

@property (nonatomic, assign) CGFloat mHigh;

@property (nonatomic, strong) ToolModelFrame *toolFrame;
@property (nonatomic, strong) PrimersModelFrame *pModelFrame;

//分享
@property (nonatomic, strong) NSArray *openArray;
@property (nonatomic, strong) NSArray *openImageArray;

@property (nonatomic, weak) UIButton *favotiteBtn;

@property (nonatomic, strong) CollectionDAO *favoriteDao;



@end

@implementation RMMerchantsViewController


- (void)initDAO
{
    if (!_dao) {
        self.dao = [[RecommendDAO alloc] init];
    }
    
    if (!_favoriteDao) {
        self.favoriteDao = [[CollectionDAO alloc] init];
    }
    
    _toolFrame = [[ToolModelFrame alloc] init];
    _toolFrame.mInfo = _rInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDAO];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height+20) style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    if (MAINSCREEN.size.width == IPHONE6_PLUS_WIDTH) {
        _mHigh = HEAD_IMAGE_HIGH_IPHONE_Plus;
    }
    else if (MAINSCREEN.size.width == IPHONE6_WIDTH) {
        _mHigh = HEAD_IMAGE_HIGH_IPHONE6;
    }
    else if (MAINSCREEN.size.width == IPHONE5_WIDTH) {
        _mHigh = HEAD_IMAGE_HIGH_IPHONE5;
    }
    
    ParallaxHeaderView *headV =  [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(MAINSCREEN.size.width, _mHigh)];
    _headV = headV;
    _headV.headerTitleLabel.text = _rInfo.name;
    _headV.headerURL = _rInfo.coverUrl;
    [_tableView setTableHeaderView:_headV];
    
    [self setupNavbarButtons];
    
    //获取食探推荐菜
    [self getFoodFindList];
    
    //悬浮收藏按钮
    [self drawFavotiteBtn];
    
}

//设置顶部自定义导航栏
- (void)setupNavbarButtons
{
    UIImageView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 64)];
    _navView = navView;
    _navView.alpha = 0.0;
    [_navView setImage:[UIImage imageNamed:@"bg_navbar"]];
    [self.view addSubview:_navView];
    
    //返回按钮
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonBack = buttonBack;
    _buttonBack.frame = CGRectMake(-10, 22, 64, 40);
    [_buttonBack setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [_buttonBack addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonBack];
    
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(MAINSCREEN.size.width - 55, 22, 64, 40);
    [rightBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(shareTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];

    UILabel *navTit = [[UILabel alloc] initWithFrame:CGRectMake((MAINSCREEN.size.width-190.0)/2, 22.0f, 190.0, 40)];
    _navTit = navTit;
    _navTit.backgroundColor = [UIColor clearColor];
    _navTit.textColor = [UIColor blackColor];
    _navTit.font = [UIFont boldSystemFontOfSize:18.0];
    _navTit.textAlignment = NSTextAlignmentCenter;
    [_navTit setText:_rInfo.name];
    [_navView addSubview:_navTit];
    
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


- (void)shareTapped:(id)sender
{
    [self summarizeShareData];
    
    [SGActionView sharedActionView].style = SGActionViewStyleLight;
    [SGActionView showGridMenuWithTitle:nil
                             itemTitles:_openArray
                                 images:_openImageArray
                         selectedHandle:^(NSInteger index)  {
                             [self didClickOnImageIndex:index];
                         }];
}


- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//获取食探推荐菜
- (void)getFoodFindList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:_rInfo.businessId forKey:@"businessId"];

    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];

    [_dao getFoodFindList:requestDict completionBlock:^(NSDictionary *result) {
        if (result.code == 200) {
            [self pairsData:result.obj];
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}



- (void)pairsData:(NSArray *)array
{
    if (!array) {
        return;
    }
    
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count - 1];
    
    NSUInteger i = 0;
    for (NSDictionary *item in array) {
        
        if (i == 0) {
            PrimersModelFrame * pModelFrame = [[PrimersModelFrame alloc] init];
            _pModelFrame = pModelFrame;
            _pModelFrame.dInfo = [[DishesInfo alloc] initWithParsData:item];
            
        }
        else{
            RecommendModelFrame *recomFrame = [[RecommendModelFrame alloc] init];
            recomFrame.dInfo = [[DishesInfo alloc] initWithParsData:item];
            [tempA addObject:recomFrame];
        }
        
        i++;

    }

    self.comArray = tempA;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }

    return self.comArray.count +1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _toolFrame.rowHeight;
    }
    else
    {
        if (indexPath.row == 0) {
            return _pModelFrame.rowHeight;
        }
        else{
            RecommendModelFrame *recomFrame = self.comArray[indexPath.row - 1];
            if (indexPath.row == self.comArray.count) {
                return recomFrame.rowHeight +20;
            }
            
            return recomFrame.rowHeight;

        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ShopToolCell *cell = [ShopToolCell cellWithTableView:tableView];
        cell.toolFrame = _toolFrame;
        cell.headView.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            PrimersCell *cell = [PrimersCell cellWithTableView:tableView];
            cell.primersModelFrame = _pModelFrame;
            return cell;
        }
        else{
            ShopRecommendCell *cell = [ShopRecommendCell cellWithTableView:tableView];
            cell.recommendModelFrame = self.comArray[indexPath.row - 1];
            return cell;
        }
    }

    return nil;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateImg];
    
    if (scrollView == self.tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}


- (void)updateImg {
    CGFloat yOffset   = _tableView.contentOffset.y;
    CGFloat ap = yOffset/240;
    
    if (ap > 1.0) {
        ap = 1.0;
    }
    //改变导航栏透明度
    _navView.alpha = ap;
}



#pragma mark - ShopTopHeadViewDelegate
- (void)shopToolView:(ShopToolView *)shopToolView btnWithTag:(NSUInteger )index
{
    switch (index) {
        case 0:
        {
            RMAddressViewController *rVC = CREATCONTROLLER(RMAddressViewController);
            rVC.rInfo = _rInfo;
            [self.navigationController pushViewController:rVC animated:YES];
        }
            
            break;
            
        case 1:
        {
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",_rInfo.phone];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
            
            break;
            
        case 2:
            
            break;
            
        default:
            break;
    }
}



- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    if (imageIndex == 0)
    {
        return;
    }
    
    RecommendModelFrame * pModelFrame = [self.comArray objectAtIndex:0];
    
    NSString *description = pModelFrame.dInfo.foodDesc;
    
    //跳转链接
    NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/shop/info/?bid=%@",_rInfo.businessId]];
    //图片DATA
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:_rInfo.coverUrl]]];
    
    NSString * name = [_openArray objectAtIndex:imageIndex-1];
    if ([name isEqualToString:@"QQ好友"]) {
        [[ShareModel getInstance] qqFriendsShareMessageWithUrl:url thumbnail:imageData describe:description title:_rInfo.title];
    }
    
    if ([name isEqualToString:@"QQ空间"]) {
        [[ShareModel getInstance] qqZoneShareMessageWithUrl:url thumbnail:imageData describe:description title:_rInfo.title];
    }
    
    if ([name isEqualToString:@"微信好友"]) {
        [[ShareModel getInstance] wechatFriendsMessageWithUrl:url thumbnail:imageData describe:description title:_rInfo.title];
    }
    
    if ([name isEqualToString:@"微信朋友圈"]) {
        [[ShareModel getInstance] wechatCircleMessageWithUrl:url thumbnail:imageData describe:[NSString stringWithFormat:@"%@-%@", _rInfo.title, _rInfo.name] title:_rInfo.title];
    }
}


- (void)drawFavotiteBtn
{
    UIButton *favotiteBtn = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width - 80, MAINSCREEN.size.height-60, 60, 60)];
    _favotiteBtn = favotiteBtn;
    [_favotiteBtn setImage:@"shop_unfavorited" setSelectedImage:@"shop_favorited"];
    [_favotiteBtn addTarget:self action:@selector(collectBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_rInfo.isFavorited) {
        [_favotiteBtn setSelected:YES];
    }
    [self.view addSubview:_favotiteBtn];
}

- (void)collectBtnTapped:(UIButton *)sender
{
    
    if (sender.isSelected) {
        //已经被收藏过----取消收藏
        [self unFavoriteShop];
    }
    else
    {
        //未收藏---收藏
        [self favoriteShop];
    }
}



//收藏
- (void)favoriteShop{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    if (!theAppDelegate.isLogin) {
        
        STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
        STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
        nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        nc.view.layer.shadowOpacity = 0.2;
        
        [self presentViewController:nc animated:YES completion:nil];
        
        return;
    }
    
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dic setObject:_rInfo.businessId forKey:@"businessId"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_favoriteDao collectMerchant:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            CLog(@"成功");
            [_favotiteBtn setSelected:YES];
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}

- (void)unFavoriteShop
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
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [dic setObject:_rInfo.businessId forKey:@"businessId"];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_favoriteDao cannercollectMerchant:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            CLog(@"成功");
            [_favotiteBtn setSelected:NO];
            
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
