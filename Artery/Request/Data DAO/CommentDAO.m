//
//  CommentDAO.m
//  Shitan
//
//  Created by 刘敏 on 14-10-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CommentDAO.h"
#import "RequestModel.h"

@implementation CommentDAO


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
               setFailedBlock:(CommentDAOBlock)failedBlock

{
    [[RequestModel shareInstance] requestModelWithAPI:URL_CommentsPic
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



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
          setFailedBlock:(CommentDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_CommentsList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

@end
