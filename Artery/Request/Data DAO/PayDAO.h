//
//  PayDAO.h
//  Shitan
//
//  Created by Richard Liu on 15/7/30.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PayDAOBlock)(NSDictionary *result);

@interface PayDAO : NSObject


/**
 *  获取微信支付预付款ID
 *  POST
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getWechatPrepayId:(NSDictionary *)dict
          completionBlock:(PayDAOBlock)completionBlock
           setFailedBlock:(PayDAOBlock)failedBlock;

@end
