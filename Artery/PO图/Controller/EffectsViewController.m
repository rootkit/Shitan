//
//  EffectsViewController.m
//  Artery
//
//  Created by 刘敏 on 14-10-5.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "EffectsViewController.h"
#import "TaggedViewController.h"
#import "FilterCell.h"
#import "FilterCellModel.h"
#import "FilterTools.h"



@interface EffectsViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *fitArray;        //滤镜数组
@property (nonatomic, unsafe_unretained) IFFilterType currentType;

@property (strong, nonatomic) UIImage *filterImage;     //滤镜图片


@end

@implementation EffectsViewController



- (void)viewWillAppear:(BOOL)animated
{
    //显示navigationController
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"滤镜"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"滤镜"];
}

- (void)backButtonTapped:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadFiltPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FilterList" ofType:@"plist"];
    self.fitArray = [[NSArray alloc] initWithContentsOfFile:path];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // 设置标题
    self.title = @"选择滤镜";
    
    [self loadFiltPlist];

    _filterImage = _cacheImage;
    
    CLog(@"图片宽度%02f", _cacheImage.size.width);
    CLog(@"图片高度%02f", _cacheImage.size.height);
    
    _imageHight.constant = MAINSCREEN.size.width;
    
    [_effButton setBackgroundImage:_filterImage forState:UIControlStateNormal];
    [_effButton setBackgroundImage:_cacheImage forState:UIControlStateHighlighted];
    
    //设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customWithTitle:@"下一步" target:self action:@selector(nextButtonTapped:)];
    
    // 滤镜菜单
    _fitScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    
    
    
    if ([UIDevice isRunningOniPhone4]) {
        [_fitScrollView setFrame:CGRectMake(0, MAINSCREEN.size.width, MAINSCREEN.size.width, 130)];
    }
    else
    {
        [_fitScrollView setFrame:CGRectMake(0, MAINSCREEN.size.height-200, MAINSCREEN.size.width, 130)];
    }

    
    _fitScrollView.contentSize = CGSizeMake(12+[_fitArray count]*91+6, 130);
    _fitScrollView.showsHorizontalScrollIndicator = NO;
    _fitScrollView.showsVerticalScrollIndicator = NO;
    _fitScrollView.scrollsToTop = NO;
    _fitScrollView.delegate = self;
    
    [self.view addSubview:_fitScrollView];
    
    
    [self setupFilterButtons];
}


// 绘制按钮
- (void)setupFilterButtons
{
    NSDictionary *item = nil;
    
    for (int i=0; i<[_fitArray count]; i++) {
        
        item = [_fitArray objectAtIndex:i];
        
        
        UIButton* fButton = [[UIButton alloc] initWithFrame:CGRectMake(12+i*91, 16, 73, 73)];

        
        [fButton setBackgroundImage:[UIImage imageNamed:[item objectForKey:@"image"]] forState:UIControlStateNormal];
        [fButton setBackgroundImage:[UIImage imageNamed:[item objectForKey:@"image"]] forState:UIControlStateHighlighted];
        [fButton setImage:[UIImage imageNamed:@"filter_sel.png"] forState:UIControlStateSelected];
        
        [fButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        fButton.tag = i+5000;
		[_fitScrollView addSubview:fButton];
        
        
        if (i == 0) {
            fButton.selected = YES;
        }
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+i*91, 94, 73, 21)];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.shadowColor = [UIColor grayColor];
        nameLabel.shadowOffset = CGSizeMake(0, -0.2);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = [item objectForKey:@"name"];
        
        [_fitScrollView addSubview:nameLabel];
        
    }
}


- (void)filterButtonTapped:(UIButton *)sender
{
    NSInteger row = sender.tag - 5000;
    sender.selected = !sender.selected;
    
    for (int i=0; i<[_fitArray count]; i++)
    {
        UIButton* fButton = (UIButton *)[self.fitScrollView viewWithTag:i+5000];
        if (fButton) {
            if (i != row) {
                fButton.selected = NO;
            }
        }
    }
    
    
    
    self.currentType = (IFFilterType)row;
    FilterTools *filterTools = [[FilterTools alloc] init];

    _filterImage = [Units image:[filterTools switchFilter:self.currentType rawImage:self.cacheImage] rotation:UIImageOrientationUp];

    [_effButton setBackgroundImage:_filterImage forState:UIControlStateNormal];
}



- (void)nextButtonTapped:(id)sender
{
    //跳转到设置标签页面
    TaggedViewController * eVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"TaggedViewController"];
    eVC.cacheImage = _filterImage;
    [self.navigationController pushViewController:eVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
