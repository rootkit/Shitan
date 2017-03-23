//
//  ColumnDAO.h
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ColumnDAOBlock)(NSDictionary *result);

@interface ColumnDAO : NSObject


/**
 *  获取广告横幅列表
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)RequestBannerList:(NSDictionary *)dict
          completionBlock:(ColumnDAOBlock)completionBlock
           setFailedBlock:(ColumnDAOBlock)failedBlock;


/**
 *  分页获取专题活动的列表
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)RequestSpecialList:(NSDictionary *)dict
           completionBlock:(ColumnDAOBlock)completionBlock
            setFailedBlock:(ColumnDAOBlock)failedBlock;

/**
 *  已申请参加专题的用户列表
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)ParticipateSpecialListOfUsers:(NSDictionary *)dict
                      completionBlock:(ColumnDAOBlock)completionBlock
                       setFailedBlock:(ColumnDAOBlock)failedBlock;

/**
 *  专题PO图详情
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)SpecialImgsList:(NSDictionary *)dict
        completionBlock:(ColumnDAOBlock)completionBlock
         setFailedBlock:(ColumnDAOBlock)failedBlock;


/**
 *  申请参加专题
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)SpecialApply:(NSDictionary *)dict
    completionBlock:(ColumnDAOBlock)completionBlock
     setFailedBlock:(ColumnDAOBlock)failedBlock;



/**
 *  专题活动的详情介绍
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)SpecialDetails:(NSDictionary *)dict
       completionBlock:(ColumnDAOBlock)completionBlock
        setFailedBlock:(ColumnDAOBlock)failedBlock;


/**
 *  已参加的专题活动
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)SpecialJoin:(NSDictionary *)dict
    completionBlock:(ColumnDAOBlock)completionBlock
     setFailedBlock:(ColumnDAOBlock)failedBlock;


@end
