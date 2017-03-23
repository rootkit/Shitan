//
//  FillInformationViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-9-15.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FillInformationViewController.h"
#import "AccountDAO.h"
#import "UploadDAO.h"
#import "MD5Hash.h"
#import "ParsModel.h"
#import "ContactsManager.h"
#import "EmojiConvertor.h"


@interface FillInformationViewController ()<RETableViewManagerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, readwrite, nonatomic) RETableViewSection *section1;

@property (strong, readwrite, nonatomic) RETextItem *nickName;

@property (strong, readwrite, nonatomic) RESegmentedItem *genderItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *dateTimeItem;

@property (strong, nonatomic, readwrite) UIActionSheet *actionSheet;
@property (strong, readwrite, nonatomic) AccountDAO *dao;
@property (strong, readwrite, nonatomic) UploadDAO *uploadDAO;

@property (nonatomic, strong) EmojiConvertor *emojiCon;

@end

@implementation FillInformationViewController


- (void)initDao
{
    if (!self.dao) {
        self.dao = [[AccountDAO alloc] init];
    }
    
    if (!self.uploadDAO) {
        self.uploadDAO = [[UploadDAO alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDao];
    
    //表情转码
    self.emojiCon = [[EmojiConvertor alloc] init];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"注册" target:self action:@selector(registerButtonTapped:)]];
    
    [self setNavBarTitle:@"填写个人信息"];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    
    [_headButton.layer setCornerRadius:CGRectGetHeight([_headButton bounds]) / 2];
    _headButton.layer.masksToBounds = YES;

    _headButton.layer.contents = (id)[[UIImage imageNamed:@"head_default.png"] CGImage];

    self.tableView.backgroundView = nil;
    
    _manager = [[RETableViewManager alloc] initWithTableView:_tableView delegate:self];
    
    
    self.manager.style.cellHeight = 50.0;
    
    self.section1 = [self addSectionA];

}

// 头像按钮响应事件
- (IBAction)headButtonTapped:(id)sender
{
    _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册中选择",nil];
    [_actionSheet showInView:self.view];
}


- (void)registerButtonTapped:(id)sender
{
    if(!_headImage){
        MET_MIDDLE(@"请上传头像");
        return;
    }

    if(!self.nickName.value)
    {
        MET_MIDDLE(@"昵称不能为空");
        return;
    }
    
    [_uploadDAO requestUploadHeadImage:_headImage completionBlock:^(NSDictionary *result) {
        
        [ParsModel parsData:result successBlock:^(NSDictionary *dict) {
            CLog(@"%@", dict);
            
            [self UploadPicturesSuccessful:[NSString stringWithFormat:@"%@", [dict objectForKey:@"url"]]];
            
        } failureBlock:^(NSDictionary *dict) {
            CLog(@"%@", dict);
        }];

    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}


#pragma mark -
#pragma mark Basic Controls Example
- (RETableViewSection *)addSectionA
{
    
    // Add sections and items
    RETableViewSection *section = [RETableViewSection section];
    [_manager addSection:section];
    NSMutableArray *collapsedItems = [NSMutableArray array];
    
    self.nickName = [RETextItem itemWithTitle:@"昵称" value:nil placeholder:@"请输入昵称"];
    
    
    self.genderItem = [RESegmentedItem itemWithTitle:@"性别" segmentedControlTitles:@[@"男", @"女"] value:0 switchValueChangeHandler:^(RESegmentedItem *item) {
        CLog(@"Value: %ld", (long)item.value);
    }];
    

    
    self.dateTimeItem = [REDateTimeItem itemWithTitle:@"出生日期" value:[NSDate date] placeholder:nil format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
    self.dateTimeItem.onChange = ^(REDateTimeItem *item){
        NSLog(@"Value: %@", item.value.description);
    };
    
    [collapsedItems addObjectsFromArray:@[self.nickName, self.genderItem, self.dateTimeItem]];
    [section addItemsFromArray:collapsedItems];
    
    return section;
}


#pragma mark - LXActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //照相机
        if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
            //                    AlertWithTitleAndMessage(@"您的设备不支持拍照功能",@"");
            return;
        }
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        //调用前摄像头
        //			_pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if (buttonIndex == 1) {
        //相簿
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }

    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
	
	UIImage* userImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CLog(@"%02f, %02f", userImage.size.height, userImage.size.width);
    
    _headImage = ImageWithImageSimple(userImage, CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width));
    
    [_headButton setBackgroundImage:_headImage forState:UIControlStateNormal];
    
    
    // 代理是否为空 且是否实现了该代理
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//上传图片成功之后返回的地址
- (void)UploadPicturesSuccessful:(NSString *)urlS
{
    // 账户注册
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionaryWithCapacity:7];
    // 国家或者区域号
    [jsonDict setObject:[AccountInfo sharedAccountInfo].mobileprefix forKey:@"mobilePrefix"];

    // 手机号
    [jsonDict setObject:theAppDelegate.phone forKey:@"mobile"];

    // 密码
    [jsonDict setObject:[AccountInfo sharedAccountInfo].pwd forKey:@"pwd"];

    // 头像
    [jsonDict setObject:urlS forKey:@"portraitUrl"];

    // 昵称
    NSString *tempString = [_nickName.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [jsonDict setObject:[self.emojiCon convertEmojiUnicodeToSoftbank:tempString] forKey:@"nickName"];

    // 性别(0为男， 1为女)
    [jsonDict setObject:[NSNumber numberWithInteger:self.genderItem.value] forKey:@"gender"];

    // 出生日期
    NSString *birthday = [self.dateTimeItem.value.description substringWithRange:NSMakeRange(0,10)];
    [jsonDict setObject:birthday forKey:@"birthday"];

    NSString* jsonString = [STJSONSerialization toJSONData:jsonDict];

    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];

    [requestDict setObject:jsonString forKey:@"reqStr"];

    //注册
    [_dao requestMobleRegister:requestDict
               completionBlock:^(NSDictionary *result) {
                   if ([[result objectForKey:@"code"] integerValue] == 200)
                   {
                       //注册之后需要创建Token值
                       [[AccountInfo sharedAccountInfo] parsAccountData:[result objectForKey:@"obj"]];
                       
                       //跳转到首页
                       [theAppDelegate loginSuccess];
                       
                       //上传通讯录
                       [[ContactsManager shareInstance] delayLoadContacts];
                       
                       [self dismissViewControllerAnimated:YES completion:NULL];
                   }
                   else
                   {
                       MET_MIDDLE([result objectForKey:@"msg"]);
                   }
                   
               } setFailedBlock:^(NSDictionary *result) {
                   MET_MIDDLE([result objectForKey:@"msg"]);
               }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

