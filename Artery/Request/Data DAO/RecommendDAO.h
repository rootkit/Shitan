//
//  RecommendDAO.h
//  Shitan
//
//  Created by Richard Liu on 15/8/12.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RecommendDAOBlock)(NSDictionary *result);

@interface RecommendDAO : NSObject

/**
 *  获取推荐的商户列表
 *  GET
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getRecommendList:(NSDictionary *)dict
         completionBlock:(RecommendDAOBlock)completionBlock
          setFailedBlock:(RecommendDAOBlock)failedBlock;


/**
 *  获取所有商户分类列表
 *  GET
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getClassifyFindList:(NSDictionary *)dict
            completionBlock:(RecommendDAOBlock)completionBlock
             setFailedBlock:(RecommendDAOBlock)failedBlock;


/**
 *  取某一商户下的所有美食记录列表
 *  GET
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getFoodFindList:(NSDictionary *)dict
        completionBlock:(RecommendDAOBlock)completionBlock
         setFailedBlock:(RecommendDAOBlock)failedBlock;


@end
