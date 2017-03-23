//
//  TextFieldEditViewController.m
//  Shitan
//
//  Created by Jia HongCHI on 14-10-10.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "TextFieldEditViewController.h"
#import "AccountDAO.h"
#import "EmojiConvertor.h"

@interface TextFieldEditViewController ()<RETableViewManagerDelegate>

@property (strong, readwrite, nonatomic) AccountDAO *dao;

@property (strong, readwrite, nonatomic) RETableViewSection *section1;
@property (strong, readwrite, nonatomic) RETextItem *ueserName;         //用户名

@property (nonatomic, strong) EmojiConvertor *emojiCon;
@end

@implementation TextFieldEditViewController

- (void)initDao
{
    if (!self.dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDao];
    
    [self setNavBarTitle:_editTitle];
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:0];
    
    //表情转码
    self.emojiCon = [[EmojiConvertor alloc] init];
    
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

    self.ueserName = [RETextItem itemWithTitle:nil value:[AccountInfo sharedAccountInfo].nickname placeholder:@"昵称"];
    
    [collapsedItems addObjectsFromArray:@[self.ueserName]];
    [section addItemsFromArray:collapsedItems];
    
    return section;
}


- (void)saveButtonTapped:(id)sender{
    
    if(self.ueserName.value.length > 15)
    {
        MET_MIDDLE(@"昵称不能大于15个字符");
        
        return;
    }
    
    if ([_ueserName.value isEqualToString:[AccountInfo sharedAccountInfo].nickname]) {
        CLog(@"未做修改");
        MET_MIDDLE(@"昵称未做修改，无需保存。");
        return;
    }
    
    if ([_ueserName.value isEqualToString:@""]) {
        CLog(@"昵称不能为空");
        MET_MIDDLE(@"昵称不能为空!");
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    if ([_editTitle isEqual:@"昵称"]) {
        //去掉首尾空格
        NSString *tempString = [_ueserName.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [dict setObject:[self.emojiCon convertEmojiUnicodeToSoftbank:tempString] forKey:@"nickname"];
    }
    else if([_editTitle isEqual:@"姓名"])
    {
        [dict setObject:_ueserName.value forKey:@"name"];
    }
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_dao requestUserUpdate:requestDict
          completionBlock:^(NSDictionary *result) {
              
              if ([[result objectForKey:@"code"] integerValue] == 200)
              {
                  //跟新用户信息
                  [AccountInfo sharedAccountInfo].nickname = _ueserName.value;                  
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
