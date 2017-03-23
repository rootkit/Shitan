//
//  ScreenView.m
//  Shitan
//
//  Created by Richard Liu on 15/9/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ScreenView.h"
#import "CityDao.h"
#import "CityInfo.h"
#import "ClassInfo.h"
#import "RecommendDAO.h"
#import "MYButton.h"

#define BTN_W    80


@interface ScreenView ()

/** 记录父视图的bouns */
@property (nonatomic, assign) CGRect superViewBouns;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, strong) NSArray *tableArray;      //最新

@property (nonatomic, strong) NSArray *areaArray;       //区
@property (nonatomic, strong) NSArray *circleArray;     //商圈

@property (nonatomic, strong) NSArray *classArray;

@property (nonatomic, weak) UILabel *titL;


@property (nonatomic, strong) RecommendDAO *dao;
@property (nonatomic, strong) CityDao *cityDAO;

@property (nonatomic, assign) CGFloat TOP_H;

@property (nonatomic, weak) UIImageView *traV;


@end

@implementation ScreenView


+ (instancetype)screenView
{
    ScreenView *view = [[ScreenView alloc] init];
    return view;
}


- (void)showScreenViewToView:(UIView *)superView
{
    self.superViewBouns = superView.bounds;
    
    self.frame = CGRectMake(0, superView.bounds.size.height, superView.bounds.size.width, superView.bounds.size.height);
    
    [superView addSubview:self];
    
    [self setUpUI];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 0, superView.bounds.size.width, superView.bounds.size.height);
    }];
}

#pragma mark - 初始化
- (void)initDAO
{
    if (!_dao) {
        self.dao = [[RecommendDAO alloc] init];
    }
    
    if(!_cityDAO)
    {
        _cityDAO = [[CityDao alloc] init];
    }
}



- (void)setSType:(STConditionButtonType)sType
{
    _sType = sType;
    
    switch (_sType) {
        case STConditionButtonTypeNew:
            _tableArray = [[NSArray alloc] initWithObjects:@"最新", @"最热", @"最近", nil];
            [self drawBtton];
            [_titL setText:@"排序"];
            break;
            
        case STConditionButtonTypeArea:
            [self initDAO];
            [self getRegionalList];
            [_titL setText:@"目标区域"];
            break;
            
        case STConditionButtonTypePersonality:
        {
            [self initDAO];
            [self getClassifyList];
            [_titL setText:@"个性分类"];
        }
            break;
            
        default:
            break;
    }
}

- (void)setUpUI
{
    //背景
    UIView *bgV = [[UIView alloc] initWithFrame:self.bounds];
    bgV.backgroundColor = [UIColor whiteColor];
    bgV.alpha  = 0.90;
    [self addSubview:bgV];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, MAINSCREEN.size.width-20, 1)];
    [la setBackgroundColor:MAIN_TIME_COLOR];
    [self addSubview:la];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 22.0f, 50, 40)];
    _backBtn = backBtn;
    [_backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setImage:@"icon_close.png" setSelectedImage:@"icon_close.png"];
    [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    //标题
    UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, MAINSCREEN.size.width, 44)];
    _titL = titL;
    [_titL setTextAlignment:NSTextAlignmentCenter];
    [_titL setTextColor:[UIColor blackColor]];
    [_titL setFont:[UIFont boldSystemFontOfSize:17.0]];
    [self addSubview:_titL];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, MAINSCREEN.size.width, MAINSCREEN.size.height-45)];
    _scrollView = scrollView;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
}


- (void)back:(id)sender
{
    [self hideView];
}



//关闭view
- (void)hideView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, self.superViewBouns.size.height, self.superViewBouns.size.width, self.superViewBouns.size.height);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark  最新

- (void)drawBtton
{
    CLog(@"%lu", (unsigned long)_indexA);
    
    CGFloat interval_H = (MAINSCREEN.size.width - BTN_W*_tableArray.count)/ (_tableArray.count+1);
    
    NSUInteger i = 0;
    for (NSString *st in _tableArray) {
        MYButton *btn = [[MYButton alloc] initWithFrame:CGRectMake(interval_H*(i+1)+BTN_W*i, 120, BTN_W, BTN_W)];
        [btn setTitle:st forState:UIControlStateNormal];

        [self addSubview:btn];
        btn.tag = 100+i;
        
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        
        if (i == _indexA) {
            btn.selected = YES;
        }
        
        

        [btn addTarget:self action:@selector(buttonATapped:) forControlEvents:UIControlEventTouchUpInside];
        i ++;
    }
}

- (void)buttonATapped:(MYButton *)sender
{
    NSString *tt = [_tableArray objectAtIndex:sender.tag-100];
    if (_delegate && [_delegate respondsToSelector:@selector(screenView:seletedBtnWithKeyword:seletedWithCityID:type:)]) {
        [_delegate screenView:self seletedBtnWithKeyword:tt seletedWithCityID:nil type:STConditionButtonTypeNew];
    }
    
    [self hideView];
}


#pragma mark  区域筛选

//获取区
- (void)getRegionalList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [dict setObject:theAppDelegate.cInfo.cityId forKey:@"cityId"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"classType"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"parentId"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_dao getClassifyFindList:requestDict completionBlock:^(NSDictionary *result) {
        if (result.code == 200) {
            self.areaArray = [self pairsClassifyData:result.obj];
            [self drawAreaUI];
            
            ClassInfo *mI = [self.areaArray objectAtIndex:0];
            self.circleArray  = mI.classArray;
            [self drawCircleUI];
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}



- (NSArray *)pairsData:(NSArray *)array
{
    if (!array) {
        return nil;
    }
    
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *item in array) {
        CityInfo *rInfo = [[CityInfo alloc] initWithParsData:item];
        [tempA addObject:rInfo];
    }
    
    return tempA;

}

- (void)drawAreaUI
{
    //距离边界12，5个间隙
    CGFloat interval_H = 12.0f;
    CGFloat btn_W = (MAINSCREEN.size.width - 60)/4;
    CGFloat btn_H = 32.0f;
    
    
    NSUInteger mx, my;
    
    for(int i = 0; i< [_areaArray count]; i++)
    {
        my = i/4;
        mx = i%4;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(interval_H+(btn_W + interval_H)*mx, 25+ (btn_H +20)*my, btn_W, btn_H)];
        [btn setBackgroundImage:@"btn38_grey" setSelectedBackgroundImage:@"btn38_black"];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [btn addTarget:self action:@selector(areaTapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i+200];
        
        if (i == 0) {
            btn.selected = YES;
            UIImageView *traV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)-btn_W/2-6, CGRectGetMaxY(btn.frame), 12, 5)];
            _traV = traV;
            [_traV setImage:[UIImage imageNamed:@"Triangle"]];
            [self.scrollView addSubview:_traV];
        }
        
        [_scrollView addSubview:btn];
        

        ClassInfo *rInfo = self.areaArray[i];
        [btn setTitle:rInfo.cName forState:UIControlStateNormal];
        
        
        _TOP_H = CGRectGetMaxY(btn.frame) + 40;
    }
}


- (void)areaTapped:(UIButton *)sender
{
    sender.selected = YES;
    
    CGFloat btn_W = (MAINSCREEN.size.width - 60)/4;
    [_traV setFrame:CGRectMake(CGRectGetMaxX(sender.frame)-btn_W/2-6, CGRectGetMaxY(sender.frame), 12, 5)];
    
    for (int i = 0; i<= [_areaArray count]; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i+200];
        if (sender.tag != btn.tag) {
            btn.selected = NO;
        }
    }
    
    
    [self clearBtn];

    ClassInfo *rInfo = self.areaArray[sender.tag -200];
    self.circleArray = rInfo.classArray;
    [self drawCircleUI];
    
}

//绘制商圈
- (void)drawCircleUI
{
    CGFloat btn_W = (MAINSCREEN.size.width - 60)/4;
    CGFloat interval_H = 12.0f;
    
    CGFloat MAX_H = 0.0f;
    
    NSUInteger mx, my;
    
    for(int i = 0; i< [_circleArray count]; i++)
    {
        my = i/4;
        mx = i%4;
        MYButton *btn = [[MYButton alloc] initWithFrame:CGRectMake(interval_H+(btn_W + interval_H)*mx, _TOP_H+ (btn_W +20)*my, btn_W, btn_W)];
        
        ClassInfo *rInfo = self.circleArray[i];
        [btn setTitle:rInfo.cName forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        
        if ([rInfo.cName  isEqualToString:_areaKey]) {
            btn.selected = YES;
        }
        
        btn.tag = 300+i;
        
        //圆角

        [btn addTarget:self action:@selector(buttonBTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:btn];
        MAX_H = CGRectGetMaxY(btn.frame) + 40;
        
    }
    
    //设置
    [_scrollView setContentSize:CGSizeMake(MAINSCREEN.size.width, MAX_H)];
}

- (void)clearBtn
{
    for(int i = 0; i< [_circleArray count]; i++)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:300+i];
        if (btn) {
            [btn removeFromSuperview];
        }
    }
}


- (void)buttonBTapped:(MYButton *)sender
{
    ClassInfo *rInfo = [_circleArray objectAtIndex:sender.tag-300];
    if (_delegate && [_delegate respondsToSelector:@selector(screenView:seletedBtnWithKeyword:seletedWithCityID:type:)]) {
        [_delegate screenView:self seletedBtnWithKeyword:rInfo.cName seletedWithCityID:rInfo.cId type:STConditionButtonTypeArea];
    }
    
    [self hideView];
}


#pragma mark  分类
- (void)getClassifyList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dict setObject:theAppDelegate.cInfo.cityId forKey:@"cityId"];
    [dict setObject:[NSNumber numberWithInteger:0] forKey:@"parentId"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"classType"];

    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];

    [_dao getClassifyFindList:requestDict completionBlock:^(NSDictionary *result) {
        if (result.code == 200) {
            self.classArray = [self pairsClassifyData:result.obj];
            [self drawClassUI];
            ClassInfo *mI = [self.classArray objectAtIndex:0];
            self.circleArray  = mI.classArray;
            [self drawClassALLUI];            
        }
    } setFailedBlock:^(NSDictionary *result) {

    }];
}



- (NSArray *)pairsClassifyData:(NSArray *)array
{
    if (!array) {
        return nil;
    }

    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *item in array) {
        ClassInfo *rInfo = [[ClassInfo alloc] initWithParsData:item];
        [tempA addObject:rInfo];

    }

    return tempA;
}


- (void)drawClassUI
{
    //距离边界12，5个间隙
    CGFloat interval_H = 12.0f;
    CGFloat btn_W = (MAINSCREEN.size.width - 60)/4;
    CGFloat btn_H = 32.0f;
    
    
    NSUInteger mx, my;
    
    for(int i = 0; i< [_classArray count]; i++)
    {
        my = i/4;
        mx = i%4;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(interval_H+(btn_W + interval_H)*mx, 25 + (btn_H +20)*my, btn_W, btn_H)];
        [btn setBackgroundImage:@"btn38_grey" setSelectedBackgroundImage:@"btn38_black"];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [btn addTarget:self action:@selector(classATapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i+200];
        [_scrollView addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            UIImageView *traV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)-btn_W/2-6, CGRectGetMaxY(btn.frame), 12, 5)];
            _traV = traV;
            [_traV setImage:[UIImage imageNamed:@"Triangle"]];
            [self.scrollView addSubview:_traV];
        }
        

        ClassInfo *rInfo = self.classArray[i];
        [btn setTitle:rInfo.cName forState:UIControlStateNormal];
        
        _TOP_H = CGRectGetMaxY(btn.frame) + 40;
    }

}


- (void)drawClassALLUI
{
    CGFloat btn_W = (MAINSCREEN.size.width - 60)/4;
    CGFloat interval_H = 12.0f;
    
    NSUInteger mx, my;
    
    CGFloat MAX_H = 0.0;
    
    for(int i = 0; i< [_circleArray count]; i++)
    {
        my = i/4;
        mx = i%4;
        MYButton *btn = [[MYButton alloc] initWithFrame:CGRectMake(interval_H+(btn_W + interval_H)*mx, _TOP_H+ (btn_W +20)*my, btn_W, btn_W)];
        
        ClassInfo *rInfo = self.circleArray[i];
        [btn setTitle:rInfo.cName forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        
        
        if ([rInfo.cName  isEqualToString:_classKey]) {
            btn.selected = YES;
        }
        
        btn.tag = 300+i;
        

        [btn addTarget:self action:@selector(buttonCTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:btn];
        
        MAX_H = CGRectGetMaxY(btn.frame) + 40;
        
    }
    
    //设置
    [_scrollView setContentSize:CGSizeMake(MAINSCREEN.size.width, MAX_H)];
}

- (void)classATapped:(UIButton *)sender
{
    sender.selected = YES;
    
    CGFloat btn_W = (MAINSCREEN.size.width - 60)/4;
    [_traV setFrame:CGRectMake(CGRectGetMaxX(sender.frame)-btn_W/2-6, CGRectGetMaxY(sender.frame), 12, 5)];
    
    for (int i = 0; i<= [_classArray count]; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i+200];
        if (sender.tag != btn.tag) {
            btn.selected = NO;
        }
    }
    
    [self clearBtn];
    
    ClassInfo *rInfo = self.classArray[sender.tag -200];
    self.circleArray = rInfo.classArray;
    [self drawClassALLUI];

}


- (void)buttonCTapped:(MYButton *)sender
{
    ClassInfo *rInfo = [_circleArray objectAtIndex:sender.tag-300];
    if (_delegate && [_delegate respondsToSelector:@selector(screenView:seletedBtnWithKeyword:seletedWithCityID:type:)]) {
        [_delegate screenView:self seletedBtnWithKeyword:rInfo.cName seletedWithCityID:rInfo.cId type:STConditionButtonTypePersonality];
    }
    
    [self hideView];
}


@end
