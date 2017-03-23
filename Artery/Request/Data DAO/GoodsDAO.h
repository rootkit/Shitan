//
//  GoodsDAO.h
//  Shitan
//
//  Created by Richard Liu on 15/6/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GoodsDAOBlock)(NSDictionary *result);

@interface GoodsDAO : NSObject


/**
 *  获取某个商户下的所有商品
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GetProductList:(NSDictionary *)dict
       completionBlock:(GoodsDAOBlock)completionBlock
        setFailedBlock:(GoodsDAOBlock)failedBlock;




/**
 *  商品详情
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GetProductDetail:(NSDictionary *)dict
         completionBlock:(GoodsDAOBlock)completionBlock
          setFailedBlock:(GoodsDAOBlock)failedBlock;

/**
 *  获取商品的规格列表
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getProductRulesList:(NSDictionary *)dict
            completionBlock:(GoodsDAOBlock)completionBlock
             setFailedBlock:(GoodsDAOBlock)failedBlock;


@end
