//
//  MapMarkViewController.m
//  Artery
//
//  Created by RichardLiu on 15/3/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "MapMarkViewController.h"
#import "PlaceDAO.h"
#import <MapKit/MapKit.h>
#import "PlaceTableViewCell.h"
#import "PlaceModel.h"
#import "UIImageView+JTDropShadow.h"
#import <AMapSearchKit/AMapSearchAPI.h>



@interface MapMarkViewController ()<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UISearchBarDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIButton *positionBtn;   //回到当前位置按钮
@property (nonatomic, strong) UIImageView *markBGV;    //标注阴影
@property (nonatomic, strong) UIImageView *markV;      //标注图标

@property (nonatomic, strong) PlaceDAO *dao;

@property (nonatomic, assign) double latitude;          //纬度
@property (nonatomic, assign) double longitude;         //经度

@property (nonatomic, strong) NSArray *tableArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TencentPostion *posInfo;

@property (nonatomic, assign) BOOL isListen;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) MKPointAnnotation *annotation;   //标注
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) AMapSearchAPI* search;            //高德地图搜索


@property (nonatomic, assign) BOOL isSearchA;                   //是否搜索



@end

@implementation MapMarkViewController

- (void)initDao
{
    if (!_dao) {
        self.dao = [[PlaceDAO alloc] init];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  initDao];
    
    _geocoder = [[CLGeocoder alloc] init];
    
    [self setNavBarTitle:@"位置"];
    
    //高德地图
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] initWithSearchKey:K_AMAP_KEY Delegate:self];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"确定" target:self action:@selector(doneButtonTapped:)]];

    _isListen = NO;
    _isSearchA = NO;
    
    //默认选中
    _currentIndex = 0;
    
    CGFloat MAP_HEIGHT = 250.0;
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, MAINSCREEN.size.width, MAP_HEIGHT)];
    self.mapView.delegate = self;
    //显示用户当前位置
    self.mapView.showsUserLocation = YES;
    //用户跟随
    self.mapView.userTrackingMode = 1;
    
    //地图不旋转
    self.mapView.rotateEnabled = NO;

    //回到当前位置（定位）
    _positionBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, MAP_HEIGHT -60, 46, 46)];
    [_positionBtn setBackgroundImage:[UIImage imageNamed:@"location_back_icon.png"] forState:UIControlStateNormal];
    [_positionBtn addTarget:self action:@selector(positionBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:_positionBtn];
    
    
    _markBGV = [[UIImageView alloc] initWithFrame:CGRectMake(self.mapView.frame.size.width/2 - 12, self.mapView.frame.size.height/2 - 33, 48, 33)];
    [_markBGV setImage:[UIImage imageNamed:@"located_2.png"]];
    [self.mapView addSubview:_markBGV];
    
    _markV = [[UIImageView alloc] initWithFrame:CGRectMake(self.mapView.frame.size.width/2 - 12, self.mapView.frame.size.height/2 - 33, 48, 33)];
    [_markV setImage:[UIImage imageNamed:@"located_1.png"]];
    [self.mapView addSubview:_markV];
    
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 44)];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.delegate = self;
    [self.mapView addSubview:_searchBar];

    [self.mapView dropShadowWithOffset:CGSizeMake(0, 2) radius:0.8 color:[UIColor grayColor] opacity:0.4];
    [self.view addSubview:self.mapView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.size.height+64, MAINSCREEN.size.width, MAINSCREEN.size.height - self.mapView.frame.size.height - 44) style:UITableViewStylePlain];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //该view置于最前
    [self.view bringSubviewToFront:self.mapView];

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        AlertWithTitleAndMessage(@"未开启定位功能", @"请到设置-隐私-定位服务中开启定位功能");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//选取地点
- (void)doneButtonTapped:(id)sender
{
    if(!_posInfo)
    {
        AlertWithTitleAndMessage(@"未开启定位功能", @"请到设置-隐私-定位服务中开启定位功能");
        return;
    }

    if(_currentIndex == 0)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(selectedMapMarkWithInfo:otherInfo:)]) {
            [_delegate selectedMapMarkWithInfo:_posInfo otherInfo:nil];
        }
    }
    else{
        if (_delegate && [_delegate respondsToSelector:@selector(selectedMapMarkWithInfo:otherInfo:)]) {
            
            TencentMapInfo *tInfo = [_tableArray objectAtIndex:_currentIndex - 1];
            
            [_delegate selectedMapMarkWithInfo:_posInfo otherInfo:tInfo];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)positionBtnTapped:(id)sender
{
    [_markV setHidden:NO];
    [_markBGV setHidden:NO];
    
    self.mapView.userTrackingMode = 1;
    _isSearchA = NO;
    [_searchBar resignFirstResponder];
}

//获取附近地点（腾讯地图）
- (void)queryData
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [dic setObject:@"6UXBZ-KQV3O-RN6W7-S3NDC-47263-GIFK5" forKeyedSubscript:@"key"];
    [dic setObject:[NSNumber numberWithInteger:1] forKeyedSubscript:@"get_poi"];
    
    NSString *los = [NSString stringWithFormat:@"%f,%f", _latitude, _longitude];
    
    [dic setObject:los forKeyedSubscript:@"location"];

    
    [_dao getNearAddressInfo:dic completionBlock:^(NSDictionary *result) {
        
        CLog(@"%@", result);
        NSDictionary *dic = [result objectForKey:@"result"];
        
        TencentPostion *pInfo = [[TencentPostion alloc] initWithParsData:dic];
        self.posInfo = pInfo;
        
        [self parisData:[dic objectForKey:@"pois"]];
        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}


//解析腾讯地图数据
- (void)parisData:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *item in array) {
        TencentMapInfo *tInfo = [[TencentMapInfo alloc] initWithParsData:item];
        [tempArray addObject:tInfo];
    }
    self.tableArray = tempArray;
    
    [_tableView reloadData];
}


//解析高德地图数据
- (void)parisAmapData:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (AMapPOI *p in array) {
        TencentMapInfo *tInfo = [[TencentMapInfo alloc] initWithParsAmapData:p];
        
        [tempArray addObject:tInfo];

    }
    
    self.tableArray = tempArray;
    
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearchA) {
        return [_tableArray count];
    }
    return [_tableArray count] +1;
}

//选中状态
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == _currentIndex){
        return UITableViewCellAccessoryCheckmark;
    }
    else{
        return UITableViewCellAccessoryNone;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaceTableViewCell *cell = [PlaceModel findCellWithTableView:tableView];
    
    if (_isSearchA) {
        TencentMapInfo *tInfo = [_tableArray objectAtIndex:indexPath.row];
        cell.titLabel.text = tInfo.title;
        cell.desLabel.text = tInfo.address;
    }
    else{
        if (indexPath.row == 0) {
            
            cell.titLabel.text = @"[位置]";
            cell.desLabel.text = [NSString stringWithFormat:@"%@%@", self.posInfo.city, self.posInfo.title];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            TencentMapInfo *tInfo = [_tableArray objectAtIndex:indexPath.row - 1];
            cell.titLabel.text = tInfo.title;
            cell.desLabel.text = tInfo.address;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _currentIndex = indexPath.row;
    
    //设置显示范围
    MKCoordinateRegion region;
    
    if (_isSearchA) {
        [_markV setHidden:YES];
        [_markBGV setHidden:YES];
        
        if (!_annotation) {
            _annotation = [[MKPointAnnotation alloc] init];
        }
        else{
            //先清空原有标注
            [self.mapView removeAnnotation:_annotation];
        }
        
        TencentMapInfo *tInfo = [_tableArray objectAtIndex:indexPath.row];
        _annotation.coordinate = tInfo.coordinate;
        [self.mapView addAnnotation:_annotation];
        
        region.span.latitudeDelta = 0.002;
        region.span.longitudeDelta = 0.002;
        region.center = tInfo.coordinate;
        
        // 设置显示位置(动画)
        [_mapView setRegion:region animated:YES];
        
        // 设置地图显示的类型及根据范围进行显示
        [_mapView regionThatFits:region];
        
    }
    else{
        if (indexPath.row > 0) {
            [_markV setHidden:YES];
            [_markBGV setHidden:YES];
            
            if (!_annotation) {
                _annotation = [[MKPointAnnotation alloc] init];
            }
            else{
                //先清空原有标注
                [self.mapView removeAnnotation:_annotation];
            }
            
            TencentMapInfo *tInfo = [_tableArray objectAtIndex:indexPath.row - 1];
            _annotation.coordinate = tInfo.coordinate;
            [self.mapView addAnnotation:_annotation];
            
            
            region.span.latitudeDelta = 0.002;
            region.span.longitudeDelta = 0.002;
            region.center = tInfo.coordinate;
            
            // 设置显示位置(动画)
            [_mapView setRegion:region animated:YES];
            // 设置地图显示的类型及根据范围进行显示
            [_mapView regionThatFits:region];
        }
        else
        {
            [_markV setHidden:NO];
            [_markBGV setHidden:NO];
            
            if (!_annotation) {
                _annotation = [[MKPointAnnotation alloc] init];
            }
            else{
                //先清空原有标注
                [self.mapView removeAnnotation:_annotation];
            }
        }
    }
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MKMapView
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [_searchBar resignFirstResponder];
    _latitude = userLocation.location.coordinate.latitude;
    _longitude = userLocation.location.coordinate.longitude;
    
    if (!_isListen) {
        //搜索附近的地点
        [self queryData];
        
        _isListen = YES;
    }

}

// Map移动 后执行，所以我们可以在这里获取移动后地图中心点的经纬度了
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [_searchBar resignFirstResponder];
    
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;

    
    if (_isListen && !_isSearchA) {
        _latitude = centerCoordinate.latitude;
        _longitude = centerCoordinate.longitude;
        
        //搜索附近的地点
        [self queryData];
    }
}

#pragma mark 根据地名确定地理坐标
- (void)getCoordinateByAddress:(NSString *)address{
    //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = address;
    poiRequest.city = @[_posInfo.city];
    poiRequest.requireExtension = YES;
    
    //发起POI搜索
    [_search AMapPlaceSearch: poiRequest];
}

//高德地图实现POI搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过AMapPlaceSearchResponse对象处理搜索结果
    [self parisAmapData:response.pois];
}

#pragma mark 搜索框事件
//添加搜索框事件：
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    _isSearchA = YES;
    
    [searchBar resignFirstResponder];
    //地理编码
    [self getCoordinateByAddress:searchBar.text];
    
}


//添加取消按钮事件：
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}



@end
