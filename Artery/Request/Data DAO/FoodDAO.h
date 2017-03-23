//
//  FoodDAO.h
//  Shitan
//
//  Created by 刘敏 on 14-11-23.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FoodDAOBlock)(NSDictionary *result);

@interface FoodDAO : NSObject



/**
 *  根据关键字搜索美食
 *  GET 请求
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestSearchFoodName:(NSDictionary *)dict
           completionBlock:(FoodDAOBlock)completionBlock
            setFailedBlock:(FoodDAOBlock)failedBlock;




- (void)requestNameCreate:(NSDictionary *)dict
          completionBlock:(FoodDAOBlock)completionBlock
           setFailedBlock:(FoodDAOBlock)failedBlock;



/**
 *  获取商家推荐的菜单
 *  GET请求
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getMerchantsDishes:(NSDictionary *)dict
           completionBlock:(FoodDAOBlock)completionBlock
            setFailedBlock:(FoodDAOBlock)failedBlock;

@end
