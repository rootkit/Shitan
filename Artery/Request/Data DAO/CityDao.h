//
//  CityDao.h
//  Shitan
//
//  Created by Richard Liu on 15/9/1.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestModel.h"


typedef void (^CityDaoBlock)(NSDictionary *result);


@interface CityDao : NSObject

/**
 *  获取已开通的城市列表
 *  get
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestCityList:(NSDictionary *)dict
        completionBlock:(CityDaoBlock)completionBlock
         setFailedBlock:(CityDaoBlock)failedBlock;




/**
 *  模糊查询城市记录
 *  get
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestCityCodeFindList:(NSDictionary *)dict
                completionBlock:(CityDaoBlock)completionBlock
                setFailedBlock:(CityDaoBlock)failedBlock;

@end
