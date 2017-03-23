////
////  CaptureSessionManager.h
////  Artery
////
////  Created by 刘敏 on 14-9-24.
////  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <AVFoundation/AVFoundation.h>
//
//@protocol CaptureSessionManager;
//
//typedef void(^DidCapturePhotoBlock)(UIImage *stillImage);
//
//
//
//@interface CaptureSessionManager : NSObject
//
//@property (nonatomic) dispatch_queue_t                      sessionQueue;
//@property (nonatomic, strong) AVCaptureSession              *session;
//@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *previewLayer;
//@property (nonatomic, strong) AVCaptureDeviceInput          *inputDevice;           //输入设备
//@property (nonatomic, strong) AVCaptureStillImageOutput     *stillImageOutput;      //图像输出
//@property (nonatomic, strong) AVCaptureMovieFileOutput      *movieFileOutput;       //视频输出
//
////缩放
//@property (nonatomic, assign) CGFloat preScaleNum;
//@property (nonatomic, assign) CGFloat scaleNum;
//
//
//
//@property (nonatomic, assign) id <CaptureSessionManager> delegate;
//
//
//- (void)initializeCamera;
//
//
//- (void)configureWithParentLayer:(UIView*)parent previewRect:(CGRect)preivewRect;
//// 拍照
//- (void)takePicture:(DidCapturePhotoBlock)block;
//// 摄像头切换
//- (void)switchCamera:(BOOL)isFrontCamera;
//
//
//
//- (void)pinchCameraViewWithScalNum:(CGFloat)scale;
//- (void)pinchCameraView:(UIPinchGestureRecognizer*)gesture;
//
////闪光灯模式
//- (void)switchFlashMode:(UIButton*)sender;
//
//- (void)focusInPoint:(CGPoint)devicePoint;
//
//
//- (void)switchGrid:(BOOL)toShow;
//
//@end
//
//@protocol CaptureSessionManager <NSObject>
//
//@optional
//- (void)didCapturePhoto:(UIImage*)stillImage;
//
//@end
