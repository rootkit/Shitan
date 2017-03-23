//
//  SetPasswordViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-9-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "FillInformationViewController.h"
#import "MD5Hash.h"
#import "AccountDAO.h"



@interface SetPasswordViewController ()<RETableViewManagerDelegate>

@property (strong, readwrite, nonatomic) RETableViewSection *section1;

@property (strong, readwrite, nonatomic) RETextItem *codeItem;
@property (strong, readwrite, nonatomic) RETextItem *passwordItem;

@property (strong, nonatomic) AccountDAO* dao;

@end

@implementation SetPasswordViewController


- (void)initDao
{
    if (!_dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initDao];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"下一步" target:self action:@selector(nextButtonTapped:)]];
    
    [self setNavBarTitle:@"设置密码"];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:0];
    
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
    
    self.codeItem = [RETextItem itemWithTitle:@"验证码" value:nil placeholder:@"请输入收到的验证码"];
    
    self.passwordItem = [RETextItem itemWithTitle:@"密码" value:nil placeholder:@"6-16位字符，区分大小写"];
    self.passwordItem.secureTextEntry = YES;
    
    [collapsedItems addObjectsFromArray:@[self.codeItem, self.passwordItem]];
    [section addItemsFromArray:collapsedItems];
    
    return section;
}


- (void)nextButtonTapped:(id)sender
{
    
    if(self.codeItem.value.length!= 4)
    {
        MET_MIDDLE(@"验证码格式错误,请重新填写");
        return;
    }


    
    if ([self.passwordItem.value length] < 6) {
        MET_MIDDLE(@"密码长度过短，请重新输入密码");
        return;
    }
    
    [AccountInfo sharedAccountInfo].pwd = [MD5Hash getMd5_32Bit_String:self.passwordItem.value];
    
    [self requestVerificationCode];

}


//验证验证码是否正确
- (void)requestVerificationCode
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dict setObject:[AccountInfo sharedAccountInfo].mobileprefix forKey:@"mobilePrefix"];
    [dict setObject:theAppDelegate.phone forKey:@"mobile"];
    [dict setObject:_codeItem.value forKey:@"code"];
    
    
    [_dao requestCheckverificationCode:dict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            [self performSegueWithIdentifier:@"填写资料" sender:self];
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

@end
