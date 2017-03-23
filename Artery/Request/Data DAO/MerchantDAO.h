//
//  MerchantDAO.h
//  Shitan
//
//  Created by Richard Liu on 15/6/26.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MerchantDAOBlock)(NSDictionary *result);

@interface MerchantDAO : NSObject


/**
 *  首页商户列表
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GetAddrList:(NSDictionary *)dict
     completionBlock:(MerchantDAOBlock)completionBlock
      setFailedBlock:(MerchantDAOBlock)failedBlock;


/**
 *  获取某个商户信息
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getMerchantsInfo:(NSDictionary *)dict
         completionBlock:(MerchantDAOBlock)completionBlock
          setFailedBlock:(MerchantDAOBlock)failedBlock;


@end
