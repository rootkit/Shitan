//
//  VerifyMobleViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-9-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "VerifyMobleViewController.h"
#import "SetPasswordViewController.h"
#import "REViewOptionsController.h"
#import "STWebViewController.h"
#import "AccountInfo.h"
#import "AccountDAO.h"


@interface VerifyMobleViewController ()<RETableViewManagerDelegate>

@property (strong, readwrite, nonatomic) RETableViewSection *section1;

@property (strong, readwrite, nonatomic) RERadioItem *countriesItem;
@property (strong, readwrite, nonatomic) RENumberItem *phoneName;
@property (strong, readwrite, nonatomic) AccountDAO *dao;

@property (strong, nonatomic) CXAHyperlinkLabel *linkLabel;

@end

@implementation VerifyMobleViewController



- (void)initDao
{
    if (!self.dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 初始化
    [self initDao];
    
    [self setNavBarTitle:@"验证手机号码"];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"下一步" target:self action:@selector(nextButtonTapped:)]];
    
    _manager = [[RETableViewManager alloc] initWithTableView:_tableView delegate:self];
    
    self.manager.style.cellHeight = 44.0;
    
    self.section1 = [self addSectionA];
    
    [self initLinkLabel];
}


- (void)initLinkLabel
{
    NSArray *URLs;
    NSArray *URLRanges;
    NSAttributedString *as = [self attributedString:&URLs URLRanges:&URLRanges];
    
    _linkLabel = [[CXAHyperlinkLabel alloc] initWithFrame:CGRectMake(10, 15, MAINSCREEN.size.width-20, 40)];
    _linkLabel.numberOfLines = 0;
    _linkLabel.backgroundColor = [UIColor clearColor];
    _linkLabel.attributedText = as;
    [_linkLabel setURLs:URLs forRanges:URLRanges];
    
    _linkLabel.URLClickHandler = ^(CXAHyperlinkLabel *label, NSURL *URL, NSRange range, NSArray *textRects){
        
        STWebViewController*dVC = CREATCONTROLLER(STWebViewController);
        dVC.urlSting = [URL absoluteString];
        dVC.titName = @"食探用户服务协议";
        dVC.mType = Type_Normal;
        
        [self.navigationController pushViewController:dVC animated:YES];

    };

    
    [self.bottomView addSubview:_linkLabel];
    
}



#pragma mark - privates
- (NSAttributedString *)attributedString:(NSArray *__autoreleasing *)outURLs
                               URLRanges:(NSArray *__autoreleasing *)outURLRanges
{
    
    NSString *HTMLText = @"轻触右上角的“下一步”按钮，即表示同意《<a href='http://file.shitan.me/html/0dd4572b10fc876eb9c5ed0455ed4176.html' title='食探用户服务协议'>食探用户服务协议</a>》";
    NSArray *URLs;
    NSArray *URLRanges;
    UIColor *color = MAIN_TIME_COLOR;
    UIFont *font = [UIFont fontWithName:@"Baskerville" size:12.0];
    NSMutableParagraphStyle *mps = [[NSMutableParagraphStyle alloc] init];
    mps.lineSpacing = ceilf(font.pointSize * .5);
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeMake(0, 1);
    NSString *str = [NSString stringWithHTMLText:HTMLText baseURL:[NSURL URLWithString:@"http://en.wikipedia.org/"] URLs:&URLs URLRanges:&URLRanges];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:str attributes:@
                                      {
                                          NSForegroundColorAttributeName : color,
                                          NSFontAttributeName            : font,
                                          NSParagraphStyleAttributeName  : mps,
                                          NSShadowAttributeName          : shadow,
                                      }];
    [URLRanges enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [mas addAttributes:@
         {
             NSForegroundColorAttributeName : [UIColor blueColor],
             NSUnderlineStyleAttributeName  : @(NSUnderlineStyleSingle)
         } range:[obj rangeValue]];
    }];
    
    *outURLs = URLs;
    *outURLRanges = URLRanges;
    
    return [mas copy];
}

// 用户协议
- (IBAction)agreementButtonTapped:(id)sender{
    CLog(@"jqdhas");
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
        
        // Adjust styles
        //
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
            
            
            [_dao requestMobileIsRegister:verDict completionBlock:^(NSDictionary *result) {
                if ([[result objectForKey:@"code"] integerValue] == 200)
                {
                    CLog(@"%@", [result objectForKey:@"obj"]);
                    BOOL mobileIsRegisted = [[[result objectForKey:@"obj"] objectForKey:@"mobileIsRegisted"] boolValue];
                    
                    if (mobileIsRegisted) {
                        MET_MIDDLE(@"手机号码已经被注册");
                    }
                    else
                    {
                        //请求手机短信验证码
                        [self requestVerificationCode:verDict];
                    }
                    
                }
                
            } setFailedBlock:^(NSDictionary *result) {
                
            }];
            
            

		}
		else if(buttonIndex == 0){
            CLog(@"推出");
		}
	}
    else{
        CLog(@"推出");
    }
}





// 获取验证码
- (void)requestVerificationCode:(NSDictionary *)dict
{
    [_dao requestVerificationCode:dict
                  completionBlock:^(NSDictionary *result) {
                      if ([[result objectForKey:@"code"] integerValue] == 200)
                      {
                          [self performSegueWithIdentifier:@"设置密码" sender:self];
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
