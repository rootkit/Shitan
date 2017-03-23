//
//  RMAddressViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/8/14.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RMAddressViewController.h"
#import <MapKit/MapKit.h>


@interface RMAddressViewController ()<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) UIImageView *markBGV;    //标注阴影
@property (nonatomic, strong) UIImageView *markV;      //标注图标

@end

@implementation RMAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarTitle:_rInfo.name];
    
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, MAINSCREEN.size.width, 300)];
    _mapView = mapView;
    self.mapView.delegate = self;
    //显示用户当前位置
    self.mapView.showsUserLocation = YES;
    //用户跟随
    self.mapView.userTrackingMode = 1;
    
    //地图不旋转
    self.mapView.rotateEnabled = NO;
    
    
    //设置地图中心
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [_rInfo.latitude floatValue];
    coordinate.longitude = [_rInfo.longitude floatValue];
    
    //标注
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = coordinate;
    [ann setTitle:_rInfo.name];
    [ann setSubtitle:_rInfo.address];
    //触发viewForAnnotation
    [_mapView addAnnotation:ann];
    
    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.002;
    region.span.longitudeDelta = 0.002;
    region.center = coordinate;
    
    [_mapView setRegion:region animated:NO];
    
    [self.view addSubview:self.mapView];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.size.height+64, MAINSCREEN.size.width, MAINSCREEN.size.height - self.mapView.frame.size.height - 44) style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, MAINSCREEN.size.width, 44.0)];
    [customView setBackgroundColor:[UIColor whiteColor]];
    
    // create the button object
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MAINSCREEN.size.width-30, 44.0)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.text = _rInfo.name;
    [customView addSubview:headerLabel];
    
    return customView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
        [cell.textLabel setTextColor:MAIN_TEXT_COLOR];
    }
    
    
    if (indexPath.row == 0) {
        //地址
        [cell.imageView setImage:[UIImage imageNamed:@"imported_layers"]];
        cell.textLabel.text = _rInfo.street;
    }
    
    if (indexPath.row == 1) {
        //电话
        [cell.imageView setImage:[UIImage imageNamed:@"imported_phone"]];
        cell.textLabel.text = _rInfo.phone;
    }
    
    if (indexPath.row == 2) {
        //人均
        [cell.imageView setImage:[UIImage imageNamed:@"imported_price"]];
        cell.textLabel.text = [NSString stringWithFormat:@"人均：%@元", _rInfo.avgPrice];
    }
    
    if (indexPath.row == 3) {
        //营业时间
        [cell.imageView setImage:[UIImage imageNamed:@"imported_time"]];
        cell.textLabel.text = [NSString stringWithFormat:@"营业时间：%@",  _rInfo.businessTime];
    }

    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 1)
    {
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",_rInfo.phone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
