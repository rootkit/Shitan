//
//  OrderDAO.h
//  Shitan
//
//  Created by Richard Liu on 15/6/16.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OrderDAOBlock)(NSDictionary *result);

@interface OrderDAO : NSObject


/**
 *  用户的订单列表
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GetOrderList:(NSDictionary *)dict
     completionBlock:(OrderDAOBlock)completionBlock
      setFailedBlock:(OrderDAOBlock)failedBlock;


/**
 *  用户创建订单
 *  POST方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GetOrderCreate:(NSDictionary *)dict
     completionBlock:(OrderDAOBlock)completionBlock
      setFailedBlock:(OrderDAOBlock)failedBlock;


/**
 *  获取某个订单详情
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getOrderDetails:(NSDictionary *)dict
        completionBlock:(OrderDAOBlock)completionBlock
         setFailedBlock:(OrderDAOBlock)failedBlock;


/**
 *  获取某个订单状态列表
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getOrderState:(NSDictionary *)dict
      completionBlock:(OrderDAOBlock)completionBlock
       setFailedBlock:(OrderDAOBlock)failedBlock;



/**
 *  查找某张订单下的所有清单记录
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getOrderFindList:(NSDictionary *)dict
         completionBlock:(OrderDAOBlock)completionBlock
          setFailedBlock:(OrderDAOBlock)failedBlock;


@end
