//
//  MarkViewController.m
//  Artery
//
//  Created by 刘敏 on 14-9-25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//
//  载入自定义的标签记录

#import "MarkViewController.h"
#import "MarkDAO.h"
#import "MarkPlistOperation.h"


@interface MarkViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MarkDAO *dao;
@property (nonatomic, strong) NSMutableArray *tableArray; //历史数据
@property (nonatomic, assign) BOOL isSearch;      //是否搜索

@end

@implementation MarkViewController


- (void)initDao{
    if (!_dao) {
        self.dao = [[MarkDAO alloc] init];
    }
    _tableArray = [[NSMutableArray alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [theAppDelegate.HUDManager hideHUD];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //显示
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavBarTitle:@"选择标签"];
    
    [ResetFrame resetScrollView:self.tableview contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"icon_close.png" imgHighlight:@"icon_close.png" target:self action:@selector(back:)]];
    
    _isSearch = NO;
    [self initDao];
    // Do any additional setup after loading the view from its nib.
    
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
    
    NSArray *temp = [MarkPlistOperation readPlist];
    
    if(!temp)
    {
        [self.searchBar becomeFirstResponder];
    }
    else{
        [_tableArray addObjectsFromArray:temp];
    }
}


//取消
- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if(_isSearch)
    {
        return [_tableArray count] + 1;
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
        if ([[_tableArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
            MarkInfo *mInfo = [[MarkInfo alloc] initWithParsData:[_tableArray objectAtIndex:indexPath.row]];
            cell.textLabel.text = mInfo.rawTag;
        }
        else
            cell.textLabel.text = [_tableArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    else
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = [@"添加标签:" stringByAppendingString:_searchBar.text];
            cell.textLabel.textColor = MAIN_COLOR;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            if ([[_tableArray objectAtIndex:(indexPath.row - 1)] isKindOfClass:[NSDictionary class]]) {
                MarkInfo *mInfo = [[MarkInfo alloc] initWithParsData:[_tableArray objectAtIndex:(indexPath.row - 1)]];
                cell.textLabel.text = mInfo.rawTag;
            }
            else
                cell.textLabel.text = [_tableArray objectAtIndex:(indexPath.row - 1)];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_searchBar resignFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_isSearch){
        if ([[_tableArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
            MarkInfo *mInfo = [[MarkInfo alloc] initWithParsData:[_tableArray objectAtIndex:indexPath.row]];
            
            if (_delegate && [_delegate respondsToSelector:@selector(markViewControllerSelected:)]) {
                [_delegate markViewControllerSelected:mInfo];
                [self back:nil];
            }
        }
    }
    else
    {
        if (indexPath.row == 0) {
            [self creatMarkWithTag:_searchBar.text];
        }
        else
        {
            //搜索还未完成，_tableArray为空
            if ([_tableArray count] == 0) {
                return;
            }
            
            if ([[_tableArray objectAtIndex:(indexPath.row - 1)] isKindOfClass:[NSDictionary class]]) {
                MarkInfo *mInfo = [[MarkInfo alloc] initWithParsData:[_tableArray objectAtIndex:(indexPath.row - 1)]];
                
                if (_delegate && [_delegate respondsToSelector:@selector(markViewControllerSelected:)]) {
                    [_delegate markViewControllerSelected:mInfo];
                    [self writePlistData:mInfo];
                    [self back:nil];
                }
            }
        }

    }
}


- (void)writePlistData:(MarkInfo *)mInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (mInfo.rawTag) {
        [dict setObject:mInfo.rawTag forKey:@"rawTag"];
    }
    
    if (mInfo.rawId) {
        [dict setObject:mInfo.rawId forKey:@"rawId"];
    }

    [dict setObject:[NSNumber numberWithInteger:mInfo.mId] forKey:@"id"];

    [MarkPlistOperation writePlist:dict];
}

// 搜索标签
- (void)searchMarkWithTag:(NSString *)keyword
{
    [_tableArray removeAllObjects];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    //搜索关键字
    if (keyword) {
        [dict setObject:keyword forKey:@"keyword"];
    }
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [dict setObject:[NSNumber numberWithInt:30] forKey:@"size"];
    
    //封装
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    //发起请求
    [_dao requestSearchMark:requestDict completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            
            NSArray *temp = [result objectForKey:@"obj"];
            
            if ([temp isKindOfClass:[NSArray class]] && [temp count] > 0) {
                [_tableArray addObjectsFromArray:temp];
            }
            else{
                [self.searchBar becomeFirstResponder];
            }
            
        }
        else{
            [self.searchBar becomeFirstResponder];
        }
        
        [self.tableview reloadData];
        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
    
}


// 创建标签
- (void)creatMarkWithTag:(NSString *)tag
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:tag forKey:@"rawTag"];
    
    
    [_dao requestCreateMark:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            
            MarkInfo *mInfo = [[MarkInfo alloc] initWithParsData:[result objectForKey:@"obj"]];
            
            if (_delegate && [_delegate respondsToSelector:@selector(markViewControllerSelected:)]) {
                [_delegate markViewControllerSelected:mInfo];
                
                [self writePlistData:mInfo];
                
                [self back:nil];
            }

        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
        
    }];

}



#pragma mark 搜索框事件
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _isSearch = YES;
    
    if(searchBar.text.length > 16)
    {
        searchBar.text = [searchText substringToIndex:16];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大可输入长度" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    CLog(@"%@", searchBar.text);
    [_tableArray removeAllObjects];
    
    if (searchBar.text.length == 0) {
        _isSearch = NO;
    }
    
    if (searchBar.text.length > 0)
    {
        //实时请求
        [self searchMarkWithTag:searchBar.text];
    }
    else{
        NSArray *temp = [MarkPlistOperation readPlist];
        
        if(temp)
        {
            [_tableArray addObjectsFromArray:temp];
            [_tableview reloadData];
        }
    }
}



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
