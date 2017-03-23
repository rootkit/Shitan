//
//  FoodNameViewController.m
//  Artery
//
//  Created by 刘敏 on 14-11-23.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FoodNameViewController.h"
#import "MJRefresh.h"
#import "FoodDAO.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "ChineseInclude.h"


@interface FoodNameViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FoodDAO *dao;
@property (nonatomic, strong) NSMutableArray *tableArray;     //附近的位置数据
@property (nonatomic, strong) NSMutableArray *searchResults;  //搜索源数据

@property (nonatomic, assign) BOOL isSearch;


@end

@implementation FoodNameViewController


- (void)initDAO
{
    if (!_dao) {
        self.dao = [[FoodDAO alloc] init];
    }
    _searchResults = [[NSMutableArray alloc] init];
    _tableArray = [[NSMutableArray alloc] init];
}


- (void)viewWillAppear:(BOOL)animated
{
    //显示
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [theAppDelegate.HUDManager hideHUD];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initDAO];
    
    [self setNavBarTitle:@"美食名"];
    
    [ResetFrame resetScrollView:self.tableview contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];

    _isSearch = NO;
    
    if (isIOS7) {
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        
    }
    else
    {
        //移除搜索框背景
        for (UIView *subview in _searchBar.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subview removeFromSuperview];
                break;
            }
        }
    }
    
//    UIBarButtonItem *addMessageItem =[[UIBarButtonItem alloc] initWithCustomView:[Units navigationItemBtnInitWithNormalImageNamed:@"ia_back.png" andHighlightedImageNamed:nil target:self action:@selector(back:)]];
//    self.navigationItem.leftBarButtonItem = addMessageItem;
    
    
    //搜索
    [self searchKeywordWithFoodName:_pInfo.businessId];
}



- (void)back:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearch) {
        return [_tableArray count] +1;
    }
    return [_tableArray count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if (!_isSearch)
    {
        cell.textLabel.text = [_tableArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    else
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = [@"添加美食名:" stringByAppendingString:_searchBar.text];
            cell.textLabel.textColor = MAIN_COLOR;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.textLabel.text = [_tableArray objectAtIndex:(indexPath.row - 1)];
        }
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_isSearch){
        [self creatFoodName:[_tableArray objectAtIndex:indexPath.row]];
    }
    else
    {
        if (indexPath.row == 0) {
            [self creatFoodName:_searchBar.text];
        }
        else{
            
            //搜索还未完成，_tableArray为空
            if ([_tableArray count] == 0) {
                return;
            }
            
            [self creatFoodName:[_tableArray objectAtIndex:(indexPath.row -1)]];
        }
        
    }
}


// 搜索该商户下得所有菜名
- (void)searchKeywordWithFoodName:(NSString *)businessId
{
    _isSearch = NO;
    
    [_tableArray removeAllObjects];
    [_searchResults removeAllObjects];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    //搜索关键字
    if (!businessId) {
        //光标选中搜索框
        [self performSelector:@selector(popKeyWord) withObject:nil afterDelay:0.4];
        return;
    }
    
    [dict setObject:businessId forKey:@"businessId"];
    
    //发起请求
    [_dao getMerchantsDishes:dict completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            
            NSArray *temp = [result objectForKey:@"obj"];
            
            if ([temp isKindOfClass:[NSArray class]] && [temp count] > 0) {
                [_tableArray addObjectsFromArray:temp];
                [_searchResults addObjectsFromArray:temp];
            }
            else{
                //光标选中搜索框
                [self performSelector:@selector(popKeyWord) withObject:nil afterDelay:0.4];
            }
            [self.tableview reloadData];
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
    } setFailedBlock:^(NSDictionary *result) {
    
    }];
}


- (void)popKeyWord{
    [self.searchBar becomeFirstResponder];
}

// 创建标签
- (void)creatFoodName:(NSString *)name
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:name forKey:@"name"];
    
    [_dao requestNameCreate:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            
            FoodInfo *mInfo = [[FoodInfo alloc] initWithParsData:[result objectForKey:@"obj"]];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
            [dic setObject:_pInfo forKey:@"PlaceInfo"];
            [dic setObject:mInfo forKey:@"FoodInfo"];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_TIPS_PLACE_FOODNAME" object:dic];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
        
    }];
}


#pragma UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _isSearch = YES;
    [_tableArray removeAllObjects];
    
    
    if(searchBar.text.length > 16)
    {
        searchBar.text = [searchText substringToIndex:16];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大可输入长度" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    //模糊搜索
    if (_searchBar.text.length > 0 && ![ChineseInclude isIncludeChineseInString:_searchBar.text])
    {
        for (int i = 0;  i < _searchResults.count; i++)
        {
            if ([ChineseInclude isIncludeChineseInString:_searchResults[i]])
            {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:_searchResults[i]];
                NSRange titleResult = [tempPinYinStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length > 0) {
                    [_tableArray addObject:_searchResults[i]];
                }
                
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:_searchResults[i]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleHeadResult.length > 0) {
                    [_tableArray addObject:_searchResults[i]];
                }
            }
            else
            {
                NSRange titleResult = [_searchResults[i] rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                
                if (titleResult.length > 0) {
                    [_tableArray addObject:_searchResults[i]];
                }
            }
        }
    }
    else if (_searchBar.text.length > 0 && [ChineseInclude isIncludeChineseInString:_searchBar.text])
    {
        for (NSString *tempStr in _searchResults)
        {
            NSRange titleResult = [tempStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0) {
                [_tableArray addObject:tempStr];
            }
        }
    }
    
    if (_searchBar.text.length == 0) {
        //搜索
        [self searchKeywordWithFoodName:_pInfo.businessId];
    }
    
    [self.tableview reloadData];
}



#pragma mark 搜索框事件
//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
