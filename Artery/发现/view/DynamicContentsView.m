//
//  DynamicContentView.m
//  Shitan
//
//  Created by Avalon on 15/5/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//


#import "DynamicContentsView.h"
#import "MLEmojiLabel.h"
#import "ImageLoadingView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HCSStarRatingView.h"
#import "TipInfo.h"
#import "BubbleView.h"

#import "ImageProgressView.h"


@interface DynamicContentsView () <BubbleViewDelegate,MLEmojiLabelDelegate,TTTAttributedLabelDelegate>


//菜品图片
@property (nonatomic, weak) UIImageView *iconImageView;

//菜品星级
@property (nonatomic, weak) HCSStarRatingView *starRatingView;

//菜品评分
@property (nonatomic, weak) UILabel *starLabel;

//菜品描述
@property (nonatomic, weak) MLEmojiLabel *describeLabel;

//等待加载图片
@property (nonatomic, strong) ImageLoadingView *loadingView;


@property (nonatomic, strong) NSMutableArray *bubbleArray;
@property (nonatomic, assign) BOOL isShow;                          //标签是否显示

@end

@implementation DynamicContentsView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpChildView];
        
        self.iconImageView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setUpChildView{
    
    _loadingView = [[ImageLoadingView alloc] init];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    self.iconImageView = iconImageView;
    [self addSubview:self.iconImageView];
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc]init];
    self.starRatingView = starRatingView;
    self.starRatingView.maximumValue = 5;
    self.starRatingView.minimumValue = 0;
    self.starRatingView.tintColor = MAIN_COLOR;
    self.starRatingView.backgroundColor = [UIColor clearColor];
    self.starRatingView.enabled = NO;
    [self addSubview:self.starRatingView];
    
    UILabel *starLabel = [[UILabel alloc] init];
    self.starLabel = starLabel;
    
    [self.starLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self.starLabel setTextColor:MAIN_COLOR];
    [self addSubview:self.starLabel];
    
    MLEmojiLabel *describeLabel = [[MLEmojiLabel alloc] init];
    self.describeLabel = describeLabel;
    self.describeLabel.numberOfLines = 0;
    self.describeLabel.font = [UIFont systemFontOfSize:FontSize];
    self.describeLabel.backgroundColor = [UIColor clearColor];
    self.describeLabel.delegate = self;
    //自定义表情的正则表达式
    self.describeLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    //自定义表情的plist格式
    self.describeLabel.customEmojiPlistName = @"expression";
    //是否需要话题和@功能
    self.describeLabel.isNeedAtAndPoundSign = YES;
    [self addSubview:self.describeLabel];
    
    
}

- (void)setDynamicModelFrame:(DynamicModelFrame *)dynamicModelFrame{
    
    _dynamicModelFrame = dynamicModelFrame;
    
    self.iconImageView.frame = _dynamicModelFrame.imageViewFrame;
    self.starRatingView.frame = _dynamicModelFrame.starBarFrame;
    self.starLabel.frame = _dynamicModelFrame.starLabelFrame;
    self.describeLabel.frame = _dynamicModelFrame.desLabelFrame;
    
    [self setUpChildData];
}

- (void)setUpChildData{
    
    //设置菜品图片
    if (self.dynamicModelFrame.dInfo.imgUrl) {
        [self configureView:self.dynamicModelFrame.dInfo.imgUrl];
    }
    else {
        self.iconImageView.image = [UIImage imageNamed:@"default_image.png"];
    }
    
    //绘制标签
    if (self.dynamicModelFrame.dInfo.tags) {
        [self drawBubbleView:self.dynamicModelFrame.dInfo.tags];
    }
    
    self.iconImageView.userInteractionEnabled = YES;
    
    //开启触摸事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBubble:)];
    tapGesture.delegate = self;
    
    /*
     numberOfTapsRequired;       // Default is 1. The number of taps required to match
     numberOfTouchesRequired;    // Default is 1. The number of fingers required to match
     */
    
    [self.iconImageView addGestureRecognizer:tapGesture];
    
    //设置菜品描述
    
    if (self.dynamicModelFrame.dInfo.imgDesc) {

        self.describeLabel.emojiText = [self.dynamicModelFrame.dInfo.imgDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    }
    
    //设置菜品评级

    self.starRatingView.value = self.dynamicModelFrame.dInfo.score;
    self.starLabel.textAlignment = NSTextAlignmentLeft;
    if(self.dynamicModelFrame.dInfo.score == 0)
    {
       self.starLabel.text = @"未评分";
    }
    else
        [self.starLabel setText:[NSString stringWithFormat:@"%.1f分", (CGFloat)self.dynamicModelFrame.dInfo.score]];
}


#pragma mark - 下载图片
- (void)configureView:(NSString *)imageURL
{
    if (imageURL) {
        [_loadingView showLoading];
        [_loadingView setFrame:CGRectMake(MAINSCREEN.size.width/2, MAINSCREEN.size.width/2, MAINSCREEN.size.width, MAINSCREEN.size.width)];
        [self.iconImageView addSubview:_loadingView];
        
        dispatch_after(0.2, dispatch_get_global_queue(0, 0), ^{
            __block ImageLoadingView *loadingView = _loadingView;

            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                              placeholderImage:[UIImage imageNamed:@"default_image.png"]
                                       options:SDWebImageLowPriority
                                      progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                          
                                          if (!loadingView) {
                                              loadingView = [[ImageLoadingView alloc] init];
                                          }
                                          
                                          if (receivedSize > kMinProgress) {
                                              loadingView.progress = (float)receivedSize/expectedSize;
                                          }
                                      }
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         [loadingView removeFromSuperview];
                                         loadingView = nil;
                                     }];
        });
    }
}

#pragma mark - 绘制标签
//绘制标签
- (void)drawBubbleView:(NSArray *)array
{

    
        for (BubbleView *view in self.iconImageView.subviews)
        {
            if ([view isKindOfClass:[BubbleView class]])
            {
                [view removeFromSuperview];
            }
        }
    
    
    NSInteger mTAG = 9000;
    
    for (TipInfo *tInfo in array) {
        
        CGPoint newPoint = [self fixedCoordinates:CGPointMake(tInfo.point_X, tInfo.point_Y)];
        
        BubbleView *bubbleV = [[BubbleView alloc] initWithFrame:CGRectMake(newPoint.x, newPoint.y, 0, 26) initWithInfo:tInfo];
        
        //校正坐标(出现越界情况)
        CGFloat b_w = bubbleV.frame.size.width;    //自身宽度
        CGFloat m_x = newPoint.x + b_w;            //所处位置
        
        if (m_x >= MAINSCREEN.size.width && !bubbleV.isLeft) {
            bubbleV = nil;
            bubbleV = [[BubbleView alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width - b_w, newPoint.y, 0, 26) initWithInfo:tInfo];
        }
        
        //设置标签TAG值
        bubbleV.tag = mTAG++;
        bubbleV.delegate = self;
        
        [self.iconImageView addSubview:bubbleV];
        
        //填充到标签数组
        [self.bubbleArray addObject:bubbleV];
        
        
        
    }
}

#pragma mark - 修正坐标
- (CGPoint)fixedCoordinates:(CGPoint)oldPoint
{
    //二者取最大值
    CGFloat mBig = self.dynamicModelFrame.dInfo.imgWidth > self.dynamicModelFrame.dInfo.imgHeight ? self.dynamicModelFrame.dInfo.imgWidth : self.dynamicModelFrame.dInfo.imgHeight;
    
    CGFloat m_ratioX = MAINSCREEN.size.width / mBig;        //X轴系数
    CGFloat m_ratioY = MAINSCREEN.size.width / mBig;        //Y轴系数
    
    CGPoint endPoint = CGPointZero;
    
    endPoint.x = oldPoint.x * m_ratioX;
    endPoint.y = oldPoint.y * m_ratioY;
    
    
    //修复越界
    if (endPoint.y > MAINSCREEN.size.width-26) {
        
        endPoint.y = MAINSCREEN.size.width-26;
    }
    
    return endPoint;
}


#pragma mark - 隐藏标签
- (void)hideBubble:(UITapGestureRecognizer *)tapGesture
{
    _isShow = !_isShow;
    
    if (_isShow) {
        //显示
        for (BubbleView *bv in _bubbleArray) {
            [bv setHidden:NO];
        }
    }
    else
    {
        //隐藏
        for (BubbleView *bv in _bubbleArray) {
            [bv setHidden:YES];
        }
    }
}

#pragma mark - 标签的点击事件
- (void)clickBubbleViewWithInfo:(NSInteger)mtag{
    
    
    if (!theAppDelegate.isLogin) {
        STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
        STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
        nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        nc.view.layer.shadowOpacity = 0.2;
        
        [theAppDelegate.mainVC presentViewController:nc animated:YES completion:nil];
        
        return;
    }
    
    if (self.dynamicModelFrame.dInfo.addressId) {
        self.dynamicModelFrame.dInfo.sInfo.addressId = self.dynamicModelFrame.dInfo.addressId;
    }
    
    BubbleView *bubbleView = (BubbleView *)[self.iconImageView viewWithTag:mtag];
    if ([self.delegate respondsToSelector:@selector(dynamicContentsView:bubbleView:sInfo:)]) {
        [self.delegate dynamicContentsView:self bubbleView:bubbleView sInfo:self.dynamicModelFrame.dInfo.sInfo];
    }
  
}

#pragma mark - 懒加载
- (NSMutableArray *)bubbleArray{
    
    if (_bubbleArray == nil) {
        _bubbleArray = [NSMutableArray array];
    }
    return _bubbleArray;
}

@end
