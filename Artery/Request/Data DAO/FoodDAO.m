//
//  FoodDAO.m
//  Shitan
//
//  Created by 刘敏 on 14-11-23.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FoodDAO.h"
#import "RequestModel.h"


@implementation FoodDAO


/**
 *   搜索美食名
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestSearchFoodName:(NSDictionary *)dict
              completionBlock:(FoodDAOBlock)completionBlock
               setFailedBlock:(FoodDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_SearchFoodName
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];

}




- (void)requestNameCreate:(NSDictionary *)dict
          completionBlock:(FoodDAOBlock)completionBlock
           setFailedBlock:(FoodDAOBlock)failedBlock{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_NameCreate
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



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
            setFailedBlock:(FoodDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_MerchantsDishes
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



@end
