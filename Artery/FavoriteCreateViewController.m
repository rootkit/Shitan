//
//  FavoriteCreateViewController.m
//  Shitan
//
//  Created by Jia HongCHI on 14-10-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FavoriteCreateViewController.h"
#import "CollectionDAO.h"

@interface FavoriteCreateViewController ()<RETableViewManagerDelegate>

@property (strong, readwrite, nonatomic) RETableViewSection *section1;

@property (strong, readwrite, nonatomic) RETextItem *titleItem;
@property (strong, readwrite, nonatomic) RELongTextItem *desItem;

@property (strong, readwrite, nonatomic) CollectionDAO *collectionDAO;

@end

@implementation FavoriteCreateViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"创建收藏夹"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"创建收藏夹"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavBarTitle:@"添加收藏夹"];
    
    [self initDao];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:0];
        
    _tableView.backgroundColor = BACKGROUND_COLOR;
    
    //保存按钮
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"保存" target:self action:@selector(saveButtonTapped:)]];
    
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
    
    
    self.titleItem = [RETextItem itemWithTitle:nil value:nil placeholder:@"标题"];
    self.titleItem.cellHeight = 44.0;
    
    self.desItem = [RELongTextItem itemWithValue:nil placeholder:@"简介"];
    self.desItem.cellHeight = 120.0;

    
    
    
    [collapsedItems addObjectsFromArray:@[self.titleItem, self.desItem]];
    [section addItemsFromArray:collapsedItems];
    
    return section;
}




- (void)saveButtonTapped:(id)sender{
    
    if ([self.titleItem.value length] < 1) {
        MET_MIDDLE(@"标题不能为空!");
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dict setObject:self.titleItem.value forKey:@"title"];
    if (self.desItem.value && [self.desItem.value length] > 0) {
        [dict setObject:self.desItem.value forKey:@"favoriteDesc"];
    }
    
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_collectionDAO createCollection:requestDict completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
//            NSArray *testArray = [result objectForKey:@""];
            [self.navigationController popViewControllerAnimated:YES];

        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
    } setFailedBlock:^(NSDictionary *result) {
       
    }];

}



//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [_favoriteTitle resignFirstResponder];
//    [_favoriteDesc resignFirstResponder];
//}

#pragma mark - request
- (void)initDao
{
    if (!self.collectionDAO) {
        self.collectionDAO = [[CollectionDAO alloc] init];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
