//
//  QueryDAO.h
//  Shitan
//
//  Created by RichardLiu on 15/3/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//  查找商铺、查找菜品

#import <Foundation/Foundation.h>

typedef void (^QueryDAOBlock)(NSDictionary *result);

@interface QueryDAO : NSObject

/**
 *  根据菜名查找店铺 or 根据店铺查找菜品
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)QuerySomethingWithStoreOrDishes:(NSDictionary *)dict
                        completionBlock:(QueryDAOBlock)completionBlock
                         setFailedBlock:(QueryDAOBlock)failedBlock;



/**
 *  某个店铺的某道菜
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)QueryAddressTagNameTagImgs:(NSDictionary *)dict
                   completionBlock:(QueryDAOBlock)completionBlock
                    setFailedBlock:(QueryDAOBlock)failedBlock;





/**
 *  店铺中的所有菜
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)QueryListAll:(NSDictionary *)dict
     completionBlock:(QueryDAOBlock)completionBlock
      setFailedBlock:(QueryDAOBlock)failedBlock;


/**
 *  店铺中的其他菜
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)QueryListOther:(NSDictionary *)dict
       completionBlock:(QueryDAOBlock)completionBlock
        setFailedBlock:(QueryDAOBlock)failedBlock;




@end
