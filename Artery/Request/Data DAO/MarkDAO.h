//
//  MarkDAO.h
//  Shitan
//
//  Created by 刘敏 on 14-10-19.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MarkDAOBlock)(NSDictionary *result);

@interface MarkDAO : NSObject


/**
 *  搜索标签
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestSearchMark:(NSDictionary *)dict
          completionBlock:(MarkDAOBlock)completionBlock
           setFailedBlock:(MarkDAOBlock)failedBlock;




/**
 *  创建标签
 *  POST 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestCreateMark:(NSDictionary *)dict
          completionBlock:(MarkDAOBlock)completionBlock
           setFailedBlock:(MarkDAOBlock)failedBlock;



/**
 *  获取图片的标签
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestImageMark:(NSDictionary *)dict
         completionBlock:(MarkDAOBlock)completionBlock
          setFailedBlock:(MarkDAOBlock)failedBlock;




@end
