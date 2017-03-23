//
//  TaggedViewController.m
//  Artery
//
//  Created by 刘敏 on 14-9-25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//
//  地理位置标签只能打1个，美食名字1个，常规标签2个


#import "TaggedViewController.h"
#import "MarkViewController.h"
#import "PlaceViewController.h"
#import "ImagesReleasedViewController.h"
#import "BubbleView.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "PlaceInfo.h"
#import "FoodInfo.h"

#import "SettingModel.h"


@interface TaggedViewController ()<BubbleViewDelegate, MarkViewControllerDelegate>

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) PulsingHaloLayer *halo;
@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) NSMutableArray *tipArray;

@property (nonatomic, assign) CGPoint tipPoint;

@property (nonatomic, assign) NSInteger mTAG;           //标签的Tag值

@property (strong, nonatomic) ALAssetsLibrary * library;
@property (strong, nonatomic) PlaceInfo *pInfo;         //商户信息（位置）
@property (strong, nonatomic) FoodInfo *fInfo;

@end

@implementation TaggedViewController

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ADD_TIPS_PLACE_FOODNAME" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"添加标签"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"添加标签"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _library = [[ALAssetsLibrary alloc] init];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foodViewControllerSelected:)
                                                 name:@"ADD_TIPS_PLACE_FOODNAME"
                                               object:nil];
    
    _mTAG = 9000;
    
    //X坐标固定
    _tipPoint.x = 10.0f;
    
    //初始化数组
    _tipArray = [[NSMutableArray alloc] init];
    
    // 设置标题
    self.title = @"添加标签";

    //设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customWithTitle:@"下一步" target:self action:@selector(nextButtonTapped:)];

    // Do any additional setup after loading the view from its nib.
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.width)];
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV.userInteractionEnabled = YES;
    self.imageV.image = _cacheImage;
    
    [self.view addSubview:self.imageV];

    
    CGFloat mHihgt = (MAINSCREEN.size.height - MAINSCREEN.size.width)/2;
    _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MAINSCREEN.size.width+mHihgt-10, MAINSCREEN.size.width, 22)];
    _desLabel.textAlignment = NSTextAlignmentCenter;
    [_desLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_desLabel setTextColor:[UIColor lightGrayColor]];
    _desLabel.text = @"移动:拖动标记  删除:长按标记  反向：点击标记";
    [self.view addSubview:_desLabel];
    
    
    [self addTipsMenu];
    
    
    if (theAppDelegate.PODict) {
        //添加专题标签
        [self addSpecialTip];
    }
}

//添加专题标签
- (void)addSpecialTip
{
    NSString *tag = [theAppDelegate.PODict objectForKey:@"MTAG"];
    NSString *tagID = [theAppDelegate.PODict objectForKey:@"TAGID"];

    //设置坐标
    _tipPoint.y = MAINSCREEN.size.width - 130;
    [self addBubbleView:Tip_Normal bubbleTitle:tag bubbleID:tagID];
}

- (void)addTipsMenu
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@" 添加地点和美食名" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"oval_logo.png"] forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [leftBtn setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
    [leftBtn setFrame:CGRectMake(10, MAINSCREEN.size.width+15, MAINSCREEN.size.width/2-15, 44)];
    leftBtn.layer.cornerRadius = 3;//设置那个圆角的有多圆
    leftBtn.layer.masksToBounds = YES;//设为NO去试试
    [leftBtn addTarget:self action:@selector(leftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.view addSubview:leftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@" 添加其他标签" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"oval_price.png"] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [rightBtn setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
    [rightBtn setFrame:CGRectMake(MAINSCREEN.size.width/2+5, MAINSCREEN.size.width+15, MAINSCREEN.size.width/2-15, 44)];
    rightBtn.layer.cornerRadius = 3;//设置那个圆角的有多圆
    rightBtn.layer.masksToBounds = YES;//设为NO去试试
    [rightBtn addTarget:self action:@selector(rightBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];

    [self.view addSubview:rightBtn];
}


- (void)leftBtnTapped:(id)sender
{
    PlaceViewController *pVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"PlaceViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}


- (void)rightBtnTapped:(id)sender
{
    if ([_tipArray count] >= 4) {
        
        AlertWithTitleAndMessage(@"标签最多只能添加4个，如需添加新的标签，可长标签进行删除", nil);
        return;
    }
    MarkViewController *mVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"MarkViewController"];
    mVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mVC];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark BubbleViewDelegate
- (void)deleteBubbleView:(NSInteger)mtag{
    AlertWithTitleAndMessageAndUnitsToTag(@"您要删除当前标签吗", nil, self, @"确定", nil, mtag);
}


#pragma mark 添加地点标签
- (void)placeViewControllerSelected:(PlaceInfo *)pInfo
{
    _pInfo = pInfo;
    NSString *addressTitle = pInfo.addressName;
    if (pInfo.branchName && pInfo.branchName.length > 0) {
        addressTitle = [[[pInfo.addressName stringByAppendingString:@"("] stringByAppendingString:pInfo.branchName] stringByAppendingString:@")"];
    }
    [self addBubbleView:Tip_Location bubbleTitle:addressTitle bubbleID:pInfo.addressId];
}


- (CGFloat)calculateDesLabelheight:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(20000, 26);
    
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size.width;
}

#pragma mark 常规标签
- (void)markViewControllerSelected:(MarkInfo *)mInfo{
    
    NSUInteger count = 0;
    //先判断已经有几个常规标签
    for (BubbleView *buV in _tipArray) {
        //不是常规标签
        if (buV.tipType == Tip_Normal) {
            count++;
        }
    }

    //设置坐标
    _tipPoint.y = MAINSCREEN.size.width - (130 + 35*count);
    [self addBubbleView:Tip_Normal bubbleTitle:mInfo.rawTag bubbleID:mInfo.rawId];
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            CLog(@"取消");
            break;

        case 1:
        {
            //删除
            //删除标签规则：删除美食标签同时删除地点标签，删除地点标签同时删除菜名标签
            BubbleView *bubbleV = (BubbleView *)[self.view viewWithTag:alertView.tag];
            if (bubbleV) {
                
                MYTipsType tipType = bubbleV.tipType;
                
                //首先删除被点击的标签
                [_tipArray removeObject:bubbleV];
                [bubbleV removeFromSuperview];
                
                if(tipType == Tip_FoodN || tipType == Tip_Location){
                    for (BubbleView *bv in _tipArray) {
                        if(bv.tipType == Tip_FoodN || bv.tipType == Tip_Location)
                        {
                            [_tipArray removeObject:bv];
                            [bv removeFromSuperview];
                            
                            break;
                        }
                    }
                    
                }
            }
        }
            break;
            
        default:
            break;
    }
}

/**
 *  添加标签
 *
 *  @param isMark   是否为常规标签
 *  @param title    标签标题
 *  @param bubbleId 标签ID
 */
- (void)addBubbleView:(MYTipsType )mtipType bubbleTitle:(NSString *)title bubbleID:(NSString *)bubbleId
{
    NSInteger m_count = [_tipArray count] + _mTAG;

    if (mtipType != Tip_Normal) {
        
        //地点标签跟美食名只能有一个
        for (BubbleView *buV in _tipArray) {
            //不是常规标签
            if (buV.tipType == Tip_FoodN && mtipType == Tip_FoodN) {

                //将已经删除的标签TAG赋值给现在添加的标签
                m_count = buV.tag;
                [_tipArray removeObject:buV];
                [buV removeFromSuperview];
                
                //TODO:break跟return的区别
                //break跳出循环或者某段代码
                //return跳出该函数（方法）
                break;
            }
            
            if (buV.tipType == Tip_Location && mtipType == Tip_Location) {
                m_count = buV.tag;
                [_tipArray removeObject:buV];
                [buV removeFromSuperview];
                
                break;
            }
        }
    }

    
    CGFloat mWith = [self calculateDesLabelheight:title] > 180 ? 170:[self calculateDesLabelheight:title];
    BubbleView *bubbleV = nil;
    
    if (_tipPoint.x > MAINSCREEN.size.width/2) {
        
        mWith = (mWith + 24) > _tipPoint.x ? 1 : (_tipPoint.x - mWith - 24);
        bubbleV = [[BubbleView alloc] initWithFrame:CGRectMake(mWith, _tipPoint.y, 0, 26)
                                      initWithTitle:title
                                         startPoint:_tipPoint
                                            tipType:mtipType];
        CLog(@"所在位置：X = %02f", mWith);
    }
    else
        bubbleV = [[BubbleView alloc] initWithFrame:CGRectMake(_tipPoint.x, _tipPoint.y, 0, 26)
                                      initWithTitle:title
                                         startPoint:_tipPoint
                                            tipType:mtipType];
    
    bubbleV.delegate = self;
    bubbleV.tag = m_count;
    bubbleV.tipID = bubbleId;      // 标签ID
    
    
    [self.imageV addSubview:bubbleV];
    
    [_tipArray addObject:bubbleV];
}

- (void)nextButtonTapped:(id)sender
{
    if ([_tipArray count] == 0 ) {
        AlertWithTitleAndMessage(@"请至少添加一个标签", nil);
        return;
    }
    
    //跳转到发布页面
    ImagesReleasedViewController *pVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"ImagesReleasedViewController"];
    pVC.cacheImage = _cacheImage;
    pVC.watermarkImage = [self syntheticImages];   //测试合成图片
    
    // 传递标签数组
    pVC.tipArray = _tipArray;
    
    if (_pInfo) {
        pVC.pInfo = _pInfo;
    }
    
    [self.navigationController pushViewController:pVC animated:YES];
}


#pragma mark FoodNameViewControllerDelegate
- (void)foodViewControllerSelected:(NSNotification *)notification
{
    CLog(@"%@", notification.object);
    //地点跟美食名永远放在第一跟第二的位置
    {
        
        _tipPoint.y = MAINSCREEN.size.width - 60;
        //地点
        [self placeViewControllerSelected:[notification.object objectForKey:@"PlaceInfo"]];
    }
    
    {
        _fInfo = [notification.object objectForKey:@"FoodInfo"];
        [self performSelector:@selector(drawFoodTips) withObject:nil afterDelay:0.5];
    }
}


- (void)drawFoodTips
{
    _tipPoint.y = MAINSCREEN.size.width - 95;
    [self addBubbleView:Tip_FoodN bubbleTitle:_fInfo.name bubbleID:_fInfo.nameId];
}

/********************************************************************/


//合成图片
- (UIImage *)syntheticImages
{
    // 缩放比例
    CGFloat mscale = self.cacheImage.size.height/self.imageV.frame.size.height;
    UIGraphicsBeginImageContextWithOptions(self.imageV.frame.size, NO, mscale);  //NO，YES 控制是否透明
    [self.imageV.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //返回一个基于当前图形的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    
    
   UIImage *tempImage = [Units addImage:image withImage:[UIImage imageNamed:@"watermark.png"] rect1:CGRectMake(0, 0, MAINSCREEN.size.width*2, MAINSCREEN.size.width*2) rect2:CGRectMake(26, MAINSCREEN.size.width*2-50, 36, 36)];

    return tempImage;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
