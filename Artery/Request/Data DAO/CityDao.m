//
//  CityDao.m
//  Shitan
//
//  Created by Richard Liu on 15/9/1.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CityDao.h"

@implementation CityDao

// 获取已开通的城市列表
- (void)requestCityList:(NSDictionary *)dict
        completionBlock:(CityDaoBlock)completionBlock
         setFailedBlock:(CityDaoBlock)failedBlock
{

    [[RequestModel shareInstance] requestModelWithAPI:URL_GetCityList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


// 模糊查询城市记录
- (void)requestCityCodeFindList:(NSDictionary *)dict
                completionBlock:(CityDaoBlock)completionBlock
                 setFailedBlock:(CityDaoBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_CityCodeCityList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];


}



@end
