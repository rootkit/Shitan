//
//  MessageDAO.m
//  Shitan
//
//  Created by Jia HongCHI on 14/10/25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "MessageDAO.h"
#import "RequestModel.h"

@implementation MessageDAO

/**
 *  获取消息列表
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestMsgGet:(NSDictionary *)dict
            completionBlock:(MessageDAOBlock)completionBlock
             setFailedBlock:(MessageDAOBlock)failedBlock{
    [[RequestModel shareInstance] requestModelWithAPI:URL_MsgGet
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


/**
 *  通知列表
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestNoticeList:(NSDictionary *)dict
          completionBlock:(MessageDAOBlock)completionBlock
           setFailedBlock:(MessageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetNoticeList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



/**
 *  广播列表
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestBroadcast:(NSDictionary*)dict
         completionBlock:(MessageDAOBlock)completionBlock
          setFailedBlock:(MessageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetBroadcastList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}


/**
 *  获取未读消息条数
 *  GET方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUnreadMessage:(NSDictionary *)dict
             completionBlock:(MessageDAOBlock)completionBlock
              setFailedBlock:(MessageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_HasUnreadMessage
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

@end
