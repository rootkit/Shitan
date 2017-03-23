//
//  DMCameraViewController.h
//  Artery
//
//  Created by 刘敏 on 14-10-22.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface DMCameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL                    FrontCamera;        //前摄像头
    
    AVCaptureSession            *session;
    AVCaptureVideoPreviewLayer  *captureVideoPreviewLayer;
    
    AVCaptureStillImageOutput   *stillImageOutput;      //图像输出
    
    UIImage                     *croppedImageWithoutOrientation;
    
}

@property (nonatomic) dispatch_queue_t   sessionQueue;
#pragma mark -
@property (nonatomic, weak) IBOutlet UIButton *photoCaptureButton;    //拍照按钮
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;          //取消按钮

@property (nonatomic, weak) IBOutlet UIButton *photopAlbumButton;     //相册按钮
@property (nonatomic, weak) IBOutlet UIButton *flashButton;           //闪光灯按钮
@property (nonatomic, weak) IBOutlet UIButton *gridButton;            //网格按钮

@property (weak, nonatomic) IBOutlet UIImageView *ImgViewGrid;        //网格

@property (nonatomic, weak) IBOutlet UIView *photoBar;                //拍照按钮所在的View
@property (nonatomic, weak) IBOutlet UIView *topBar;                  //顶部区域

@property (weak, nonatomic) IBOutlet UIView *imagePreview;            //成像区域
@property (weak, nonatomic) IBOutlet UIImageView *captureImage;       //图像区域

@property (weak, nonatomic) IBOutlet UIImageView *upperView;          //上部图像
@property (weak, nonatomic) IBOutlet UIImageView *lowerView;          //下部图像

@property (nonatomic, strong) AVCaptureDeviceInput *inputDevice;        //输入设备

//对焦
@property (nonatomic, strong) UIImageView *focusImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;         //成像区域的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDisTopHight;  //底部菜单距离顶部的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gridviewHight;      //网格的高度


//开关上半部分的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captureAHight;
//开关上半部分的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captureBHight;

//开关上半部分距离顶部的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captureTopHight;
//开关上半部分距离顶部的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captureDownHight;


//关闭相机
- (IBAction)closeButtonTapped:(id)sender;

//网格按钮
- (IBAction)gridButtonTapped:(UIButton *)sender;

//闪光灯
- (IBAction)flashButtonTapped:(UIButton *)sender;

//拍照按钮
- (IBAction)shootButtonTapped:(id)sender;


//相册
- (IBAction)switchToLibrary:(id)sender;

@end
