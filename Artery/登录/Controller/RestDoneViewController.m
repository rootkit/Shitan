//
//  RestDoneViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-11-19.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "RestDoneViewController.h"
#import "MD5Hash.h"
#import "AccountDAO.h"
#import "ContactsManager.h"

@interface RestDoneViewController ()<RETableViewManagerDelegate>

@property (strong, readwrite, nonatomic) RETableViewSection *section1;

@property (strong, readwrite, nonatomic) RETextItem *codeItem;
@property (strong, readwrite, nonatomic) RETextItem *passwordItem;

@property (strong, nonatomic) AccountDAO *dao;


@end

@implementation RestDoneViewController


- (void)initDao
{
    if (!_dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(_phoneType == STBindingMobileType || _phoneType == STAddAddressBook)
    {
        [self setNavBarTitle:@"设置密码"];
        [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"绑定" target:self action:@selector(bingButtonTapped:)]];
    }
    else{
        [self setNavBarTitle:@"重置密码"];
        [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"重置" target:self action:@selector(doneButtonTapped:)]];
    }
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];

    
    self.tableView.backgroundView = nil;
    
    _manager = [[RETableViewManager alloc] initWithTableView:_tableView delegate:self];
    
    
    self.manager.style.cellHeight = 44.0;
    
    self.section1 = [self addSectionA];
    
    [self initDao];
    
}

- (void)doneButtonTapped:(id)sender
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
    
    //重置密码
    [self restPassword];
}


//绑定手机
- (void)bingButtonTapped:(id)sender
{
    if (self.codeItem.value.length != 4) {
        MET_MIDDLE(@"验证码输入不正确");
        return;
    }

    
    NSMutableDictionary *verDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [verDict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [verDict setObject:[AccountInfo sharedAccountInfo].mobileprefix forKey:@"mobilePrefix"];
    [verDict setObject:theAppDelegate.phone forKey:@"mobile"];
    [verDict setObject:self.codeItem.value forKey:@"code"];
    [verDict setObject:[MD5Hash getMd5_32Bit_String:self.passwordItem.value] forKey:@"pwd"];
    
    [AccountInfo sharedAccountInfo].pwd = [MD5Hash getMd5_32Bit_String:self.passwordItem.value];
    
    NSString* jsonString = [STJSONSerialization toJSONData:verDict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [requestDict setObject:self.codeItem.value forKey:@"code"];
    
    
    
    //绑定操作
    [_dao requestBindMobile:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            MET_MIDDLE(@"绑定成功");
            [[AccountInfo sharedAccountInfo] parsAccountData:[result objectForKey:@"obj"]];
            
            if (_phoneType == STBindingMobileType) {
                //上传通讯录
                [[ContactsManager shareInstance] loadContacts];
                
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
            else if(_phoneType == STAddAddressBook)
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BINDPHONE" object:nil];
            }
            
            
        }
        else{
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        MET_MIDDLE([result objectForKey:@"msg"]);
    }];

}



- (void)restPassword{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dic setObject:[AccountInfo sharedAccountInfo].mobileprefix forKey:@"mobilePrefix"];
    [dic setObject:theAppDelegate.phone forKey:@"mobile"];
    [dic setObject:self.codeItem.value forKey:@"code"];
    [dic setObject:[AccountInfo sharedAccountInfo].pwd forKey:@"pwd"];
    
    
    [_dao requestRestPassword:dic completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200){
            //注册之后需要创建Token值
            [[AccountInfo sharedAccountInfo] parsAccountData:[result objectForKey:@"obj"]];
            
            //跳转到首页
            [theAppDelegate loginSuccess];
            
            [self dismissViewControllerAnimated:YES completion:NULL];
            
            MET_MIDDLE(@"密码修改成功，已使用新密码登录");
            
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        
        
    }];
    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
