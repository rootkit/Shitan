//
//  GroupListViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "GroupListViewController.h"
#import "GroupInfo.h"
#import "GroupCell.h"
#import "GroupModel.h"
#import "DPWebViewController.h"


@interface GroupListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"本店团购"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (isIOS8){
        [tableView setFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height+20)];
    }
    else{
         [tableView setFrame:CGRectMake(0, 20, MAINSCREEN.size.width, MAINSCREEN.size.height)];
    }

    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:tableView];
    
    [ResetFrame resetScrollView:tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
 
    [self setExtraCellLineHidden:tableView];
}


//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
    
    return _tableArray.count;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCell *cell = [GroupModel findCellWithTableView:tableView];
    GroupInfo *gInfo = _tableArray[indexPath.row];
    [cell setCellWithCellInfo:gInfo];
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupInfo *gInfo = _tableArray[indexPath.row];
    
    DPWebViewController *dVC = (DPWebViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[DPWebViewController class]];
    dVC.urlSting = [NSString stringWithFormat:@"%@?uid=%@", gInfo.deal_h5_url, [AccountInfo sharedAccountInfo].userId];
    dVC.titName = gInfo.title;
    
    [self.navigationController pushViewController:dVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
