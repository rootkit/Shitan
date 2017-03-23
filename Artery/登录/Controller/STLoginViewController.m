//
//  STLoginViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/9/5.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STLoginViewController.h"
#import "VerifyMobleViewController.h"
#import "RestPasswordViewController.h"
#import "AccountDAO.h"
#import "MD5Hash.h"
#import "UMSocial.h"


@interface STLoginViewController ()<UITextFieldDelegate>
@property (strong, readwrite, nonatomic) AccountDAO *dao;
@end

@implementation STLoginViewController

- (void)initDao
{
    if (!self.dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"登录"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登录"];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarTitle:@"登录"];
    
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"icon_close.png" imgHighlight:@"icon_close.png" target:self action:@selector(back:)]];
    
    [self drawLoginUI];
    
    [self initDao];
}

- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)drawLoginUI
{
    UIImageView *bg1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 78, MAINSCREEN.size.width-30, 44)];
    [bg1 setImage:[UIImage imageNamed:@"text_bg.png"]];
    bg1.userInteractionEnabled = YES;
    [self.view addSubview:bg1];
    
    
    UIImageView *loginV = [[UIImageView alloc] initWithFrame:CGRectMake(18, 12, 12, 20)];
    [loginV setImage:[UIImage imageNamed:@"login_phone_gary.png"]];
    [bg1 addSubview:loginV];
    
    
    UIImageView *lineV1 = [[UIImageView alloc] initWithFrame:CGRectMake(41, 7, 11, 29)];
    [lineV1 setImage:[UIImage imageNamed:@"text_vertical_bg.png"]];
    [bg1 addSubview:lineV1];
    
    UILabel *keyL = [[UILabel alloc] initWithFrame:CGRectMake(61, 0, 40, 44)];
    [keyL setText:@"+86"];
    [keyL setFont:[UIFont systemFontOfSize:17.0]];
    [bg1 addSubview:keyL];

    UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, CGRectGetWidth(bg1.frame)-108, 44)];
    _userName = userName;
    [_userName setFont:[UIFont systemFontOfSize:17.0]];
    _userName.keyboardType = UIKeyboardTypeNumberPad;
    _userName.returnKeyType = UIReturnKeyNext;
    _userName.delegate = self;
    _userName.clearsOnBeginEditing = YES;
    _userName.keyboardAppearance = UIKeyboardAppearanceDark;
    [_userName setPlaceholder:@"请输入手机号码"];
    [bg1 addSubview:_userName];
    
    
    UIImageView *bg2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 136, MAINSCREEN.size.width-30, 44)];
    [bg2 setImage:[UIImage imageNamed:@"text_bg.png"]];
    bg2.userInteractionEnabled = YES;
    [self.view addSubview:bg2];
    
    UIImageView *passV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 11, 22, 22)];
    [passV setImage:[UIImage imageNamed:@"login_password.png"]];
    [bg2 addSubview:passV];
    
    UIImageView *lineV2 = [[UIImageView alloc] initWithFrame:CGRectMake(41, 7, 11, 29)];
    [lineV2 setImage:[UIImage imageNamed:@"text_vertical_bg.png"]];
    [bg2 addSubview:lineV2];
    
    UITextField *passWord = [[UITextField alloc] initWithFrame:CGRectMake(61, 0, CGRectGetWidth(bg2.frame)-68, 44)];
    _passWord = passWord;
    [_passWord setFont:[UIFont systemFontOfSize:17.0]];
    _passWord.keyboardType = UIKeyboardTypeDefault;
    _passWord.returnKeyType = UIReturnKeyDone;
    _passWord.delegate = self;
    _passWord.secureTextEntry = YES;
    _passWord.clearsOnBeginEditing = YES;
    _passWord.keyboardAppearance = UIKeyboardAppearanceDark;
    [_passWord setPlaceholder:@"请输入密码"];
    [bg2 addSubview:_passWord];
    
    //注册按钮
    UIButton *regButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(bg2.frame)+14, MAINSCREEN.size.width/2 - 20, 36)];
    _regButton = regButton;
    [_regButton setTitle:@"注册" forState:UIControlStateNormal];
    [_regButton setBackgroundImage:@"btn38_green" setSelectedBackgroundImage:@"btn29_grey"];
    [_regButton addTarget:self action:@selector(registerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_regButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];

    [self.view addSubview:_regButton];
    
    //登录按钮
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width/2 + 5, CGRectGetMaxY(bg2.frame)+14, MAINSCREEN.size.width/2 - 20, 36)];
    _loginButton = loginButton;
    [_loginButton setBackgroundImage:@"btn38_red" setSelectedBackgroundImage:@"btn29_grey"];
    [_loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.view addSubview:_loginButton];
    
    //忘记密码？
    UIButton *forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width- 91, CGRectGetMaxY(_loginButton.frame)+14, 76, 30)];
    _forgetButton = forgetButton;
    [_forgetButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [_forgetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_forgetButton addTarget:self action:@selector(forgetButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetButton];
    
    UILabel *pL = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width- 90, CGRectGetMaxY(_loginButton.frame)+38, 64, 1)];
    [pL setBackgroundColor:[UIColor grayColor]];
    [self.view  addSubview:pL];
    
    //微信
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]])
    {
        
        UILabel *lv = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(pL.frame)+30, MAINSCREEN.size.width - 30, 0.5)];
        [lv setBackgroundColor:MAIN_TIME_COLOR];
        [self.view  addSubview:lv];

        
        UILabel *mL = [[UILabel alloc] initWithFrame:CGRectZero];
        [mL setText:@"也可以用以下账号登录"];
        [mL setFont:[UIFont systemFontOfSize:14.0]];
        [mL setTextColor:MAIN_TIME_COLOR];
        [mL setTextAlignment:NSTextAlignmentCenter];
        [mL setBackgroundColor:[UIColor whiteColor]];
        
        //计算文字长度
        CGFloat mW = [self calculateDesLabelheight:@"也可以用以下账号登录"];
        [mL setFrame:CGRectMake((MAINSCREEN.size.width - mW)/2, CGRectGetMaxY(pL.frame)+20, mW, 20)];
        
        [self.view addSubview:mL];
        
        
        
        //微信登录
        UIButton *wxBtn = [[UIButton alloc] initWithFrame:CGRectMake((MAINSCREEN.size.width - 60)/2, CGRectGetMaxY(mL.frame)+30, 60, 60)];
        [wxBtn setBackgroundImage:[UIImage imageNamed:@"wx_icon"] forState:UIControlStateNormal];
        
        [wxBtn addTarget:self action:@selector(wxTapped:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:wxBtn];
        
        wxBtn.layer.cornerRadius = 30;//设置那个圆角的有多圆
        wxBtn.layer.masksToBounds = YES;//设为NO去试试
    }
}

- (CGFloat)calculateDesLabelheight:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:14.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(20000, 15);
    
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size.width +10;
}


#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userName) {
        [self.passWord becomeFirstResponder];
        return NO;
    }
    else if(textField == self.passWord){
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
}

//登录
- (void)loginButtonTapped:(id)sender{
    
    if ([_userName.text length] < 1) {
        MET_MIDDLE(@"手机号码不能为空");
        return;
    }
    if ([_passWord.text length] < 1) {
        MET_MIDDLE(@"密码不能为空");
        return;
    }
    
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    
    //发送登录请求
    [self login];
    
}


//注册
- (void)registerButtonTapped:(id)sender{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    
    //注册
    VerifyMobleViewController *mainVC = (VerifyMobleViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"LoginStoryboard" class:[VerifyMobleViewController class]];
    [self.navigationController pushViewController:mainVC animated:YES];
}

//忘记密码
- (void)forgetButtonTapped:(id)sender
{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    
    //注册
    RestPasswordViewController *mainVC = (RestPasswordViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"LoginStoryboard" class:[RestPasswordViewController class]];
    [self.navigationController pushViewController:mainVC animated:YES];
}

- (void)wxTapped:(id)sender
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES,
                                  ^(UMSocialResponseEntity *response){
                                      
                                      if (response.data) {
                                          [theAppDelegate.HUDManager showSimpleTip:@"正在授权" interval:NSNotFound];
                                          
                                          //获取微信用户资料
                                          [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
                                              
                                              CLog(@"SnsInformation is %@",response.data);
                                              
                                              if (response.data) {
                                                  NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
                                                  [dic setObject:[response.data objectForKey:@"access_token"] forKey:@"access_token"];
                                                  [dic setObject:[response.data objectForKey:@"openid"] forKey:@"openid"];
                                                  
                                                  [self.dao requestWechatUnionid:dic completionBlock:^(NSDictionary *result) {
                                                      CLog(@"%@", result);
                                                      
                                                      NSString *unionid = [result objectForKeyNotNull:@"unionid"];
                                                      
                                                      NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:response.data];
                                                      [dic setObject:unionid forKey:@"unionid"];
                                                      [self parasResponseData:dic];
                                                      
                                                  } setFailedBlock:^(NSDictionary *result) {
                                                      
                                                  }];
                                              }
                                              
                                          }];
                                      }
                                      else{
                                          [theAppDelegate.HUDManager hideHUD];
                                          MET_MIDDLE(@"授权失败");
                                      }
                                  });
}


//解析微信登陆返回的数据
- (void)parasResponseData:(NSDictionary *)response
{
    if (![response objectForKey:@"access_token"]) {
        
        
        [theAppDelegate.HUDManager hideHUD];
        MET_MIDDLE(@"授权被取消");
        return;
    }
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    
    [dict setObject:[response objectForKey:@"access_token"] forKey:@"weixinToken"];
    [dict setObject:[response objectForKey:@"openid"] forKey:@"weixinId"];
    
    //微信unionid
    [dict setObject:[response objectForKey:@"unionid"] forKey:@"weixinUnionId"];
    
    //微信授权的类型
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"winxinType"];
    
    //性别(男为0，女为1)
    if([[response objectForKey:@"gender"] integerValue] == 0)
    {
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"gender"];
    }
    else{
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"gender"];
    }
    
    
    //头像
    [dict setObject:[response objectForKey:@"profile_image_url"] forKey:@"portraitUrl"];
    //昵称
    [dict setObject:[response objectForKey:@"screen_name"] forKey:@"nickName"];
    
    
    [dict setObject:@"1990-01-01" forKey:@"birthday"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    //直接登录
    [self.dao requestWechatLogin:requestDict];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}



- (void)login
{
    // 区号（国家编码）
    NSString *code = @"86";
    
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [temp setObject:code forKey:@"mobilePrefix"];
    [temp setObject:self.userName.text forKey:@"mobile"];

    NSString *psw = [MD5Hash getMd5_32Bit_String:self.passWord.text];
    [temp setObject:psw forKey:@"pwd"];
    
    // 登录
    [_dao requestMobleLogin:temp];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
