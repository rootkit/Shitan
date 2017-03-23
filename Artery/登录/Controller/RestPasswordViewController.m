//
//  RestPasswordViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-9-15.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "RestPasswordViewController.h"
#import "REViewOptionsController.h"
#import "RestDoneViewController.h"
#import "AccountInfo.h"
#import "AccountDAO.h"

@interface RestPasswordViewController ()<RETableViewManagerDelegate>

@property (strong, readwrite, nonatomic) RETableViewSection *section1;

@property (strong, readwrite, nonatomic) RERadioItem *countriesItem;
@property (strong, readwrite, nonatomic) RENumberItem *phoneName;

@property (strong, readwrite, nonatomic) AccountDAO *dao;

@end

@implementation RestPasswordViewController


- (void)initDao
{
    if (!self.dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDao];
    
    [self setNavBarTitle:@"输入手机号码"];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"下一步" target:self action:@selector(nextButtonTapped:)]];
    
    _manager = [[RETableViewManager alloc] initWithTableView:_tableView delegate:self];
    
    
    self.manager.style.cellHeight = 44.0;
    
    self.section1 = [self addSectionA];
}

- (void)nextButtonTapped:(id)sender
{
    if ([self.phoneName.value length] < 8){
        MET_MIDDLE(@"请输入正确的手机号码");
        return;
    }
    // 区号（国家编码）
    NSString *code = [NSString stringWithFormat:@"%@", [[self.countriesItem.value componentsSeparatedByString:@"+"] objectAtIndex:1]];
    // 提示内容
    NSString *content = [NSString stringWithFormat:@"我们将发送验证码到这个号码：\n%@ %@", code, self.phoneName.value];
    
    AlertWithTitleAndMessageAndUnits(@"确认手机号码", content, self, @"确定",nil);
    
    [self resignFirstResponder];
    
    
    //手机号码
    theAppDelegate.phone = self.phoneName.value;
    [AccountInfo sharedAccountInfo].mobileprefix = code;
}


#pragma mark 自定义表格
- (RETableViewSection *)addSectionA
{
    __typeof (&*self) __weak weakSelf = self;
    
    // Add sections and items
    RETableViewSection *section = [RETableViewSection section];
    [_manager addSection:section];
    NSMutableArray *collapsedItems = [NSMutableArray array];
    
    // 选择国家或者区域
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"National" ofType:@"plist"];
    NSArray *pArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    self.countriesItem = [RERadioItem itemWithTitle:nil value:@"中国 +86" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        
        // Generate sample options
        NSMutableArray * sArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *key in pArray) {
            [sArray addObject:[key objectForKey:@"NAME"]];
        }
        
        
        
        // Present options controller
        REViewOptionsController *optionsControllerA = [[REViewOptionsController alloc]
                                                       initWithItem:item options:sArray
                                                       multipleChoice:NO
                                                       completionHandler:^{
                                                           [weakSelf.navigationController popViewControllerAnimated:YES];
                                                           
                                                           [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                       }];

        optionsControllerA.delegate = weakSelf;
        optionsControllerA.style = section.style;
        optionsControllerA.title = @"选择国家或地区";
        
        
        if (weakSelf.tableView.backgroundView == nil) {
            optionsControllerA.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsControllerA.tableView.backgroundView = nil;
        }
        
        // Push the options controller
        //
        [weakSelf.navigationController pushViewController:optionsControllerA animated:YES];
    }];
    
    
    self.phoneName = [RENumberItem itemWithTitle:nil value:nil placeholder:@"手机号码"];
    
    [collapsedItems addObjectsFromArray:@[self.countriesItem, self.phoneName]];
    [section addItemsFromArray:collapsedItems];
    
    return section;
}

#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.cancelButtonIndex != buttonIndex) {
		if (buttonIndex == 1) {
            
            NSString *code = [NSString stringWithFormat:@"%@", [[self.countriesItem.value componentsSeparatedByString:@"+"] objectAtIndex:1]];
            
            NSMutableDictionary *verDict = [[NSMutableDictionary alloc] initWithCapacity:2];
            
            //TODO：不能写死
            [verDict setObject:code forKey:@"mobilePrefix"];
            [verDict setObject:self.phoneName.value forKey:@"mobile"];
            
            
            //检测手机号码是否被注册
            [_dao requestMobileIsRegister:verDict completionBlock:^(NSDictionary *result) {
                if ([[result objectForKey:@"code"] integerValue] == 200)
                {
                    CLog(@"%@", [result objectForKey:@"obj"]);
                    BOOL mobileIsRegisted = [[[result objectForKey:@"obj"] objectForKey:@"mobileIsRegisted"] boolValue];
                    
                    
                    //绑定手机（未注册的手机）
                    if (_phoneType == STBindingMobileType || _phoneType == STAddAddressBook) {
                        if (mobileIsRegisted) {
                            
                            MET_MIDDLE(@"手机号码已被注册");
                        }
                        else
                        {
                            //请求手机短信验证码
                            [self requestVerificationCode:verDict];
                        }
                    }
                    else{
                        //使用已注册的手机
                        if (mobileIsRegisted) {
                            //请求手机短信验证码
                            [self requestVerificationCode:verDict];
                        }
                        else
                        {
                            MET_MIDDLE(@"手机号码未注册");
                        }
                    }

                }
                
            } setFailedBlock:^(NSDictionary *result) {
                
            }];

   		}
		else if(buttonIndex == 0){
            CLog(@"退出");
		}
	}
    else{
        CLog(@"退出");
    }
}



// 获取验证码
- (void)requestVerificationCode:(NSDictionary *)dict
{
    [_dao requestVerificationCode:dict
                  completionBlock:^(NSDictionary *result)
    {
        if ([[result objectForKey:@"code"] integerValue] == 200){
            
            UIStoryboard *mStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
            RestDoneViewController *hVC = [mStoryboard instantiateViewControllerWithIdentifier:@"RestDoneViewController"];
            hVC.phoneType = _phoneType;
            
            [self.navigationController pushViewController:hVC animated:YES];
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
    }setFailedBlock:^(NSDictionary *result){
       
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
