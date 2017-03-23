//
//  CollectionTypeViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-10-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CollectionTypeViewController.h"
#import "CollectionDAO.h"
#import "FavInfo.h"
#import "CollectionCell.h"
#import "CollectionModel.h"
#import "FavoriteCreateViewController.h"

@interface CollectionTypeViewController ()

@property (strong, nonatomic) CollectionDAO *dao;
@property (strong, nonatomic) NSMutableArray *favArray;    //收藏夹列表
@property (strong, nonatomic) FavInfo *favInfo;

@end

@implementation CollectionTypeViewController

- (void)initDao
{
    if (!self.dao) {
        self.dao = [[CollectionDAO alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self FavoriteList];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _favArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setNavBarTitle:@"收藏夹"];
    
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"icon_close.png" imgHighlight:nil imgSelected:nil target:self action:@selector(back:)]];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self initDao];
    // Do any additional setup after loading the view.
    
    [self setExtraCellLineHidden:_tableView];
}


//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//获取收藏夹
- (void)FavoriteList{
    
    //清空数组
    [_favArray removeAllObjects];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    
    [_dao getFavoriteList:dic
          completionBlock:^(NSDictionary *result) {
              if ([[result objectForKey:@"code"] integerValue] == 200 ) {
                  if ([result objectForKey:@"obj"]) {
                      NSArray *tempArray = [result objectForKey:@"obj"];
                      [_favArray addObjectsFromArray:tempArray];
                      NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:1];
                      [tempDic setObject:@"创建新收藏夹" forKey:@"title"];
                      [_favArray addObject:tempDic];
                      [_tableView reloadData];
                  }
              }
              else
              {
                  MET_MIDDLE([result objectForKey:@"msg"]);
              }
        
          }
           setFailedBlock:^(NSDictionary *result) {
        
    }];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _favArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 64;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CollectionCell *cell = [CollectionModel findCellWithTableView:tableView];
    _favInfo = [[FavInfo alloc] initWithParsData:[_favArray objectAtIndex:row]];
    [cell setCellWithCellInfo:_favInfo];
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [_favArray count]-1) {
        
        UIStoryboard *mineStroyboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
        
        FavoriteCreateViewController *favoriteCreateVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"FavoriteCreateViewController"];
        favoriteCreateVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:favoriteCreateVC animated:YES];
    }
    else{
        FavInfo *fInfo = [[FavInfo alloc] initWithParsData:[_favArray objectAtIndex:indexPath.row]];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [dic setObject:fInfo.favoriteId forKey:@"favoriteId"];
        [dic setObject:_imageId forKey:@"imgId"];
        
        NSString* jsonString = [STJSONSerialization toJSONData:dic];
        
        NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [requestDict setObject:jsonString forKey:@"reqStr"];
        
        [self collectionImageWithFavoriteId:requestDict];
    }
}


- (void)collectionImageWithFavoriteId:(NSDictionary *)dic
{
    [_dao collectionImageWithInfo:dic
                  completionBlock:^(NSDictionary *result) {
                      CLog(@"%@", result);
                      if ([[result objectForKey:@"code"] integerValue] == 200 ) {
                          
                          [self.navigationController popViewControllerAnimated:NO];
                          
                      }
                      if ([[result objectForKey:@"code"] integerValue] == 500)
                      {
                          MET_MIDDLE([result objectForKey:@"msg"]);
                      }

                      
                  } setFailedBlock:^(NSDictionary *result) {
                      CLog(@"%@", result);
                  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
