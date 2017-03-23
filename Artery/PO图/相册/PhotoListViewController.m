//
//  PhotoListViewController.m
//  Artery
//
//  Created by RichardLiu on 15/4/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "PhotoListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoViewController.h"
#import "PhotoListCell.h"
#import "PhotoListModel.h"
#import "DMCameraViewController.h"


@interface PhotoListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, weak) IBOutlet UITableView  *tableView;

@end

@implementation PhotoListViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"相册列表"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"相册列表"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    _tableArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    [self setExtraCellLineHidden:_tableView];
    //载入相簿信息
    [self getGroups];
}


- (void)getGroups{
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            if ([group numberOfAssets] > 0) {
                [_tableArray addObject:group];
                
            }
            
            [_tableView reloadData];
        }
    }failureBlock:^(NSError *error) {
        CLog(@"Group not found!\n");
    }];
    
}


//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        //显示
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }];
}

- (IBAction)cameraButtonTapped:(id)sender
{
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"CameraStoryboard" bundle:nil];
    DMCameraViewController * pVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"DMCameraViewController"];
    [self.navigationController pushViewController:pVC animated:YES];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoListCell *cell = [PhotoListModel findCellWithTableView:tableView];
    [cell setCellWithCellInfo:(ALAssetsGroup *)[_tableArray objectAtIndex:indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"CameraStoryboard" bundle:nil];
    PhotoViewController * pVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
//    pVC.group=((ALAssetsGroup *)[_tableArray objectAtIndex:indexPath.row]);
    [self.navigationController pushViewController:pVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
