//
//  MessageDAO.h
//  Shitan
//
//  Created by Jia HongCHI on 14/10/25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MessageDAOBlock)(NSDictionary *result);

@interface MessageDAO : NSObject


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
             setFailedBlock:(MessageDAOBlock)failedBlock;




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
           setFailedBlock:(MessageDAOBlock)failedBlock;


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
          setFailedBlock:(MessageDAOBlock)failedBlock;



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
              setFailedBlock:(MessageDAOBlock)failedBlock;



@end
