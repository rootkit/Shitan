//
//  PublishImage.m
//  Shitan
//
//  Created by 刘敏 on 14-11-24.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PublishImage.h"
#import "JDStatusBarNotification.h"
#import "FileManagement.h"

static NSString *const SBStyle1 = @"SBStyle1";
static NSString *const SBStyle2 = @"SBStyle2";


static PublishImage * _publishImage = nil;

@interface PublishImage ()
@property (nonatomic, assign) UIActivityIndicatorViewStyle indicatorStyle;
@end

@implementation PublishImage


+ (PublishImage *)sharedPublishImage
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _publishImage = [[self alloc] init];
    });
    
    return _publishImage;
}


- (void)initDAO
{
    if (!_dao) {
        _dao = [[ImageDAO alloc] init];
    }
    
    
    if (!_uploadDAO) {
        _uploadDAO = [[UploadDAO alloc] init];
    }
}

//发布图片
- (void)releaseNewDynamic:(NSInteger)mRow{
    
    [self initDAO];
    
    [self setStatusBarBegin];
    
    NSString *path = NSTemporaryDirectory();
    NSString *plistPath = [NSString stringWithFormat:@"%@Draft", path];
    //读取
    NSString *filename = [plistPath stringByAppendingPathComponent:@"draftData.plist"];   //获取路径
    
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filename];

    CLog(@"%@", array);
    
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] initWithDictionary:[array objectAtIndex:mRow]];
    
    NSString* imgUrl = [imageDic objectForKey:@"imgUrl"];
    if (imgUrl) {
        //imageUrl已经存在----图片上传成功----直接发布
        //封装数据上传
        [self publishImageWithDict:imageDic imageWithRow:mRow];
    }
    else
    {
        NSString *originalURL = [plistPath stringByAppendingPathComponent:[imageDic objectForKey:@"originalURL"]];

        id<ALBBOSSServiceProtocol> ossService = [ALBBOSSServiceProvider getService];
        [ossService setGlobalDefaultBucketHostId:@"oss-cn-hangzhou.aliyuncs.com"];
        [ossService setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
            NSString *signature = nil;
            NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
            signature = [OSSTool calBase64Sha1WithData:content withKey:Aliyun_SecretKey];
            signature = [NSString stringWithFormat:@"OSS %@:%@", Aliyun_AccessKey, signature];
            
            return signature;
        }];
        
        //字符串截取
        NSString *pathFile = [NSString stringWithFormat:@"img/%@", [imageDic objectForKey:@"originalURL"]];
        CLog(@"图片名称%@", [imageDic objectForKey:@"originalURL"]);
        
        _ossData = [ossService getOSSDataWithBucket:[ossService getBucket:Aliyun_Bucket] key:pathFile];
        
        NSData *imageData = [NSData dataWithContentsOfFile:originalURL];
        [_ossData setData:imageData withType:@"image/jpeg"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_ossData uploadWithUploadCallback:^(BOOL isSucce, NSError *error) {
                if (isSucce) {
                    [imageDic setObject:[NSString stringWithFormat:@"%@%@", URL_IMAGEFILE, pathFile] forKey:@"imgUrl"];
                    //封装数据上传
                    [self publishImageWithDict:imageDic imageWithRow:mRow];
                }
                else
                {
                    [self setStatusBarFailure];
                    
                    //上传失败原因
                    [self uploadOSSFailureReason:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                }
                
            } withProgressCallback:^(float progressFloat) {
                CLog(@"当前进度： %f", progressFloat);
            }];
            
            
        });
    }
}


- (void)publishImageWithDict:(NSDictionary *)dic
                imageWithRow:(NSInteger)mRow
{
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    //发布图片
    [_dao publishPictures:requestDict
          completionBlock:^(NSDictionary *result) {
              if ([[result objectForKey:@"code"] integerValue] == 200) {
                  
                  
                  //发送通知
                  if (theAppDelegate.isPO) {
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"SP_PICTURESRELEASEDCOMPLETE" object:nil];
                  }
                  else{
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"PICTURESRELEASEDCOMPLETE" object:nil];
                  }
                  
                  theAppDelegate.isPO = NO;
                  
                  [self setStatusBarSuccessful];
                  
                  //删除发布成功的文件
                  [self deleteCacheImage:mRow];
                  
                  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISOPENDRAFT"];
              }
              else{
                  [self setStatusBarFailure];
                  
                  MET_MIDDLE(result.msg);
                  
                  if ([dic objectForKey:@"imgUrl"]) {
                      [self fileOperations:dic inRow:mRow];
                  }
              }
              
          } setFailedBlock:^(NSDictionary *result) {
              [self setStatusBarFailure];

          }];
}

//开始
- (void)setStatusBarBegin
{
    [JDStatusBarNotification addStyleNamed:SBStyle1
                                   prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                       style.barColor = [UIColor colorWithRed:0.797 green:0.000 blue:0.662 alpha:1.000];
                                       style.textColor = [UIColor whiteColor];
                                       style.animationType = JDStatusBarAnimationTypeFade;
                                       style.font = [UIFont fontWithName:@"SnellRoundhand-Bold" size:17.0];
                                       style.progressBarColor = [UIColor colorWithRed:0.986 green:0.062 blue:0.598 alpha:1.000];
                                       style.progressBarHeight = 20.0;
                                       return style;
                                   }];
    
    
    if(![JDStatusBarNotification isVisible]) {
        self.indicatorStyle = UIActivityIndicatorViewStyleGray;
        [JDStatusBarNotification showWithStatus:@"图片上传中..." dismissAfter:NSNotFound];
    }
    [JDStatusBarNotification showActivityIndicator:YES
                                    indicatorStyle:self.indicatorStyle];
}

//完成
- (void)setStatusBarSuccessful
{
    self.indicatorStyle = UIActivityIndicatorViewStyleWhite;
    [JDStatusBarNotification showWithStatus:@"图片发布成功"
                               dismissAfter:1.0
                                  styleName:JDStatusBarStyleSuccess];
}


//失败
- (void)setStatusBarFailure
{
    self.indicatorStyle = UIActivityIndicatorViewStyleWhite;
    [JDStatusBarNotification showWithStatus:@"图片发布失败"
                               dismissAfter:1.0
                                  styleName:JDStatusBarStyleError];
    
    theAppDelegate.isPO = NO;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PICTURESRELEASEDFAILURE" object:nil];

}


//文件操作 (图片上传成功，发布失败改写数据库)
- (void)fileOperations:(NSDictionary *)dict inRow:(NSInteger)mRow
{
    //写入到文件
    NSMutableArray *array  = [[NSMutableArray alloc] init];
    //写入文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path = NSTemporaryDirectory();
    NSString *plistPath = [NSString stringWithFormat:@"%@Draft", path];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"draftData.plist"];   //获取路径
    
    array = [NSMutableArray arrayWithContentsOfFile:filename];  //读取数据
    
    //替换数据
    [array replaceObjectAtIndex:mRow withObject:dict];


    BOOL success = [fileManager fileExistsAtPath:filename];
    
    //不存在先创建Plist文件
    if (!success) {
        NSMutableArray * fileArray = [[NSMutableArray alloc] initWithCapacity:0];
        [fileArray addObject:dict];
        
        [fileArray writeToFile:filename atomically:YES];
    }
    else {
        [array addObject:dict];
        [array writeToFile:filename atomically:YES];
    }
}

//删除图片
- (void)deleteCacheImage:(NSInteger)mRow
{
    //写入到文件
    NSMutableArray *array  = [[NSMutableArray alloc] init];
    //写入文件
    NSString *path = NSTemporaryDirectory();
    NSString *plistPath = [NSString stringWithFormat:@"%@Draft", path];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"draftData.plist"];   //获取路径
    
    array = [NSMutableArray arrayWithContentsOfFile:filename];  //读取数据
    
    NSDictionary *cacheDict = [array objectAtIndex:mRow];
    //删除数据
    [array removeObjectAtIndex:mRow];
    
    
    if ([array count] == 0) {
        //清空Draft文件夹
        [FileManagement clearDraftFolder];
    }
    else{
        
        NSString *originalPath = [NSString stringWithFormat:@"%@/%@", plistPath, [cacheDict objectForKey:@"originalURL"]];
        NSString *waterPath = [NSString stringWithFormat:@"%@/%@", plistPath, [cacheDict objectForKey:@"waterURL"]];

        //删除对应的图片
        [[NSFileManager defaultManager] removeItemAtPath:originalPath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:waterPath error:nil];

        
        //更新draftData.plist
        [array writeToFile:filename atomically:YES];
        
    }

}

//上传OSS失败原因
- (void)uploadOSSFailureReason:(NSString *)des
{
    [self initDAO];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    //失败
    [dic setObject:[NSNumber numberWithInt:500] forKey:@"resultCode"];
    //返回结果的子代码
    [dic setObject:[NSNumber numberWithInt:4] forKey:@"subCode"];
    
    //apiName
    [dic setObject:@"oss.uploadImg" forKey:@"apiName"];
    //表示是IOS系统
    [dic setObject:[NSNumber numberWithInt:1] forKey:@"deviceType"];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [dic setObject:version forKey:@"version"];
    
    if (theAppDelegate.locatCity) {
        [dic setObject:theAppDelegate.locatCity forKey:@"city"];
    }
    
    if (theAppDelegate.longitude) {
        [dic setObject:theAppDelegate.longitude forKey:@"longitude"];
    }
    
    if (theAppDelegate.latitude) {
        [dic setObject:theAppDelegate.latitude forKey:@"latitude"];
    }
    
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    if (des) {
        [dic setObject:des forKey:@"details"];
    }
    
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_uploadDAO requestUploadOSSFailureReason:requestDict completionBlock:^(NSDictionary *result) {
        if (result.code == 200) {
            CLog(@"成功");
        }
        else if(result.code == 500)
        {
            CLog(@"失败");
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}


@end
