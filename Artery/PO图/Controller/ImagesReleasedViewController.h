//
//  ImagesReleasedViewController.h
//  Artery
//
//  Created by 刘敏 on 14-9-27.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "DMBaseViewController.h"
#import "PlaceInfo.h"
#import "ZBMessageManagerFaceView.h"

@interface ImagesReleasedViewController : DMBaseViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *shareView;       //分享view
@property (nonatomic, weak) IBOutlet UIView *switchView;      //开关
@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *placefolder;

@property (nonatomic, strong) UIImage *cacheImage;     //需要上传的图片
@property (nonatomic, strong) UIImage *watermarkImage; //水印图

@property (nonatomic, weak) IBOutlet UIImageView *picView;
@property (nonatomic, weak) IBOutlet UITextView *desTextView;

@property (nonatomic, weak) IBOutlet UIView *scoreView;
@property (nonatomic, weak) IBOutlet UILabel *starLabel;

@property (nonatomic, weak) IBOutlet UISwitch *saveSwitch;

@property (nonatomic, strong) NSArray *tipArray;  //标签数组

@property (nonatomic, strong) PlaceInfo *pInfo;     //传递地理位置信息（经纬度信息）

/** 表情 **/
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZBMessageManagerFaceView *faceView;
@property (nonatomic, strong) UIButton *faceButton;

/**
 *  草稿箱专用信息
 */
@property (nonatomic, assign) BOOL isDraft;                 //是否来源于草稿箱
@property (nonatomic, strong) NSDictionary *cacheDict;      //该条草稿箱数据
@property (nonatomic, assign) NSInteger mRow;               //选中草稿箱的


- (IBAction)weiboTapped:(UIButton *)sender;

@end
