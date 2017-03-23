/******************************************************************************
 项目名称 : 动脉
 文件名称 : CommentDAO.h
 
 函数描述 : 评论相关的Model

 开发人员 : 刘敏
 创建日期 : 14-10-14
 版权信息 : Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
 备注信息 :
 ******************************************************************************/

#import <Foundation/Foundation.h>

typedef void (^CommentDAOBlock)(NSDictionary *result);

@interface CommentDAO : NSObject


/**
 *  发布评论
 *  POST 方式
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)publishedCommentsWith:(NSDictionary *)dict
              completionBlock:(CommentDAOBlock)completionBlock
               setFailedBlock:(CommentDAOBlock)failedBlock;



/**
 *  获取评论列表
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getCommentsPlist:(NSDictionary *)dict
         completionBlock:(CommentDAOBlock)completionBlock
          setFailedBlock:(CommentDAOBlock)failedBlock;


@end
