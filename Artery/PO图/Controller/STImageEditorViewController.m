//
//  STImageEditorViewController.m
//  Artery
//
//  Created by 刘敏 on 15/1/10.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STImageEditorViewController.h"
#import "KICropImageView.h"
#import "EffectsViewController.h"

#define orgHeight ((64 + MAINSCREEN.size.width) + (MAINSCREEN.size.height - (64 + MAINSCREEN.size.width))/2 - 15)

@interface STImageEditorViewController (){
    
    KICropImageView *_cropImageView;
}

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) UIImageView *iconView;

@end

@implementation STImageEditorViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //隐藏navigationController
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [MobClick beginLogPageView:@"相册图片裁剪"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"相册图片裁剪"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.index = 0;
    
    _cropImageView = [[KICropImageView alloc] initWithFrame:MAINSCREEN];
    [_cropImageView setCropSize:CGSizeMake(MAINSCREEN.size.width, MAINSCREEN.size.width)];
    [_cropImageView setImage:_cacheImage];
    
    [self.view addSubview:_cropImageView];
    
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat mHeight = 17;
    [cancelBtn setFrame:CGRectMake(45, mHeight, 45, 45)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
    //cancelBtn.backgroundColor = [UIColor yellowColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    
    //选取按钮
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setFrame:CGRectMake(MAINSCREEN.size.width-90, mHeight, 45, 45)];
    [selectBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [selectBtn setTitle:@"选取" forState:UIControlStateNormal];
    //[selectBtn setImage:[UIImage imageNamed:@"camera_icon_06"] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    //selectBtn.backgroundColor = [UIColor yellowColor];
    
    
    //添加裁剪方式按钮
    UIButton *tailorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mHeight = (64 + MAINSCREEN.size.width) + (MAINSCREEN.size.height - (64 + MAINSCREEN.size.width))/2 - 22.5;
    [tailorBtn setFrame:CGRectMake(45, mHeight, 45, 45)];
    [tailorBtn setBackgroundImage:@"rectangular_btn.png" setSelectedBackgroundImage:@"square_btn.png"];
    [tailorBtn addTarget:self action:@selector(tailorBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tailorBtn];
    //tailorBtn.backgroundColor = [UIColor yellowColor];
    
    //旋转按钮
    UIButton *rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotateBtn setFrame:CGRectMake(MAINSCREEN.size.width-90, tailorBtn.frame.origin.y, 45, 45)];
    [rotateBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    //[rotateBtn setTitle:@"旋转" forState:UIControlStateNormal];
    [rotateBtn setImage:[UIImage imageNamed:@"camera_icon_09"] forState:UIControlStateNormal];
    [rotateBtn addTarget:self action:@selector(rotateBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotateBtn];
    //rotateBtn.backgroundColor = [UIColor yellowColor];

}


//取消
- (void)cancelTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//选取图片
- (void)selectTapped:(id)sender
{
    NSData *data = UIImageJPEGRepresentation([_cropImageView cropImage], 1.0);

    //跳转到特效页面（滤镜）
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"CameraStoryboard" bundle:nil];
    EffectsViewController * eVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"EffectsViewController"];
    eVC.cacheImage = [UIImage imageWithData:data];
 
    
    [self.navigationController pushViewController:eVC animated:YES];
}


//图片裁剪方式
- (void)tailorBtnTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        //长方形
        [_cropImageView photoFilling];
    }
    else
    {
        [_cropImageView.scrollView setZoomScale:1.0 animated:NO];
        //正常
        [_cropImageView updateZoomScale];
        
    }
}

//
- (void)rotateBtnTapped:(UIButton *)sender{
    
    self.index++;
    
    //UIImage *newImage = [[UIImage alloc] init];
    
    switch (self.index % 4) {
        case 1:
            self.cacheImage = [UIImage imageWithCGImage:self.cacheImage.CGImage scale:1 orientation:UIImageOrientationRight];
            break;
        case 2:
            self.cacheImage = [UIImage imageWithCGImage:self.cacheImage.CGImage scale:1 orientation:UIImageOrientationDown];
            break;
        case 3:
            self.cacheImage = [UIImage imageWithCGImage:self.cacheImage.CGImage scale:1 orientation:UIImageOrientationLeft];
            break;
        case 0:
            self.cacheImage = [UIImage imageWithCGImage:self.cacheImage.CGImage scale:1 orientation:UIImageOrientationUp];
            break;
            
        default:
            break;
    }
    
    [_cropImageView setImage:self.cacheImage];
}




@end
