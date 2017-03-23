//
//  PlaceDAO.h
//  Shitan
//
//  Created by 刘敏 on 14-9-26.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PlaceDAOBlock)(NSDictionary *result);

@interface PlaceDAO : NSObject



/**
*  获取附近的地点（搜索）
*  GET请求
*
*  @param dict            参数
*  @param completionBlock
*  @param failedBlock
*/
- (void)requestNearPlace:(NSDictionary *)dict
         completionBlock:(PlaceDAOBlock)completionBlock
          setFailedBlock:(PlaceDAOBlock)failedBlock;


/**
 *  地址搜索（搜索本地和大众点评）
 *  GET请求
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestPlaceSearch:(NSDictionary *)dict
           completionBlock:(PlaceDAOBlock)completionBlock
            setFailedBlock:(PlaceDAOBlock)failedBlock;


/**
 *  创建地点(自定义地点)
 *  POST请求
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)createdCustomSite:(NSDictionary *)dict
          completionBlock:(PlaceDAOBlock)completionBlock
           setFailedBlock:(PlaceDAOBlock)failedBlock;


/**
 *  搜索美食和地点
 *  GET请求
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)searchImgOrAddress:(NSDictionary *)dict
            completionBlock:(PlaceDAOBlock)completionBlock
             setFailedBlock:(PlaceDAOBlock)failedBlock;

/**
 *  搜索美食和地点
 *  GET请求
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)searchImgAndAddress:(NSDictionary *)dict
           completionBlock:(PlaceDAOBlock)completionBlock
            setFailedBlock:(PlaceDAOBlock)failedBlock;



/**
 *  获取地址标签详细信息
 *  GET请求
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GetAddressTagInfo:(NSDictionary *)dict
          completionBlock:(PlaceDAOBlock)completionBlock
           setFailedBlock:(PlaceDAOBlock)failedBlock;



/**
 *  通过经纬度查找附近地点（腾讯地图API）
 *  GET请求
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getNearAddressInfo:(NSDictionary *)dict
           completionBlock:(PlaceDAOBlock)completionBlock
            setFailedBlock:(PlaceDAOBlock)failedBlock;

@end



