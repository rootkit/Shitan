//
//  FoundDAO.h
//  Shitan
//
//  Created by 刘敏 on 14-11-2.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FoundDAOBlock)(NSDictionary *result);

@interface FoundDAO : NSObject



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
                            setFailedBlock:(FoundDAOBlock)failedBlock;

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
                   setFailedBlock:(FoundDAOBlock)failedBlock;









@end
