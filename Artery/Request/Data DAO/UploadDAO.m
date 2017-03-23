//
//  UploadDAO.m
//  Shitan
//
//  Created by 刘敏 on 14-11-5.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "UploadDAO.h"
#import "RequestModel.h"


@implementation UploadDAO



/**
 *  上传图片
 *  请求方式 POST
 *
 *  @param headImage 图像
 */
- (void)requestUploadImage:(UIImage *)headImage
           completionBlock:(UploadDAOBlock)completionBlock
            setFailedBlock:(UploadDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_UploadImg
                                            postImage:headImage
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


/**
 *  上传头像图片
 *  请求方式 POST
 *
 *  @param headImage 图像
 */
- (void)requestUploadHeadImage:(UIImage *)headImage
               completionBlock:(UploadDAOBlock)completionBlock
                setFailedBlock:(UploadDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UploadHeadImg
                                            postImage:headImage
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




/**
 *  上传图片（文件形式）
 *  POST
 *
 *  @param pathS            文件路径
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUploadImageFiles:(NSString *)pathS
                completionBlock:(UploadDAOBlock)completionBlock
                 setFailedBlock:(UploadDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_UploadImg
                                            postFiles:pathS
                                      completionBlock:completionBlock setFailedBlock:failedBlock];
}




/**
 *  前端上传API日志
 *  GET
 *
 *  @param dic
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUploadOSSFailureReason:(NSDictionary *)dic
                      completionBlock:(UploadDAOBlock)completionBlock
                       setFailedBlock:(UploadDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UploadAPILog
                                              getDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



@end
