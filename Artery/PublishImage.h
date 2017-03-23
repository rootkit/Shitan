//
//  PublishImage.h
//  Shitan
//
//  Created by 刘敏 on 14-11-24.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDAO.h"
#import "UploadDAO.h"
#import "OSSClient.h"
#import "OSSTool.h"
#import "OSSData.h"
#import "ALBBOSSServiceProvider.h"
#import "ALBBOSSServiceProtocol.h"

@interface PublishImage : NSObject

@property (strong, readwrite, nonatomic) ImageDAO *dao;
@property (strong, readwrite, nonatomic) UploadDAO *uploadDAO;
@property (strong, readwrite, nonatomic) OSSData *ossData;



+ (PublishImage *)sharedPublishImage;

//发布图片
- (void)releaseNewDynamic:(NSInteger)mRow;

//删除图片
- (void)deleteCacheImage:(NSInteger)mRow;



@end
