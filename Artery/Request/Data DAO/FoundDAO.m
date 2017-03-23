//
//  FoundDAO.m
//  Shitan
//
//  Created by 刘敏 on 14-11-2.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FoundDAO.h"
#import "RequestModel.h"


@implementation FoundDAO



/**
 *  今日推荐
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestImageListbyRecommendOfToday:(NSDictionary *)dict
                           completionBlock:(FoundDAOBlock)completionBlock
                            setFailedBlock:(FoundDAOBlock)failedBlock
{

    [[RequestModel shareInstance] requestModelWithAPI:URL_RecommendOfToday
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    

}


/**
 *  获取Top10图片
 *  GET 方法
 *
 *  @param dict            参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestImageListByRanking:(NSDictionary *)dict
                  completionBlock:(FoundDAOBlock)completionBlock
                   setFailedBlock:(FoundDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetRankingWithImages
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}

@end
