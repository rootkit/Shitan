//
//  CreateSiteViewController.m
//  Artery
//
//  Created by 刘敏 on 14-9-27.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CreateSiteViewController.h"
#import "MapMarkViewController.h"
#import "PlaceDAO.h"
#import "PlaceInfo.h"
#import "FoodNameViewController.h"

@interface CreateSiteViewController ()<MapMarkViewControllerDelegate>

@property (strong, readwrite, nonatomic) RETableViewSection *section1;
@property (strong, readwrite, nonatomic) RETableViewSection *section2;

@property (strong, readwrite, nonatomic) RETextItem *posName;         //商铺名称
@property (strong, readwrite, nonatomic) RELongTextItem *posAddress;  //地址

@property (strong, readwrite, nonatomic) RENumberItem *posTel;        //电话
@property (strong, readwrite, nonatomic) RETextItem   *posTime;       //营业时间

@property (strong, nonatomic) PlaceDAO *dao;

@property (strong, nonatomic) NSMutableDictionary *posDict;
@end

@implementation CreateSiteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [theAppDelegate.HUDManager hideHUD];
}

- (void)initDao
{
    if (!_dao) {
        self.dao = [[PlaceDAO alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    [self setNavBarTitle:@"创建地点"];
    
    [self initDao];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"创建" target:self action:@selector(creatButtonTapped:)]];

    self.manager = [[RETableViewManager alloc] initWithTableView:_tableView delegate:self];
    self.manager.style.cellHeight = 44.0;
    
    self.section1 = [self addSectionA];
    self.section2 = [self addSectionB];
}


- (void)back:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)creatButtonTapped:(id)sender
{
    if (_posDict.count < 1) {
        MET_MIDDLE(@"请在地图上标注地点");
        return;
    }
    
    [self initiatedCreateSiteRequest];
}

#pragma mark 自定义表格
- (RETableViewSection *)addSectionA
{
    // Add sections and items
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"必填内容"]; 
    [_manager addSection:section];
    NSMutableArray *collapsedItems = [NSMutableArray array];
    
    self.posName = [RETextItem itemWithTitle:@"名称" value:_merchantName placeholder:@"填写位置名称"];
    //地图标注
    RETableViewItem *mapItem = [RETableViewItem itemWithTitle:@"地图标注" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [section replaceItemsWithItemsFromArray:collapsedItems];
        [section reloadSectionWithAnimation:UITableViewRowAnimationAutomatic];
        
        UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"CameraStoryboard" bundle:nil];
        MapMarkViewController *pVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"MapMarkViewController"];
        pVC.delegate = self;
        [self.navigationController pushViewController:pVC animated:YES];
        
    }];
    
    self.posAddress = [RELongTextItem itemWithTitle:nil value:nil placeholder:@"请填写详细地址 如：南京路180号"];
    self.posAddress.cellHeight = 80.0;

    [collapsedItems addObjectsFromArray:@[self.posName, mapItem, self.posAddress,]];
    [section addItemsFromArray:collapsedItems];
    
    return section;
}


- (RETableViewSection *)addSectionB
{
    // Add sections and items
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"选填内容"];    
    [_manager addSection:section];
    NSMutableArray *collapsedItems = [NSMutableArray array];
    
    self.posTel = [RENumberItem itemWithTitle:@"电话" value:nil placeholder:@"商家联系电话，选填"];
    self.posTime = [RETextItem itemWithTitle:@"营业时间" value:nil placeholder:@"营业时间，选填"];
    [collapsedItems addObjectsFromArray:@[self.posTel, self.posTime]];
    [section addItemsFromArray:collapsedItems];
    
    return section;
}



//封装POST请求数据
- (void)initiatedCreateSiteRequest
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dict addEntriesFromDictionary:_posDict];

    //地点名称
    [dict setObject:self.posName.value forKey:@"addressName"];
    
    //电话
    if (self.posTel.value) {
        [dict setObject:self.posTel.value forKey:@"phone"];
    }
    
    //标示符
    [dict setObject:@"DONGMAI" forKey:@"addressSource"];
    
    //TODO：转成JSON格式
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_dao createdCustomSite:requestDict completionBlock:^(NSDictionary *result) {
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  MapMarkViewControllerDelegate
- (void)selectedMapMarkWithInfo:(TencentPostion *)pInfo otherInfo:(TencentMapInfo *)oInfo
{
    if (!_posDict) {
        _posDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    else{
        [_posDict removeAllObjects];
    }
    
    
    if (oInfo) {
        self.posAddress.value = oInfo.address;
        
        //经纬度
        [_posDict setObject:[NSNumber numberWithDouble:oInfo.coordinate.longitude] forKey:@"longitude"];
        [_posDict setObject:[NSNumber numberWithDouble:oInfo.coordinate.latitude] forKey:@"latitude"];
        
        
    }
    else{
        self.posAddress.value = [NSString stringWithFormat:@"%@%@", pInfo.city, pInfo.title];
        
        //经纬度
        [_posDict setObject:[NSNumber numberWithDouble:pInfo.coordinate.longitude] forKey:@"longitude"];
        [_posDict setObject:[NSNumber numberWithDouble:pInfo.coordinate.latitude] forKey:@"latitude"];
    }
    
    //城市
    [_posDict setObject:pInfo.city forKey:@"city"];
    
    //区域
    if (pInfo.district) {
        [_posDict setObject:pInfo.district forKey:@"region"];
    }
    
    //详细地址
    [_posDict setObject:self.posAddress.value forKey:@"address"];
    
    [_tableView reloadData];
}


- (void)jumpToFoodView:(PlaceInfo *)pInfo
{
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"CameraStoryboard" bundle:nil];
    FoodNameViewController *pVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"FoodNameViewController"];
    pVC.pInfo = pInfo;
    [self.navigationController pushViewController:pVC animated:YES];
    
}


@end
