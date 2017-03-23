//
//  AddressBookViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-11-5.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "AddressBookViewController.h"
#import "UserRelationshipDAO.h"
#import <MessageUI/MessageUI.h>
#import "UIColor+Extension.h"
#import "HimselfViewController.h"
#import "ProfileTableViewController.h"
#import "PersonalInfo.h"
#import "RestPasswordViewController.h"
#import "KeyChainUUID.h"
#import "ContactsManager.h"
#import "ContactInfo.h"
#import "AddressBookModel.h"
#import "AddressBookTableViewCell.h"


@interface AddressBookViewController ()<MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, AddressBookCellDelegate>

@property (nonatomic, strong) UserRelationshipDAO *dao;

@property (strong, nonatomic) NSMutableArray *allArray;
@property (strong, nonatomic) NSMutableArray *bookArray;        //通讯录（改变后）
@property (strong, nonatomic) NSMutableArray *contactArray;     //处理之后的通讯录(后台返回的数据)

@property (strong, nonatomic) NSMutableArray *phoneArray;       //专门存储手机号码


- (void)loadContacts;

@end

@implementation AddressBookViewController


- (void)initDAO
{
    if (!_dao) {
        self.dao = [[UserRelationshipDAO alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"通讯录好友"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"通讯录好友"];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDAO];
    
    [self setNavBarTitle:@"通讯录好友"];
    
    _contactArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindPhone) name:@"BINDPHONE" object:nil];
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:0];

    
    // Do any additional setup after loading the view.
    self.bookArray = [[NSMutableArray alloc] init];
    
    [self setExtraCellLineHidden:self.tableView];
    
    //读取通讯录
    [self loadContacts];

    
    if(![AccountInfo sharedAccountInfo].mobile)
    {
        [self addPromptView];
    }
    else{
        [theAppDelegate.HUDManager showSimpleTip:@"加载中..." interval:NSNotFound];
        //获取通信录列表（服务端）
        [self performSelector:@selector(uploadAddressBook:) withObject:_allArray afterDelay:0.2];
    }
}


//消息事件（绑定手机）
- (void)bindPhone
{
    [self removePromptView];
    
    [theAppDelegate.HUDManager showSimpleTip:@"加载中..." interval:NSNotFound];
    //上传通讯录
    [self uploadAddressBook:_allArray];
}


//增加提示语句
- (void)addPromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (!titLabel) {
        titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, MAINSCREEN.size.width, 30)];
        titLabel.text = @"尚未绑定手机";
        [titLabel setFont:[UIFont systemFontOfSize:14.0]];
        [titLabel setTextColor:MAIN_TIME_COLOR];
        titLabel.textAlignment = NSTextAlignmentCenter;
        titLabel.tag = 0x128;
    }
    [self.tableView addSubview:titLabel];
    
    
    UIButton *findButton = (UIButton *)[self.view viewWithTag:0x256];
    if (!findButton) {
        findButton = [[UIButton alloc] initWithFrame:CGRectMake((MAINSCREEN.size.width-160)/2, 190, 160, 36)];
        [findButton setBackgroundImage:@"bg_btn_160_72.png" setSelectedBackgroundImage:@"bg_btn_160_72.png"];
        [findButton setTitle:@"绑定手机" forState:UIControlStateNormal];
        [findButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [findButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [findButton addTarget:self action:@selector(bindButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        findButton.tag = 0x256;
    }
    [self.tableView addSubview:findButton];
}

//删除提示语句
- (void)removePromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (titLabel) {
        [titLabel removeFromSuperview];
    }
    
    UIButton *findButton = (UIButton *)[self.view viewWithTag:0x256];
    if (findButton) {
        [findButton removeFromSuperview];
    }
    
}

//绑定手机
- (void)bindButtonTapped:(id)sender
{
    //绑定手机
    UIStoryboard *mStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    RestPasswordViewController *hVC = [mStoryboard instantiateViewControllerWithIdentifier:@"RestPasswordViewController"];
    hVC.phoneType = STAddAddressBook;
    
    [self.navigationController pushViewController:hVC animated:YES];
}

//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


// 导入通讯录
-(void)loadContacts
{
    [_bookArray removeAllObjects];
    
    
    CFErrorRef error;
    ABAddressBookRef myAddressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (!myAddressBook)
    {
        CLog(@"get addressBook failed:%@", error);
        CFRelease(error);
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, MAINSCREEN.size.width-40, 100)];
        label1.font = [UIFont systemFontOfSize:14.0f];
        label1.numberOfLines = 3;
        label1.text = @"获取通讯录失败,请到设置-隐私-通讯录目录下打开相关权限";
        label1.textColor = [UIColor lightGrayColor];
        label1.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label1];
        
        return;
    }
    else
    {
        ABAddressBookRequestAccessWithCompletion(myAddressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     if (granted)
                                                     {
                                                         NSLog(@"granted");
                                                     }
                                                     else
                                                     {
                                                         NSLog(@"%@", error);
                                                         CFRelease(error);
                                                     }
                                                 });
    }
    
    
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(myAddressBook);
    CFMutableArrayRef mresults=CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                                        CFArrayGetCount(results),
                                                        results);
    //将结果按照拼音排序，将结果放入mresults数组中
    CFArraySortValues(mresults,
                      CFRangeMake(0, CFArrayGetCount(results)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void *) ABPersonGetSortOrdering());

    
    
    _phoneArray = [[NSMutableArray alloc] init];
    
    //遍历所有联系人
    for (int k=0; k<CFArrayGetCount(mresults); k++) {
        
        ABRecordRef record=CFArrayGetValueAtIndex(mresults,k);
        NSString *personname = (__bridge NSString *)ABRecordCopyCompositeName(record);
        
        ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
        
        //一个人可能有多个号码
        NSMutableArray *sArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            
            if ([personPhone length] > 4) {
                
                NSRange range = NSMakeRange(0,3);
                NSString *str = [personPhone substringWithRange:range];
                
                if ([str isEqualToString:@"+86"]) {
                    personPhone = [personPhone substringFromIndex:3];
                }
                
                //删除分隔符
                personPhone = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                [sArray addObject:personPhone];
            }
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        CLog(@"%@", sArray);
        
        //必须同时有姓名跟号码
        if (personname && sArray.count > 0) {
            
            for (NSString *phone in sArray)
            {
                if ([[AccountInfo sharedAccountInfo].mobile isEqualToString:phone]) {
                    break;
                }
                
                [dict setObject:personname forKey:@"name"];
                [dict setObject:sArray forKey:@"phone"];
                
                [_phoneArray addObjectsFromArray:sArray];
                [_bookArray addObject:dict];
                
                break;
            }
        }
    }
    _allArray = [[NSMutableArray alloc] initWithArray:_bookArray];
}



- (void)matchAddressBook
{
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:2];
    //设备唯一标识（UUID）
    [requestDict setObject:[KeyChainUUID Value] forKey:@"deviceId"];
    [requestDict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];

    [_dao requestInviteFrendsWithPhone:requestDict completionBlock:^(NSDictionary *result) {
        
        [theAppDelegate.HUDManager hideHUD];
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            
            NSArray *temp = [result objectForKey:@"obj"];
            if (temp && [temp count] > 0) {

                //筛选用户（已注册的为关注，未注册的邀请）
                [_contactArray removeAllObjects];
                [self.contactArray addObjectsFromArray:[result objectForKey:@"obj"]];
                
                [self.tableView reloadData];
            }
            else
            {
                UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x1024];
                if (!titLabel) {
                    titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, MAINSCREEN.size.width, 30)];
                    titLabel.textAlignment = NSTextAlignmentCenter;
                    titLabel.tag = 0x1024;
                }
                
                titLabel.text = @"无数据";
                [titLabel setFont:[UIFont systemFontOfSize:18.0]];
                [titLabel setTextColor:[UIColor lightGrayColor]];
                [self.tableView addSubview:titLabel];

            }

        }
        else{
            [theAppDelegate.HUDManager hideHUD];
            if([result objectForKey:@"msg"] != [NSNull null])
            {
                MET_MIDDLE([result objectForKey:@"msg"]);
            }
            
        }
    } setFailedBlock:^(NSDictionary *result){
        
    }];
}




//上传通讯录
- (void)uploadAddressBook:(NSArray *)array
{
    
    if (!array && [array count] == 0) {
        return;
    }
    
    if (![AccountInfo sharedAccountInfo].userId) {
        return;
    }
    
    NSString* jsonString = [STJSONSerialization toJSONData:array];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [requestDict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [requestDict setObject:[KeyChainUUID Value] forKey:@"deviceId"];
    
    [_dao requestSaveContacts:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            CLog(@"成功");
            
            [self matchAddressBook];
        }
        else
            [theAppDelegate.HUDManager hideHUD];
        
        
    } setFailedBlock:^(NSDictionary *result) {
        [theAppDelegate.HUDManager hideHUD];
    }];
    
}



#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller.
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return NO;
}


#pragma mark - Table View
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contactArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddressBookTableViewCell *cell = [AddressBookModel findCellWithTableView:tableView];
    
    ContactInfo *conInfo = [[ContactInfo alloc] initWithParsData:[_contactArray objectAtIndex:indexPath.row]];
    
    cell.delegate = self;
    
    [cell setCellContent:conInfo setIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactInfo *conInfo = [[ContactInfo alloc] initWithParsData:[_contactArray objectAtIndex:indexPath.row]];
    
    if (conInfo.hasExistSystem) {
        if ([conInfo.followedUserId isEqualToString:[AccountInfo sharedAccountInfo].userId]) {
            //自己
            ProfileTableViewController *hVC = [[ProfileTableViewController alloc] init];
            hVC.isFromTabbar = NO;
            hVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hVC animated:YES];

        }
        else{
            UIStoryboard *MineStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
            HimselfViewController *hVC = [MineStoryboard instantiateViewControllerWithIdentifier:@"HimselfViewController"];
            
            hVC.respondentUserId = conInfo.followedUserId;
            hVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hVC animated:YES];

        }
    }
}


#pragma mark  AddressBookCellDelegate
- (void)followButtonWithCell:(NSUInteger)row
{
    ContactInfo *conInfo = [[ContactInfo alloc] initWithParsData:[_contactArray objectAtIndex:row]];

    if (conInfo.hasExistSystem) {
        
        [theAppDelegate.HUDManager showSimpleTip:@"加载中..." interval:NSNotFound];
        if (conInfo.hasFollow) {
            NSMutableDictionary *encapsulateData = [[NSMutableDictionary alloc] initWithCapacity:2];
            
            [encapsulateData setObject:conInfo.userId forKey:@"followerUserId"];
            [encapsulateData setObject:conInfo.followedUserId forKey:@"followedUserId"];
            //取消关注
            [_dao requestUserUnFollow:encapsulateData completionBlock:^(NSDictionary *result) {
                if ([[result objectForKey:@"code"] integerValue] == 200)
                {
                    //重新获取
                    [self matchAddressBook];
                    //重新获取
                    [AccountInfo sharedAccountInfo].followedCount--;
                    
                }
                else{
                    [theAppDelegate.HUDManager hideHUD];
                }
                
            } setFailedBlock:^(NSDictionary *result) {
                
                [theAppDelegate.HUDManager hideHUD];
            }];
        }
        else{
            
            //关注好友
            NSMutableDictionary *encapsulateData = [[NSMutableDictionary alloc] initWithCapacity:2];
            [encapsulateData setObject:conInfo.userId forKey:@"followerUserId"];
            [encapsulateData setObject:conInfo.followedUserId forKey:@"followedUserId"];
            
            [_dao requestUserFollow:encapsulateData completionBlock:^(NSDictionary *result) {
                if ([[result objectForKey:@"code"] integerValue] == 200)
                {
                    
                    [_allArray removeAllObjects];
                    [_tableView reloadData];
                    
                    
                    [_allArray addObjectsFromArray:_bookArray];
                    
                    
                    //重新获取
                    [self matchAddressBook];
                    
                    [AccountInfo sharedAccountInfo].followedCount++;
                }
                else{
                    [theAppDelegate.HUDManager hideHUD];
                }
            } setFailedBlock:^(NSDictionary *result) {
                [theAppDelegate.HUDManager hideHUD];
                
            }];

            
        }
        
        
        
    }
    else{
        
        //// 发送短信
        if (![MFMessageComposeViewController canSendText]) {
            // Show Alert view to remind the function is unavailable
            AlertWithTitleAndMessage(@"该设备不支持短信功能",@"");
            return;
        }
        
        MFMessageComposeViewController* picker = [[MFMessageComposeViewController alloc] init];
        
        picker.messageComposeDelegate = self;

        //收件人
        picker.recipients = @[conInfo.mobilePhone];
        
        NSMutableString* absUrl = [[NSMutableString alloc] initWithString:@""];
        
        [absUrl replaceOccurrencesOfString:@"http://shitan.me/home/appcode" withString:@"http://shitan.me/home/appcode" options:
         NSCaseInsensitiveSearch range:NSMakeRange(0, [absUrl length])];
        picker.body=[NSString stringWithFormat:@"我正在使用“食探”这款美食软件，邀请你也一起加入我们的吃货行列，探索所有的美食...下载地址：http://shitan.me/home/appcode"
                     ,nil
                     ,absUrl];
        
        [self presentViewController:picker animated:YES completion:nil];

    }

}


#pragma mark  MFMessageComposeViewControllerDelegate
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
    {
        CLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent)
    {
        CLog(@"Message sent");
    }
    else
        CLog(@"Message failed");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
