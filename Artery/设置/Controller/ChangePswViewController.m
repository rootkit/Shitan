//
//  ChangePswViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-11-11.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ChangePswViewController.h"
#import "AccountDAO.h"
#import "MD5Hash.h"

@interface ChangePswViewController ()<RETableViewManagerDelegate>

@property (strong, readwrite, nonatomic) RETableViewSection *section1;
@property (strong, readwrite, nonatomic) RETextItem *oldPSW;         //老密码
@property (strong, readwrite, nonatomic) RETextItem *theNewPSW;
@property (strong, readwrite, nonatomic) RETextItem *reNewPSW;

@property (strong, readwrite, nonatomic) AccountDAO *dao;

@end

@implementation ChangePswViewController

- (void)initDao
{
    if (!self.dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"修改密码"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改密码"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    [self initDao];
    
    [self setNavBarTitle:@"修改密码"];
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:1 inidcatorInsetStatusBarHeight:0];

    
    //保存按钮
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"确定" target:self action:@selector(saveButtonTapped:)]];
    
    self.tableView.backgroundView = nil;
    
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
    
    self.oldPSW = [RETextItem itemWithTitle:@"旧密码" value:nil placeholder:nil];
    self.theNewPSW = [RETextItem itemWithTitle:@"新密码" value:nil placeholder:@"6-16位，区分大小写"];
    self.reNewPSW = [RETextItem itemWithTitle:@"重复新密码" value:nil placeholder:@"6-16位，区分大小写"];
    self.oldPSW.secureTextEntry = YES;
    self.theNewPSW.secureTextEntry = YES;
    self.reNewPSW.secureTextEntry = YES;
    
    [collapsedItems addObjectsFromArray:@[self.oldPSW, self.theNewPSW, self.reNewPSW]];
    [section addItemsFromArray:collapsedItems];
    
    return section;
}



- (void)saveButtonTapped:(id)sender{
    
    if (!self.oldPSW.value || !self.theNewPSW.value || !self.reNewPSW.value) {
        MET_MIDDLE(@"密码不能为空");
        return;
    }
    
    if (![[AccountInfo sharedAccountInfo].pwd isEqualToString:[MD5Hash getMd5_32Bit_String:self.oldPSW.value]]) {
        MET_MIDDLE(@"旧密码错误，请重新输入");
        self.oldPSW.value = nil;
        [_tableView reloadData];
        
        return;
    }
    
    if (![self.theNewPSW.value isEqualToString:self.reNewPSW.value]) {
        MET_MIDDLE(@"两次新密码输入不一致，请重新输入");
        self.reNewPSW.value = nil;
        [_tableView reloadData];
        
        return;
    }

    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dict setObject:[MD5Hash getMd5_32Bit_String:self.reNewPSW.value] forKey:@"pwd"];
    

    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_dao requestUserUpdate:requestDict
            completionBlock:^(NSDictionary *result) {
                
                if ([[result objectForKey:@"code"] integerValue] == 200)
                {
                    MET_MIDDLE(@"密码修改成功，请重新登录");
                    [theAppDelegate loginOut];
                }
                else
                {
                    MET_MIDDLE([result objectForKey:@"msg"]);
                }
                
            }
             setFailedBlock:^(NSDictionary *result) {
                 
             }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
