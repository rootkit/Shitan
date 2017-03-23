//
//  CouponsDAO.h
//  Shitan
//
//  Created by Richard Liu on 15/4/29.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CouponsDAOBlock)(NSDictionary *result);

@interface CouponsDAO : NSObject


/**
 *  用户的优惠券信息
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)UsersOfTheCoupons:(NSDictionary *)dict
          completionBlock:(CouponsDAOBlock)completionBlock
           setFailedBlock:(CouponsDAOBlock)failedBlock;



/**
 *  查找购物时所有可用的优惠卷
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)UsersOfBusinessCoupons:(NSDictionary *)dict
               completionBlock:(CouponsDAOBlock)completionBlock
                setFailedBlock:(CouponsDAOBlock)failedBlock;



@end
