//
//  DMCameraViewController.m
//  Artery
//
//  Created by 刘敏 on 14-10-22.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

//
//  ARC Helper
#ifndef ah_retain
#if __has_feature(objc_arc)
#define ah_retain self
#define ah_dealloc self
#define release self
#define autorelease self
#else
#define ah_retain retain
#define ah_dealloc dealloc
#define __bridge
#endif
#endif

//  ARC Helper ends


//对焦
#define ADJUSTINT_FOCUS @"adjustingFocus"
#define LOW_ALPHA   0.7f
#define HIGH_ALPHA  1.0f


#import "DMCameraViewController.h"
#import "EffectsViewController.h"
#import "UIImage+UIImageScale.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "STImageEditorViewController.h"


@interface DMCameraViewController ()
{
    int             alphaTimes;
    CGPoint         currTouchPoint;     //点击的位置（对焦框的位置）
    
}

@property (nonatomic, assign) BOOL isOpenCamera;
@property (nonatomic, strong) ALAssetsLibrary *library;

@end

@implementation DMCameraViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //隐藏navigationController
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //隐藏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    self.captureImage.hidden = YES;
    
    if (_isOpenCamera) {
        [self performSelector:@selector(openCaptureView) withObject:nil afterDelay:0.2];
    }
    else{
        _isOpenCamera = YES;
    }
    
    
    [MobClick beginLogPageView:@"拍照"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"拍照"];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_ImgViewGrid setHidden:YES];
    
    _library = [[ALAssetsLibrary alloc] init];
    
    _isOpenCamera = YES;
        
    // Today Implementation
    FrontCamera = NO;

    croppedImageWithoutOrientation = [[UIImage alloc] init];
    
    _imageWidth.constant = MAINSCREEN.size.width;
    _gridviewHight.constant = MAINSCREEN.size.width;
    _bottomDisTopHight.constant = MAINSCREEN.size.width+44;
    
    
    _captureAHight.constant = MAINSCREEN.size.width/2.0;
    _captureBHight.constant = 194/320.0 *MAINSCREEN.size.width;
    
    _captureTopHight.constant = 44.0;
    _captureDownHight.constant = MAINSCREEN.size.width - _captureBHight.constant + 44.0;
    
    
    //隐藏相册按钮
    [_photopAlbumButton setHidden:YES];
    
}


// 初始化相机
- (void) initializeCamera {
    
    if (session)
    {
        [session release];
        session = nil;
    }
    session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    //创建队列
    [self createQueue];

    if (captureVideoPreviewLayer)
    {
        [captureVideoPreviewLayer release];
        captureVideoPreviewLayer = nil;
    }
	captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	captureVideoPreviewLayer.frame = self.imagePreview.bounds;
	[self.imagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    
    
   
	
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
//    NSArray *devices = [AVCaptureDevice devices];
//    AVCaptureDevice *frontCamera=nil;
//    AVCaptureDevice *backCamera=nil;
//    
//    //检查设备是否可用
//    if (devices.count == 0) {
//        CLog(@"相机不可用");
//        [self disableCameraDeviceControls];
//        return;
//    }
//    
    //4、input
    [self addVideoInputFrontCamera:NO];
    
//    NSError *error = nil;
//    for (AVCaptureDevice *device in devices) {
//        
//        CLog(@"设备名称: %@", [device localizedName]);
//        
//        if ([device hasMediaType:AVMediaTypeVideo]) {
//
//                backCamera = device;
//                AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
//                if (!error) {
//                    if ([_session canAddInput:backFacingCameraDeviceInput]) {
//                        [_session addInput:backFacingCameraDeviceInput];
//                        self.inputDevice = backFacingCameraDeviceInput;
//                    } else {
//                        SCDLog(@"Couldn't add back facing video input");
//                    }
//                }
//
//                
//            }
//            else {
//                CLog(@"设备位置 : 前置摄像头");
//                frontCamera = device;
//            }
//        }
//    }
    
    
//            if ([device position] == AVCaptureDevicePositionBack) {
//                CLog(@"设备位置 : 后置摄像头");
//    //闪光灯
//    if (!FrontCamera) {
//        
//        if ([backCamera hasFlash]){
//            [backCamera lockForConfiguration:nil];
//            if (self.flashButton.selected)
//                [backCamera setFlashMode:AVCaptureFlashModeOn];
//            else
//                [backCamera setFlashMode:AVCaptureFlashModeOff];
//            [backCamera unlockForConfiguration];
//            
//            [self.flashButton setEnabled:YES];
//        }
//        else{
//            if ([backCamera isFlashModeSupported:AVCaptureFlashModeOff]) {
//                [backCamera lockForConfiguration:nil];
//                [backCamera setFlashMode:AVCaptureFlashModeOff];
//                [backCamera unlockForConfiguration];
//            }
//            [self.flashButton setEnabled:NO];
//        }
//        
//        NSError *error = nil;
//        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
//        if (!input) {
//            CLog(@"ERROR: trying to open camera: %@", error);
//        }
//        [session addInput:input];
//    }
    
//    if (FrontCamera) {
//        [self.flashButton setEnabled:NO];
//        NSError *error = nil;
//        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
//        if (!input) {
//            CLog(@"ERROR: trying to open camera: %@", error);
//        }
//        [session addInput:input];
//    }
    
    //设备输出
    if (stillImageOutput)
        [stillImageOutput release];
        stillImageOutput = nil;
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil] autorelease];
    
    [stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:stillImageOutput];
    
    //对焦框
    [self addFocusView];
    
	[session startRunning];
}

/**
 *  添加输入设备
 *
 *  @param front 前或后摄像头
 */
- (void)addVideoInputFrontCamera:(BOOL)front {
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        CLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                CLog(@"Device position : back");
                backCamera = device;
                
            }  else {
                CLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    NSError *error = nil;
    
    if (front) {
        AVCaptureDeviceInput *frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!error) {
            if ([session canAddInput:frontFacingCameraDeviceInput]) {
                [session addInput:frontFacingCameraDeviceInput];
                self.inputDevice = frontFacingCameraDeviceInput;
                
            } else {
                CLog(@"Couldn't add front facing video input");
            }
        }
    } else {
        AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!error) {
            if ([session canAddInput:backFacingCameraDeviceInput]) {
                [session addInput:backFacingCameraDeviceInput];
                self.inputDevice = backFacingCameraDeviceInput;
            } else {
                CLog(@"Couldn't add back facing video input");
            }
        }
    }
}





#pragma mark 按钮响应事件
// 关闭相机
- (void)closeButtonTapped:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        //显示
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }];
}


//闪光灯
- (IBAction)flashButtonTapped:(UIButton *)sender{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (!captureDeviceClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有拍照功能" delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }

    NSString *imgStr = @"";
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    
    if ([device hasFlash]) {
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            imgStr = @"flashing_on.png";
            
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
            imgStr = @"flashing_auto.png";
            
        } else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
            imgStr = @"flashing_off.png";
            
        }
        
        if (sender) {
            [sender setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有闪光灯功能" delegate:nil cancelButtonTitle:@"噢T_T" otherButtonTitles: nil];
        [alert show];
    }

    [device unlockForConfiguration];

}


//网格按钮
- (IBAction)gridButtonTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [_ImgViewGrid setHidden:NO];
    }
    else
        [_ImgViewGrid setHidden:YES];
}


//拍照按钮
- (IBAction)shootButtonTapped:(id)sender{
    [self closeCaptureView];
    [self capImage];
}

//相册
- (IBAction)switchToLibrary:(id)sender
{
    if (session) {
        [session stopRunning];
    }
    
    [self closeCaptureView];
    
    [self performSelector:@selector(openPhotosAlbum) withObject:nil afterDelay:0.5f];
}

- (void)openPhotosAlbum
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:imagePicker animated:NO completion:nil];

}



- (void) capImage {
    //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    CLog(@"关于请求捕获: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}


//过程捕获图像,作物,大小和旋转
- (void)processImage:(UIImage *)image {
    
    // Resize image to 1280*1280
    // Resize image
    UIImage *smallImage = [self imageWithImage:image scaledToWidth:1280];

    /**
     *  图像裁剪
     *  1.先裁剪宽度，再裁剪高度   2、所取得图像为正中心的部分
     *
     *  @param 0
     *  @param 取正中心位置 (smallImage.size.height-smallImage.size.width)/2 为差值
     *
     *  @return
     */
    NSInteger height = (smallImage.size.height-smallImage.size.width)/2;
    CGRect cropRect = CGRectMake(0, height, 1280,  1280);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    
    croppedImageWithoutOrientation = [[UIImage imageWithCGImage:imageRef] copy];
    
    UIImage *croppedImage = nil;
    
    // 调整图像的方向
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationLandscapeLeft:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationLeft] autorelease];
            break;
        case UIDeviceOrientationLandscapeRight:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationRight] autorelease];
            break;
            
        case UIDeviceOrientationFaceUp:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationUp] autorelease];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            croppedImage = [[[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationDown] autorelease];
            break;
            
        default:
            croppedImage = [UIImage imageWithCGImage:imageRef];
            break;
    }
    
    CGImageRelease(imageRef);
    
    [self.captureImage setImage:croppedImage];
    
    //保存拍摄的图片到相册
    [_library saveImage:croppedImage toAlbum:@"食探" completion:^(NSURL *assetURL, NSError *error) {
        CLog(@"你好，阳光！");
        
    } failure:^(NSError *error) {
        if (error != nil) {
            CLog(@"Big error: %@", [error description]);
        }
    }];
    
    [self setCapturedImage];
}

// 图片裁剪
- (UIImage*)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)setCapturedImage{
    // Stop capturing image
    [session stopRunning];
    
    // Hide Top/Bottom controller after taking photo for editing
    [self jumpToNext];
}


- (void)jumpToNext
{
    //跳转到特效页面（滤镜）
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"CameraStoryboard" bundle:nil];
    EffectsViewController * eVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"EffectsViewController"];
    eVC.cacheImage = self.captureImage.image;

    
    CLog(@"%02f, %02f", self.captureImage.image.size.width, self.captureImage.image.size.height);
    
    [self.navigationController pushViewController:eVC animated:YES];
}

//关闭相机显示区域
- (void)closeCaptureView{
    [UIView animateWithDuration:0.3
					 animations:^ {
                         _captureTopHight.constant = 44.0;
                         _captureDownHight.constant = MAINSCREEN.size.width - _captureBHight.constant + 44;
						 [self.view layoutIfNeeded];
					 }
					 completion:^(BOOL finished) {
					 }];
}


//打开相机显示区域
- (void)openCaptureView{
    
    _captureTopHight.constant = 44.0;
    _captureDownHight.constant = MAINSCREEN.size.width - _captureBHight.constant + 44.0;
    
	[UIView animateWithDuration:0.4
					 animations:^ {
                         
                         _captureTopHight.constant = 44 - MAINSCREEN.size.width/2.0;
                         _captureDownHight.constant = 44 + MAINSCREEN.size.width;
                         [self.view layoutIfNeeded];

                         //初始化相机
                         [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.1];
					 }];

}


#pragma mark - Device Availability Controls
- (void)disableCameraDeviceControls{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _isOpenCamera = NO;

    if (info)
    {
        UIImage* outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (outputImage == nil)
        {
            outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (outputImage)
        {
            
            CLog(@"%02f, %02f", outputImage.size.height, outputImage.size.width);
            
            self.captureImage.hidden = NO;
            self.captureImage.image = outputImage;
            
            [self dismissViewControllerAnimated:YES completion:nil];

            //从相册中读取图片到图片编辑界面
            STImageEditorViewController *sv = CREATCONTROLLER(STImageEditorViewController);
            sv.cacheImage = outputImage;
            [self.navigationController pushViewController:sv animated:YES];
        }
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -------------对焦---------------
//对焦的框
- (void)addFocusView {
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus_x.png"]];
    [imgView setFrame:CGRectMake(-74, -74, 73, 73)];
    imgView.alpha = 0;
    [self.imagePreview addSubview:imgView];
    self.focusImageView = imgView;
    
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device addObserver:self forKeyPath:ADJUSTINT_FOCUS options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
#endif
}

#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
//监听对焦是否完成了
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ADJUSTINT_FOCUS]) {
        BOOL isAdjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        
        CLog(@"是否调整对焦点? %@", isAdjustingFocus ? @"YES" : @"NO" );
        CLog(@"Change dictionary: %@", change);
        
        if (!isAdjustingFocus) {
            alphaTimes = -1;
        }
    }
}

- (void)showFocusInPoint:(CGPoint)touchPoint {
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        int alphaNum = (alphaTimes % 2 == 0 ? HIGH_ALPHA : LOW_ALPHA);
        self.focusImageView.alpha = alphaNum;
        alphaTimes++;
        
    } completion:^(BOOL finished) {
        
        if (alphaTimes != -1) {
            [self showFocusInPoint:currTouchPoint];
        } else {
            self.focusImageView.alpha = 0.0f;
        }
    }];
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    alphaTimes = -1;
    
    UITouch *touch = [touches anyObject];
    currTouchPoint.x = [touch locationInView:self.view].x;
    currTouchPoint.y = [touch locationInView:self.view].y-37;
    
    if (CGRectContainsPoint(captureVideoPreviewLayer.bounds, currTouchPoint) == NO) {
        return;
    }
    
    [self focusInPoint:currTouchPoint];
    
    //对焦框
    [_focusImageView setCenter:currTouchPoint];
    
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    [UIView animateWithDuration:0.1f animations:^{
        _focusImageView.alpha = HIGH_ALPHA;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self showFocusInPoint:currTouchPoint];
    }];
#else
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusImageView.alpha = 1.f;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _focusImageView.alpha = 0.f;
        } completion:nil];
    }];
#endif
}


/**
 *  点击后对焦
 *
 *  @param devicePoint 点击的point
 */
- (void)focusInPoint:(CGPoint)devicePoint {
    devicePoint = [self convertToPointOfInterestFromViewCoordinates:devicePoint];
	[self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange {
    
	dispatch_async(_sessionQueue, ^{
		AVCaptureDevice *device = [_inputDevice device];
		NSError *error = nil;
		if ([device lockForConfiguration:&error])
		{
			if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
			{
				[device setFocusMode:focusMode];
				[device setFocusPointOfInterest:point];
			}
			if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
			{
				[device setExposureMode:exposureMode];
				[device setExposurePointOfInterest:point];
			}
			[device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
			[device unlockForConfiguration];
		}
		else
		{
			CLog(@"%@", error);
		}
	});
}



/**
 *  外部的point转换为camera需要的point(外部point/相机页面的frame)
 *
 *  @param viewCoordinates 外部的point
 *
 *  @return 相对位置的point
 */
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates {
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = captureVideoPreviewLayer.bounds.size;
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = captureVideoPreviewLayer;
    
    if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResize]) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    }
    else
    {
        CGRect cleanAperture;
        
        for(AVCaptureInputPort *port in [[session.inputs lastObject]ports])
        {
            if([port mediaType] == AVMediaTypeVideo)
            {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspect])
                {
                    if(viewRatio > apertureRatio)
                    {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if(point.x >= blackBar && point.x <= blackBar + x2)
                        {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    }
                    else
                    {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if(point.y >= blackBar && point.y <= blackBar + y2)
                        {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                }
                else if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspectFill])
                {
                    if(viewRatio > apertureRatio)
                    {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    }
                    else
                    {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

- (void)subjectAreaDidChange:(NSNotification *)notification {
    
	CGPoint devicePoint = CGPointMake(.5, .5);
	[self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}


/***********************************************************************/

/**
 *  创建一个队列，防止阻塞主线程
 */
- (void)createQueue {
	dispatch_queue_t sessionQueue = dispatch_queue_create("com.budstudio.sessionQueue", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = sessionQueue;
}



@end
