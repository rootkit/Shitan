//
//  DPDao.h
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DPDaoBlock)(NSDictionary *result);

@interface DPDao : NSObject


/**
 *  获取指定商户的团购信息
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GetMerchantsGroup:(NSDictionary *)dict
          completionBlock:(DPDaoBlock)completionBlock
           setFailedBlock:(DPDaoBlock)failedBlock;


/**
 *  获取用户的团购信息
 *  post方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GetUserGroup:(NSDictionary *)dict completionBlock:(DPDaoBlock)completionBlock setFailedBlock:(DPDaoBlock)failedBlock;


/**
 *  获取用户的团购记录
 *  post方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GetGroupList:(NSDictionary *)dict completionBlock:(DPDaoBlock)completionBlock setFailedBlock:(DPDaoBlock)failedBlock;

/**
 *  获取用户的红包记录
 *  post方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GEtPacketList:(NSDictionary *)dict completionBlock:(DPDaoBlock)completionBlock setFailedBlock:(DPDaoBlock   )failedBlock;

/**
 *  优惠码
 *  post方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)CouponCode:(NSDictionary *)dict completionBlock:(DPDaoBlock)completionBlock setFailedBlock:(DPDaoBlock)failedBlock;

/**
 *  提现
 *  post方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GroupCash:(NSDictionary *)dict completionBlock:(DPDaoBlock)completionBlock setFailedBlock:(DPDaoBlock)failedBlock;
@end
