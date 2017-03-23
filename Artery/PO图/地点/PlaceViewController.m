//
//  PlaceViewController.m
//  Artery
//
//  Created by 刘敏 on 14-9-25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PlaceViewController.h"
#import "MJRefresh.h"
#import "PlaceDAO.h"
#import "PlaceTableViewCell.h"
#import "PlaceModel.h"
#import "PlaceNormalTableViewCell.h"
#import "PlaceNormalModel.h"
#import "WGS84TOGCJ02.h"
#import "JZLocationConverter.h"
#import <CoreLocation/CoreLocation.h>
#import "SettingModel.h"
#import "FoodNameViewController.h"
#import "CreateSiteViewController.h"

@interface PlaceViewController ()<CLLocationManagerDelegate>

@property (strong, readwrite, nonatomic) PlaceDAO *dao;
@property (assign, nonatomic) NSInteger nPage;   //附近列表当前页码
@property (assign, nonatomic) NSInteger sPage;   //搜索列表当前页码
@property (strong, nonatomic) PlaceInfo *pInfo;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL isSearch;      //是否搜索

@end

@implementation PlaceViewController

- (void)viewWillAppear:(BOOL)animated
{
    //显示
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [theAppDelegate.HUDManager hideHUD];
}


-(void)initDao
{
    if (!self.dao) {
        self.dao = [[PlaceDAO alloc] init];
    }
    
    _tableArray = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBarTitle:@"所在位置"];
    
    [ResetFrame resetScrollView:self.tableview contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"icon_close.png" imgHighlight:@"icon_close.png" target:self action:@selector(back:)]];
    
    [self initDao];
    
    //初始分页个数
    _nPage = 1;
    _sPage = 1;

    //定位
    [self initializeGPSModule];

    // 集成刷新控件
    [self setupRefresh];
    
    _isSearch = NO;
    
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.keyboardType = UIKeyboardTypeDefault;

}


//初始化定位模块
- (void)initializeGPSModule{
    
    [theAppDelegate.HUDManager showSimpleTip:@"获取地理位置" interval:NSNotFound];
    
    if ([CLLocationManager locationServicesEnabled]){
        // 初始化并开始更新
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        // 设置定位精度（移动多少米重新定位）
        self.locationManager.distanceFilter = 5;
        // 设置寻址经度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        if(isIOS8)
        {
            //ios8新增的定位授权功能
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    else{
        [theAppDelegate.HUDManager hideHUD];
        MET_MIDDLE(@"定位失败,请打开定位功能");
    }
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(footerRereshingNearBy)];
    self.tableview.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshingSearch)];
    
}


// 附近列表下拉获取更多
- (void)footerRereshingNearBy
{
    _nPage++;
    
    if(theAppDelegate.longitude)
    {
        [self getNearPlaceList:_nPage];
    }
    else
    {
        AlertWithTitleAndMessage(@"未开启定位功能", @"请到设置-隐私-定位服务中开启定位功能");
    }
}

// 搜索列表下拉获取更多
- (void)footerRereshingSearch
{
    _sPage++;
    [self requestPlaceSearch:_searchBar.text inPage:_sPage];
    
}


//创建地址标签
- (void)creatAddressTip:(PlaceInfo *)mInfo
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (mInfo.addressName) {
        [dic setObject:mInfo.addressName forKey:@"addressName"];
    }
    
    if (mInfo.branchName) {
        [dic setObject:mInfo.branchName forKey:@"branchName"];
    }

    if (mInfo.address) {
        [dic setObject:mInfo.address forKey:@"address"];
    }
    
    if (mInfo.city) {
        [dic setObject:mInfo.city forKey:@"city"];
    }
    
    if (mInfo.region) {
        [dic setObject:mInfo.region forKey:@"region"];
    }
    
    if (mInfo.phone) {
        [dic setObject:mInfo.phone forKey:@"phone"];
    }
    
    if (mInfo.longitude) {
        [dic setObject:mInfo.longitude forKey:@"longitude"];
    }
    
    
    if (mInfo.latitude) {
        [dic setObject:mInfo.latitude forKey:@"latitude"];
    }
    
    
    if (mInfo.businessId) {
        [dic setObject:mInfo.businessId forKey:@"businessId"];
    }
    
    
    if (mInfo.addressSource) {
        [dic setObject:mInfo.addressSource forKey:@"addressSource"];
    }

    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_dao createdCustomSite:requestDict
            completionBlock:^(NSDictionary *result) {
            
                if ([[result objectForKey:@"code"] integerValue] == 200) {
                    
                    if ([result objectForKey:@"obj"]) {
                        
                        PlaceInfo *mInfo = [[PlaceInfo alloc] initWithParsData:[result objectForKey:@"obj"]];
                        [self jumpToFoodView:mInfo];

                    }

                }
                else
                {
                    MET_MIDDLE([result objectForKey:@"msg"]);
                }
                
            } setFailedBlock:^(NSDictionary *result) {
                
            }];
}


//获取附近地点
- (void)getNearPlaceList:(NSInteger)page
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    //TODO：当经纬度为空dict字典会crush，所以必须判断
    if (!theAppDelegate.longitude) {
        AlertWithTitleAndMessage(@"未开启定位功能", @"请到设置-隐私-定位服务中开启定位功能");
        return;
    }

    [dict setObject:theAppDelegate.longitude forKey:@"longitude"];
    [dict setObject:theAppDelegate.latitude forKey:@"latitude"];
    
    //偏移类型，0:未偏移，1:高德坐标系偏移，2:图吧坐标系偏移，如不传入，默认值为0
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"offset_type"];
    
    // 排序（7、最近距离排序）
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"sort"];
    
    //分页
    if (page > 0) {
        [dict setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    }
    
    //范围 （默认1000米）
    [dict setObject:[NSNumber numberWithInt:5000] forKey:@"radius"];
    
    
    //发起请求
    [_dao requestNearPlace:dict
           completionBlock:^(NSDictionary *result) {
               if ([[result objectForKey:@"code"] integerValue] == 200) {
                   NSDictionary *dic = [result objectForKey:@"obj"];
                   [self getPlacesuccessful:dic searchKeyword:nil];
               }
               else
               {
                   MET_MIDDLE([result objectForKey:@"msg"]);
               }
               [self.tableview.footer endRefreshing];
           }
            setFailedBlock:^(NSDictionary *result) {
            }];
}


//搜索地点（同城内地点搜索，无范围限制，可搜索自定义地点跟大众点评地点）
- (void)requestPlaceSearch:(NSString *)keyword inPage:(NSInteger)page
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    //分页
    if (page > 0) {
        [dict setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    }
    
    //单个页面信息条数
    [dict setObject:[NSNumber numberWithInt:20] forKey:@"size"];
    
    [dict setObject:keyword forKey:@"keyword"];
    
    

    if (theAppDelegate.locatCity) {
        [dict setObject:theAppDelegate.locatCity forKey:@"city"];
    }
    
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    //发起请求
    [_dao requestPlaceSearch:requestDict
             completionBlock:^(NSDictionary *result) {
                 if ([[result objectForKey:@"code"] integerValue] == 200) {
                     
                     NSDictionary *dic = [result objectForKey:@"obj"];
                     
                     [self getPlacesuccessful:dic searchKeyword:keyword];
                 }
                 else
                 {
                     [self.tableview reloadData];
                 }
                 
             }
              setFailedBlock:^(NSDictionary *result) {
              }];
}



- (void)getPlacesuccessful:(NSDictionary *)dict searchKeyword:(NSString *)keyword{
    //搜索
    if (keyword) {
        if (_sPage == 1) {
            [_tableArray removeAllObjects];
        }
        
        [_tableArray addObjectsFromArray:[dict objectForKey:@"addresses"]];
        
        
        for (NSDictionary * item in _tableArray)
        {
            if([[item objectForKey:@"addressName"] hasPrefix:keyword])
            {
                //存在相同的
                _isSearch = NO;
            }
        }
        [self.tableview reloadData];
    }
    else
    {
        if (_nPage == 1) {
            [_tableArray removeAllObjects];
        }
        
        [_tableArray addObjectsFromArray:[dict objectForKey:@"addresses"]];
        
        [_tableview reloadData];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 40)];
    UIImageView *dpLpgoV = [[UIImageView alloc] initWithFrame:CGRectMake(90, 11, 18, 18)];
    dpLpgoV.image = [UIImage imageNamed:@"dianping_icon.png"];
    [customView addSubview:dpLpgoV];
    
    UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(116, 10, 120, 20)];
    textL.text = @"数据由大众点评提供";
    textL.backgroundColor = [UIColor clearColor];
    textL.font = [UIFont systemFontOfSize:13.0];
    [customView addSubview:textL];
   
    return customView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isSearch)
    {
        if (indexPath.row == 0) {
            return 44.0;
        }
    }
    return 52.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isSearch)
    {
        return [_tableArray count] + 1;
    }
    
    return [_tableArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!_isSearch)
    {
        PlaceTableViewCell *cell = [PlaceModel findCellWithTableView:tableView];
        
        _pInfo = [[PlaceInfo alloc] initWithParsData:[_tableArray objectAtIndex:indexPath.row]];
        
        cell.titLabel.text = _pInfo.addressName;
        if (_pInfo.branchName && _pInfo.branchName.length > 0) {
            cell.titLabel.text = [[[_pInfo.addressName stringByAppendingString:@"("] stringByAppendingString:_pInfo.branchName] stringByAppendingString:@")"];
        }
        cell.desLabel.text = _pInfo.address;
        
        return cell;
    }
    else
    {
        if (indexPath.row == 0) {
            PlaceNormalTableViewCell *cell = [PlaceNormalModel findCellWithTableView:tableView];
            cell.titLabel.text = [@"添加标签:" stringByAppendingString:_searchBar.text];
            cell.titLabel.textColor = MAIN_COLOR;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
        else{
            PlaceTableViewCell *cell = [PlaceModel findCellWithTableView:tableView];
            
            _pInfo = [[PlaceInfo alloc] initWithParsData:[_tableArray objectAtIndex:indexPath.row-1]];
            
            cell.titLabel.text = _pInfo.addressName;
            if (_pInfo.branchName && _pInfo.branchName.length > 0) {
                cell.titLabel.text = [[[_pInfo.addressName stringByAppendingString:@"("] stringByAppendingString:_pInfo.branchName] stringByAppendingString:@")"];
            }
            cell.desLabel.text = _pInfo.address;
            
            return cell;
        }
    }
    
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_searchBar resignFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (!_isSearch)
    {
        if (_tableArray.count == 0) {
            return;
        }
        _pInfo = [[PlaceInfo alloc] initWithParsData:[_tableArray objectAtIndex:indexPath.row]];
        // 已经是自己服务器的标签
        if (_pInfo.addressId && [_pInfo.addressSource isEqualToString:@"DONGMAI"]) {
            [self jumpToFoodView:_pInfo];
        }
        else{
            [self creatAddressTip:_pInfo];
        }
    }
    else
    {
        if (indexPath.row == 0) {
            UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"CameraStoryboard" bundle:nil];
            CreateSiteViewController *pVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"CreateSiteViewController"];
            pVC.merchantName = _searchBar.text;
            [self.navigationController pushViewController:pVC animated:YES];
        }
        else
        {
            _pInfo = [[PlaceInfo alloc] initWithParsData:[_tableArray objectAtIndex:indexPath.row-1]];
            
            // 已经是自己服务器的标签
            if (_pInfo.addressId && [_pInfo.addressSource isEqualToString:@"DONGMAI"]) {
                
                [self jumpToFoodView:_pInfo];
                
            }
            else{
                [self creatAddressTip:_pInfo];
            }
        }
    }
}

- (void)jumpToFoodView:(PlaceInfo *)pInfo
{
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"CameraStoryboard" bundle:nil];
    FoodNameViewController *pVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"FoodNameViewController"];
    pVC.pInfo = pInfo;
    [self.navigationController pushViewController:pVC animated:YES];
    
}


- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 搜索框事件
//添加搜索框事件：
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    [_tableArray removeAllObjects];
    
    _sPage = 1;
    
    if ([searchBar.text length] > 0) {
        
        _isSearch = YES;
        //实时请求
        [self requestPlaceSearch:searchBar.text inPage:_sPage];
    }

    
}


//添加取消按钮事件：
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text length] == 0) {
        //获取附近的商铺信息
        _isSearch = NO;
        [self getNearPlaceList:_nPage];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}




#pragma mark CLLocationManagerDelegate methods
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    // 获取经纬度（手机）
    CLog(@"纬度:%14f",newLocation.coordinate.latitude);
    CLog(@"经度:%8f",newLocation.coordinate.longitude);
    
    
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[newLocation coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [JZLocationConverter wgs84ToBd09:[newLocation coordinate]];

        
        // 获取经纬度
        CLog(@"火星坐标纬度:%f",coord.latitude);
        CLog(@"火星坐标经度:%f",coord.longitude);
        
        
        theAppDelegate.latitude = [NSString stringWithFormat:@"%f", coord.latitude];
        theAppDelegate.longitude = [NSString stringWithFormat:@"%f", coord.longitude];
    }
    else{
        // 获取经纬度
        CLog(@"火星坐标纬度:%f",newLocation.coordinate.latitude);
        CLog(@"火星坐标经度:%f",newLocation.coordinate.longitude);
        
        
        theAppDelegate.latitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
        theAppDelegate.longitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    }

    theAppDelegate.latitude = [NSString stringWithFormat:@"%3f", newLocation.coordinate.latitude];
    theAppDelegate.longitude = [NSString stringWithFormat:@"%3f", newLocation.coordinate.longitude];

    
    __block NSString *city = nil;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
        if (placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            city = placemark.locality;
            CLog(@"%@, %@, %@", placemark.administrativeArea, placemark.locality, placemark.subLocality);
            CLog(@"%@", placemark.name);
            
            
            //直辖市跟特别行政区需单独判断
            if([placemark.administrativeArea hasPrefix:@"北京"])
            {
                theAppDelegate.locatCity = @"北京";
            }
            else if([placemark.administrativeArea hasPrefix:@"天津"])
            {
                theAppDelegate.locatCity = @"天津";
            }
            else if([placemark.administrativeArea hasPrefix:@"上海"])
            {
                theAppDelegate.locatCity = @"上海";
            }
            else if([placemark.administrativeArea hasPrefix:@"重庆"])
            {
                theAppDelegate.locatCity = @"重庆";
            }
            else if([placemark.administrativeArea hasPrefix:@"香港"])
            {
                theAppDelegate.locatCity = @"香港";
            }
            else if([placemark.administrativeArea hasPrefix:@"澳门"])
            {
                theAppDelegate.locatCity = @"澳门";
            }
            else{
                //单前所在城市
                city = [placemark.locality stringByReplacingOccurrencesOfString:@"市" withString:@""];
                theAppDelegate.locatCity = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
            }
            //测试
            NSString *s = [NSString stringWithFormat:@"当前经纬度：%@，%@ \n 地点：%@", theAppDelegate.latitude, theAppDelegate.longitude, placemark.name];
            CLog(@"%@", s);
        }
    }];
    
    // 停止位置更新
    [manager stopUpdatingLocation];
    
    [theAppDelegate.HUDManager hideHUD];
    //获取附近的商铺信息
    [self getNearPlaceList:_nPage];
}




// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    NSString *errorString;
    
    CLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
}



@end
