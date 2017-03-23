//
//  RecommendDAO.m
//  Shitan
//
//  Created by Richard Liu on 15/8/12.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RecommendDAO.h"
#import "RequestModel.h"

@implementation RecommendDAO


//获取推荐的商户列表
- (void)getRecommendList:(NSDictionary *)dict
         completionBlock:(RecommendDAOBlock)completionBlock
          setFailedBlock:(RecommendDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_FindRecommendList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




// 获取所有商户分类列表
- (void)getClassifyFindList:(NSDictionary *)dict
            completionBlock:(RecommendDAOBlock)completionBlock
             setFailedBlock:(RecommendDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ClassifyFindList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



//食探推荐的美食
- (void)getFoodFindList:(NSDictionary *)dict
        completionBlock:(RecommendDAOBlock)completionBlock
         setFailedBlock:(RecommendDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_FoodFindList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


@end
