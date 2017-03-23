//
//  UploadDAO.h
//  Shitan
//
//  Created by 刘敏 on 14-11-5.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UploadDAOBlock)(NSDictionary *result);

@interface UploadDAO : NSObject

/**
*  上传图片
*  POST
*
*  @param headImage
*  @param completionBlock
*  @param failedBlock
*/
- (void)requestUploadImage:(UIImage *)headImage
           completionBlock:(UploadDAOBlock)completionBlock
            setFailedBlock:(UploadDAOBlock)failedBlock;



/**
 *  上传头像图片
 *  请求方式 POST
 *
 *  @param headImage 图像
 */
- (void)requestUploadHeadImage:(UIImage *)headImage
               completionBlock:(UploadDAOBlock)completionBlock
                setFailedBlock:(UploadDAOBlock)failedBlock;

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
                 setFailedBlock:(UploadDAOBlock)failedBlock;




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
                       setFailedBlock:(UploadDAOBlock)failedBlock;

@end
