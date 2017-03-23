//
//  FavTitleViewController.m
//  Shitan
//
//  Created by 刘敏 on 14/12/16.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FavTitleViewController.h"
#import "CollectionDAO.h"

@interface FavTitleViewController ()<RETableViewManagerDelegate>

@property (strong, readwrite, nonatomic) RETableViewSection *section1;
@property (strong, readwrite, nonatomic) RETextItem *favItem;         //用户名

@property (strong, nonatomic) CollectionDAO *dao;

@end

@implementation FavTitleViewController


- (void)initDAO
{
    if (!_dao) {
        self.dao = [[CollectionDAO alloc] init];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self initDAO];
    
    [self setNavBarTitle:@"修改标题"];
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:0];

    
    //保存按钮
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"保存" target:self action:@selector(saveButtonTapped:)]];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    _manager = [[RETableViewManager alloc] initWithTableView:_tableView delegate:self];
    
    
    self.manager.style.cellHeight = 44.0;
    
    self.section1 = [self addSectionA];

}



#pragma mark 自定义表格
- (RETableViewSection *)addSectionA
{
    // Add sections and items
    RETableViewSection *section = [RETableViewSection section];
    [_manager addSection:section];
    NSMutableArray *collapsedItems = [NSMutableArray array];
    
    self.favItem = [RETextItem itemWithTitle:nil value:_favInfo.title placeholder:@"标题"];
    
    [collapsedItems addObjectsFromArray:@[self.favItem]];
    [section addItemsFromArray:collapsedItems];
    
    return section;
}


- (void)saveButtonTapped:(id)sender{
    
    if ([_favInfo.title isEqualToString:self.favItem.value]) {
        CLog(@"未做修改");
        MET_MIDDLE(@"标题未做修改，无需保存。");
        return;
    }

    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dict setObject:self.favItem.value forKey:@"title"];
    if (self.favInfo.favoriteDesc) {
        [dict setObject:self.favInfo.favoriteDesc forKey:@"favoriteDesc"];
    }
    
    
    [dict setObject:self.favInfo.favoriteId forKey:@"favoriteId"];

    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_dao editFavorite:requestDict
            completionBlock:^(NSDictionary *result) {
                
                if ([[result objectForKey:@"code"] integerValue] == 200)
                {
                    if (_delegate && [_delegate respondsToSelector:@selector(updateFavTitle:)]) {
                        [_delegate updateFavTitle:self.favItem.value];
                    }
                    //返回
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    MET_MIDDLE([result objectForKey:@"msg"]);
                }
                
                
            }
             setFailedBlock:^(NSDictionary *result) {
                 
             }];
    
}


@end
