//
//  ImagesReleasedViewController.m
//  Artery
//
//  Created by 刘敏 on 14-9-27.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ImagesReleasedViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "SJAvatarBrowser.h"
#import "BubbleView.h"
#import "PublishImage.h"
#import "UMSocial.h"
#import "AccountDAO.h"
#import "ShareModel.h"
#import "RatingBar.h"
#import "EmojiConvertor.h"
#import <SDWebImage/UIImage+WebP.h>

#define M_Quality 75.0f         //质量


@interface ImagesReleasedViewController ()<UIScrollViewDelegate, RatingBarDelegate, ZBMessageManagerFaceViewDelegate>
{
    BOOL  isShareToWeibo;
}

@property (strong, nonatomic) ALAssetsLibrary *library;
@property (strong, readwrite, nonatomic) AccountDAO *dao;
@property (strong, nonatomic) RatingBar *starbBar;
@property (assign, nonatomic) NSInteger starNO;           //评分

@property (nonatomic, strong) EmojiConvertor *emojiCon;
@property (nonatomic, strong) NSData *imageD;


//数据封装
- (void)dataEncapsulation;

//将图片缓存到本地
- (NSString *)saveHeadImageToDocuments:(NSData *)imageData isOriginal:(BOOL)isOriginal;

@end

@implementation ImagesReleasedViewController


- (void)initDAO
{
    if (!_dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [_scrollView setFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 800)];
    [_scrollView setContentSize:CGSizeMake(MAINSCREEN.size.width, MAINSCREEN.size.height+44)];

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"图像发布"];
}


- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"图像发布"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initDAO];
    
    _library = [[ALAssetsLibrary alloc] init];
    
    //表情转码
    self.emojiCon = [[EmojiConvertor alloc] init];
    
    //设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customWithTitle:@"发布" target:self action:@selector(doneButtonTapped:)];
        
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.picView.image = _watermarkImage;
    self.picView.layer.cornerRadius = 1;            //设置那个圆角的有多圆
    self.picView.layer.masksToBounds = YES;         //设为NO去试试
    
    //保存图片开关
    [_saveSwitch setOn:NO];
    [self.saveSwitch addTarget:self action:@selector(switchValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    _starbBar = [[RatingBar alloc] initWithFrame:CGRectMake(90, 6, 180, 30)];
    _starbBar.viewColor = [UIColor clearColor];
    _starbBar.delegate = self;
    [self.scoreView addSubview:_starbBar];
    
    /********************************    单击手势    ***********************************/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picViewTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    
    //开启触摸事件响应
    [self.picView addGestureRecognizer:tapGesture];

    [self.picView setUserInteractionEnabled:YES];
    
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;

    //来源于草稿箱
    if(_isDraft)
    {
        [self initDraftUI];
    }
    else
    {
        dispatch_after(0.2, dispatch_get_global_queue(0, 0), ^{
            
            NSData *tempData = UIImageJPEGRepresentation(_cacheImage, 1.0);
            
            [UIImage imageToWebP:[UIImage imageWithData:tempData] quality:M_Quality alpha:1 preset:WEBP_PRESET_DEFAULT completionBlock:^(NSData *result) {
                _imageD = result;
                
            } failureBlock:^(NSError *error) {
                CLog(@"%@", error.localizedDescription);
            }];
            
        });
    }
    
    
    [self initInputBox];
}

- (void)initShareView
{
//    NSMutableArray *tA = [[NSMutableArray alloc] initWithCapacity:0];
//    NSMutableArray *tB = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]])
//    {
//        [self.weiboButton setHidden:YES];
//        [self.weiboLabel setHidden:YES];
//    }
//    
//    
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
//    {
//        [tA addObject:@"QQ好友"];
//        [tA addObject:@"QQ空间"];
//        
//        [tB addObject:[UIImage imageNamed:@"sns_icon_1"]];
//        [tB addObject:[UIImage imageNamed:@"sns_icon_2"]];
//    }
//    
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"WeChat://"]])
//    {
//        [tA addObject:@"微信好友"];
//        [tA addObject:@"微信朋友圈"];
//        
//        [tB addObject:[UIImage imageNamed:@"sns_icon_4"]];
//        [tB addObject:[UIImage imageNamed:@"sns_icon_5"]];
//    }
    
}


- (void)initInputBox
{
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    
    UIImageView *lineV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_line"]];
    [lineV setFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 1)];
    [self.containerView addSubview:lineV];
    
    
    _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_faceButton setFrame:CGRectMake(8, 6, 32, 32)];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"send_face"] forState:UIControlStateNormal];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"send_keyboard"] forState:UIControlStateSelected];
    [_faceButton addTarget:self action:@selector(faceBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:_faceButton];
    
    
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(MAINSCREEN.size.width - 56 , 6, 50, 32)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [doneBtn setTitleColor:[UIColor colorWithRed:0/255.0  green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];

    [doneBtn addTarget:self action:@selector(doneBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:doneBtn];
}


//键盘确定按钮
- (void)doneBtnTapped:(UIButton *)sender
{
    [self hideFaceView];
    [_desTextView resignFirstResponder];
}


- (void)faceBtnTapped:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        CLog(@"表情");
        
        [_desTextView resignFirstResponder];
        [self showFaceView];
    }
    else{
        //显示键盘，隐藏表情
        [self hideFaceView];
        [_desTextView becomeFirstResponder];
    }
}



- (void)initDraftUI
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem customWithImageName:@"icon_close.png" target:self action:@selector(cancelButtonTapped:)];
    if ([_cacheDict objectForKey:@"score"]) {
        
        //评论
        if ([_cacheDict objectForKey:@"imgDesc"] && [[_cacheDict objectForKey:@"imgDesc"] length] > 0) {
            [_desTextView setText:[_cacheDict objectForKey:@"imgDesc"]];
            _placefolder.text = @"";
        }
        
        //星星个数
        _starNO = [[_cacheDict objectForKey:@"score"] integerValue];
        [_starbBar setStarNumber:_starNO];
        [self ratingBarWithStarNumber:_starNO];
        
        //缩略图片（水印图）
        if ([_cacheDict objectForKey:@"waterURL"]) {
            NSString *pathDocuments = NSTemporaryDirectory();
            NSString *createPath = [NSString stringWithFormat:@"%@/Draft",pathDocuments];
            NSString *dataFilePath = [createPath stringByAppendingPathComponent:[_cacheDict objectForKey:@"waterURL"]];
            _picView.image = [UIImage imageWithContentsOfFile:dataFilePath];
        }
    }
}

- (void)cancelButtonTapped:(id)sender{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)picViewTapped:(UITapGestureRecognizer *)sender
{
    [SJAvatarBrowser showImage:self.picView];
    [_desTextView resignFirstResponder];
    [self hideFaceView];
}

- (void)switchValueDidChange:(UISwitch *)switchView
{
    CLog(@"%d", switchView.on);
}

- (void)popShareView
{
    [self.desTextView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(_desTextView.text.length == 0){
        _placefolder.text = @"菜的味道怎么样，价格贵吗？";
    }
    else
    {
        _placefolder.text = @"";
        
        if(_desTextView.text.length > MAX_INPUT_LENGTH)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大可输入长度" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self hideFaceView];
        return NO;
    }
    
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的(表情整个删除)
        if ([self.faceView.eArray count] > 0) {
            NSString *faceN = [self.faceView.eArray objectAtIndex:self.faceView.eArray.count-1];
            if ([textView.text hasSuffix:faceN]) {
                //删除表情
                textView.text = [textView.text substringWithRange:NSMakeRange(0, textView.text.length- faceN.length+1)];
                [self.faceView.eArray removeLastObject];
            }
        }
        //是表情整个删除
        return YES;
    }
    else {
        NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if (textView.text.length - range.length + text.length > MAX_INPUT_LENGTH  && range.length!=1) {
            
            textView.text = [toBeString substringToIndex:MAX_INPUT_LENGTH];

            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大可输入长度" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        else {
            return YES;
        }
    }
}

- (IBAction)weiboTapped:(UIButton *)sender{
    if(!isShareToWeibo)
    {
        if (![AccountInfo sharedAccountInfo].weibotoken) {
            
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
                
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                if (response.data) {
                    [theAppDelegate.HUDManager showSimpleTip:@"正在授权" interval:NSNotFound];
                    //获取微博用户名、uid、token等
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        //获取新浪用户信息
                        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina completion:^(UMSocialResponseEntity *response)
                         {
                             NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
                             [dict setObject:[response.data objectForKey:@"access_token"] forKey:@"weiboToken"];
                             [dict setObject:[response.data objectForKey:@"uid"] forKey:@"weiboId"];
                             [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
                    
                    
                            NSString* jsonString = [STJSONSerialization toJSONData:dict];
                            NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
                            [requestDict setObject:jsonString forKey:@"reqStr"];
                            
                            [_dao requestBindWeibo:requestDict completionBlock:^(NSDictionary *result) {
                                if ([[result objectForKey:@"code"] integerValue] == 200)
                                {
                                    if ([result objectForKey:@"obj"])
                                    {
                                        
                                        [[AccountInfo sharedAccountInfo] parsAccountData:[result objectForKey:@"obj"]];
                                        sender.selected = !sender.selected;
                                        isShareToWeibo = sender.selected;
                                    }
                                }
                                else
                                {
                                    sender.selected = NO;
                                    MET_MIDDLE([result objectForKey:@"msg"]);
                                }
                            }
                                    setFailedBlock:^(NSDictionary *result)
                             {
                                 sender.selected = NO;
                                 MET_MIDDLE([result objectForKey:@"msg"]);
                             }];
                         }];
                    }
                }
                else{
                    
                    
                    MET_MIDDLE(@"授权失败");
                    sender.selected = NO;
                }
            });
        }
        else
        {
            sender.selected = !sender.selected;
            isShareToWeibo = sender.selected;
        }
    }
    else
    {
        sender.selected = !sender.selected;
        isShareToWeibo = sender.selected;
    }
    
    //usid为官方微博的uid（如果希望直接静默关注（不出现选项），则在代码中添加下面的方法）
    [[UMSocialDataService defaultDataService] requestAddFollow:UMShareToSina followedUsid:@[K_WEIBO_UID] completion:nil];
}


// 发布信息---上传图片
- (void)doneButtonTapped:(UIButton *)sender
{
    [self hideFaceView];
    [_desTextView resignFirstResponder];
    
    if (_saveSwitch.isOn) {
        
        //保存水印图片到相册
        [_library saveImage:_watermarkImage toAlbum:@"食探" completion:^(NSURL *assetURL, NSError *error) {
            CLog(@"你好，阳光！");
            
        } failure:^(NSError *error) {
            if (error != nil) {
                CLog(@"Big error: %@", [error description]);
            }
        }];
    }
    
    //回收发图界面
    [self performSelector:@selector(jumpToMainView) withObject:nil afterDelay:0.1];
    
    if(_isDraft)
    {
        //来源于草稿箱
        [self draftDataEncapsulation];
    }
    else{
        
        [self dataEncapsulation];
    }
}

//数据封装
- (void)dataEncapsulation
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    /**************************************** 本地草稿箱所需数据 ***********************************/
    //当前时间
    [dict setObject:[Units getNowTime] forKey:@"time"];
    
    //水印图片地址
    NSString *waterPath = [self saveHeadImageToDocuments:UIImageJPEGRepresentation(_watermarkImage, 1.0) isOriginal:NO];
    [dict setObject:waterPath forKey:@"waterURL"];

    /**************************************************************************************/
    
    
    // 描述
    if ([_desTextView.text length] > 0) {
        [dict setObject:[self.emojiCon convertEmojiUnicodeToSoftbank:[_desTextView text]] forKey:@"imgDesc"];
    }
    
    
    //UserID
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    if (_pInfo) {
        //经度
        [dict setObject:_pInfo.longitude forKey:@"longitude"];
        //纬度
        [dict setObject:_pInfo.latitude forKey:@"latitude"];
    }
    
    if(theAppDelegate.cityName){
        //城市
        [dict setObject:theAppDelegate.locatCity forKey:@"city"];
    }
    else
    {
        AlertWithTitleAndMessage(nil, @"由于您未开启定位，您发布的图片无法在同城动态中展示，您可以到个人主页-我的美食日记中查看该图");
    }
    

    //图片宽度
    [dict setObject:[NSNumber numberWithInteger:_cacheImage.size.width] forKey:@"imgWidth"];
    //图片高度
    [dict setObject:[NSNumber numberWithInteger:_cacheImage.size.height] forKey:@"imgHeight"];

    //记录Tag数组
    NSMutableArray *tagArray = [[NSMutableArray alloc] init];
    
    for (BubbleView *tipV in _tipArray) {
        
        NSMutableDictionary *tagDict = [[NSMutableDictionary alloc] initWithCapacity:5];
        
        //是否在左右（1表示在左边， 0表示在右边）
        NSInteger directionFlag = tipV.isLeft ? 1:0;
        [tagDict setObject:[NSNumber numberWithInteger:directionFlag] forKey:@"directionFlag"];
        
        //标签ID
        [tagDict setObject:tipV.tipID forKey:@"tagId"];
        
        [tagDict setObject:[NSNumber numberWithFloat:[self fixedCoordinates:tipV.frame.origin.x]] forKey:@"x"];
        [tagDict setObject:[NSNumber numberWithFloat:[self fixedCoordinates:tipV.frame.origin.y]] forKey:@"y"];
        
        //标签类型
        [tagDict setObject:[NSNumber numberWithInteger:tipV.tipType] forKey:@"tagType"];
        
        [tagArray addObject:tagDict];
        
        if(tipV.tipType == Tip_Location)
        {
            [dict setObject:[NSString stringWithFormat:@"地点:%@", tipV.tipName] forKey:@"placeN"];
        }
    }
    
    [dict setObject:[NSNumber numberWithInteger:_starNO] forKey:@"score"];
    [dict setObject:tagArray forKey:@"tags"];
    
    // 分享到的sns平台，传入字符串如"QQ,WEIXIN,WEIBO"
    NSMutableArray *snsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    if (isShareToWeibo) {
        [snsArray addObject:@"WEIBO"];
        NSString *description = @"美食推荐:";
        
        for (BubbleView *tipV in _tipArray) {
  
                if (tipV.tipType == Tip_FoodN) {
                    description = [description stringByAppendingString:[NSString stringWithFormat:@" %@", tipV.tipName]];
                }
   
            
                if (tipV.tipType == Tip_Location) {
                    description = [description stringByAppendingString:[NSString stringWithFormat:@" 地点:%@", tipV.tipName]];
                }
            
                if (tipV.tipType == Tip_Normal) {
                    description = [description stringByAppendingString:[NSString stringWithFormat:@" #%@#", tipV.tipName]];
                }
        }
        //分享
        [[ShareModel getInstance] sendMessageToWeibo:_watermarkImage  description:description];
    }

    //有分享到第三方平台才传递
    if ([snsArray count] > 0) {
        [dict setObject:[snsArray componentsJoinedByString:@","] forKey:@"snsPlatform"];
    }
    
    NSString *imagePath = nil;
    
    if (_imageD) {
        imagePath = [self saveHeadImageToDocuments:_imageD isOriginal:YES];
    }
    else{
        // 发布的图片路径（原始图）
        imagePath = [self saveHeadImageToDocuments:UIImageJPEGRepresentation(_cacheImage, 0.45) isOriginal:YES];
    }
    
    [dict setObject:imagePath forKey:@"originalURL"];
    //文件操作
    [self fileOperations:dict];
}


//封装草稿箱数据
- (void)draftDataEncapsulation
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict addEntriesFromDictionary:_cacheDict];
    
    // 描述
    if ([_desTextView.text length] > 0) {
        [dict setObject:[self.emojiCon convertEmojiUnicodeToSoftbank:[_desTextView text]] forKey:@"imgDesc"];
    }
    
    //评分
    [dict setObject:[NSNumber numberWithInteger:_starNO] forKey:@"score"];
    
    //文件操作
    [self fileOperations:dict];
}


//文件操作
- (void)fileOperations:(NSDictionary *)dict
{
    //写入到文件
    NSMutableArray *array  = [[NSMutableArray alloc] init];
    //写入文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = NSTemporaryDirectory();
    NSString *plistPath = [NSString stringWithFormat:@"%@Draft",path];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"draftData.plist"];   //获取路径
    CLog(@"%@",filename);
    
    
    array = [NSMutableArray arrayWithContentsOfFile:filename];  //读取数据
    
    if (_isDraft) {
        //替换数据
        [array replaceObjectAtIndex:_mRow withObject:dict];
    }
    else{
        [array addObject:dict];
        //新发布的数据的序号最大
        if ([array count] > 0) {
            _mRow = [array count] - 1;
        }
        else
            _mRow = 0;
    }
    
    BOOL success = [fileManager fileExistsAtPath:filename];
    
    //不存在先创建Plist文件
    if (!success) {
        NSMutableArray * fileArray = [[NSMutableArray alloc] initWithCapacity:0];
        [fileArray addObject:dict];
        
        [fileArray writeToFile:filename atomically:YES];
    }
    else {
        [array writeToFile:filename atomically:YES];
    }
    
    //开始发布图片
    [self performSelector:@selector(delayPublishImage) withObject:nil afterDelay:0.2];
}

//发布图片
- (void)delayPublishImage{
    //发布图片
    [[PublishImage sharedPublishImage] releaseNewDynamic:_mRow];
}

//跳转到主页
- (void)jumpToMainView
{
    theAppDelegate.PODict = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //显示
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    self.tabBarController.selectedIndex = 0;
}

//将图片缓存到本地(草稿箱)
- (NSString *)saveHeadImageToDocuments:(NSData *)imageData isOriginal:(BOOL)isOriginal
{

    
    NSString *usName = nil;
    if(isOriginal)
    {
        //常规图片
        usName = [NSString stringWithFormat:@"%@.jpg", [Units formatTimeAsFileName]];
    }
    else
    {
        //水印图片
        usName = [NSString stringWithFormat:@"watermark_%@.jpg", [Units formatTimeAsFileName]];
    }

    
    if (imageData) {
        NSString *pathDocuments = NSTemporaryDirectory();
        NSString *createPath=[NSString stringWithFormat:@"%@/Draft",pathDocuments];
        NSString *dataFilePath = [createPath stringByAppendingPathComponent:usName];
        CLog(@"图像路径：%@", dataFilePath);
        [imageData writeToFile:dataFilePath atomically:YES];
    }

    return usName;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_desTextView resignFirstResponder];
    [self hideFaceView];
}


#pragma mark RatingBarDelegate
- (void)ratingBarWithStarNumber:(NSInteger)num
{
    _starNO = num;
    switch (_starNO) {
        case 0:
            _starLabel.text = @"";
            break;
            
        case 1:
            _starLabel.text = @"很差";
            break;
        case 2:
            _starLabel.text = @"一般";
            break;
            
        case 3:
            _starLabel.text = @"好";
            break;
            
        case 4:
            _starLabel.text = @"很好";
            break;
            
        case 5:
            _starLabel.text = @"非常好";
            break;
            
        default:
            break;
    }
    
}

//显示表情
- (void)showFaceView
{
    if (!self.faceView)
    {
        [self shareFaceView];
    }
    
    CGRect expressionFrame = self.faceView.frame;
    
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (expressionFrame.size.height + containerFrame.size.height);
    
    expressionFrame.origin.y = self.view.bounds.size.height - expressionFrame.size.height;
    
    //animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //set views with new info
    self.containerView.frame = containerFrame;
    self.faceView.frame = expressionFrame;
    
    //commit animations
    [UIView commitAnimations];
}


//隐藏
- (void)hideFaceView
{
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height;
    
    CGRect expressionFrame = self.faceView.frame;
    expressionFrame.origin.y = self.view.bounds.size.height;
    
    //animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    
    //set view with new info
    self.containerView.frame = containerFrame;
    self.faceView.frame = expressionFrame;
    
    //commit animations
    [UIView commitAnimations];
}

//创建表情view
- (void)shareFaceView{
    
    self.faceView = [[ZBMessageManagerFaceView alloc] initWithFrame:
                     CGRectMake(0.0f, MAINSCREEN.size.height, MAINSCREEN.size.width, 216)];//216-->196
    self.faceView.delegate = self;
    [self.view addSubview:self.faceView];
    
}


#pragma mark 执行通知
- (void) keyboardWillShow:(NSNotification*)note
{
    [self hideFaceView];
    _faceButton.selected = NO;
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    
    CGRect containerFrame = _containerView.frame;
    
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}


- (void) keyboardWillHide:(NSNotification*)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _containerView.frame = containerFrame;

    [UIView commitAnimations];
    
}

#pragma mark -ZBMessageManagerFaceViewDelegate
//点击表情
- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele{
    
    if(dele)
    {
        //删除末尾[xx]字符
        NSUInteger flength = faceStr.length;
        NSUInteger allLength = _desTextView.text.length;
        
        if (faceStr) {
            if ([_desTextView.text hasSuffix:faceStr]) {
                //删除表情
                _desTextView.text = [_desTextView.text substringWithRange:NSMakeRange(0, allLength- flength)];
                [self.faceView.eArray removeLastObject];
            }
            else{
                if ([_desTextView.text length] > 0) {
                    _desTextView.text = [_desTextView.text substringWithRange:NSMakeRange(0, allLength - 1)];
                }
            }
        }
        else
        {
            CLog(@"删除普通字符");
            if ([_desTextView.text length] > 0) {
                _desTextView.text = [_desTextView.text substringWithRange:NSMakeRange(0, allLength - 1)];
            }
            
        }
        
    }
    else
    {
        _desTextView.text = [_desTextView.text stringByAppendingString:faceStr];
        
    }
    
    [self textViewDidChange:_desTextView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//修正坐标（将屏幕坐标转换成1280*1280上的坐标）
- (CGFloat)fixedCoordinates:(CGFloat)oldPoint
{
    CGFloat m_ratio = 1280.0/MAINSCREEN.size.width;
    CGFloat endPoint = oldPoint * m_ratio;
    
    return endPoint;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    CLog(@"",self.cacheImage)
}

@end
