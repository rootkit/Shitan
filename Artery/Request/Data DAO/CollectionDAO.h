//
//  CollectionDAO.h
//  Shitan
//
//  Created by 刘敏 on 14-10-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CollectionDAOBlock)(NSDictionary *result);

@interface CollectionDAO : NSObject


/**
*  收藏夹图片列表
*  GET 方式
*
*  @param dict            参数
*  @param completionBlock
*  @param failedBlock
*/
- (void)requestFavoriteImgs:(NSDictionary *)dict
            completionBlock:(CollectionDAOBlock)completionBlock
             setFailedBlock:(CollectionDAOBlock)failedBlock;



/**
 *  收藏夹详情
 *  GET 方式
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestFavoriteInfo:(NSDictionary *)dict
                completionBlock:(CollectionDAOBlock)completionBlock
                 setFailedBlock:(CollectionDAOBlock)failedBlock;




/**
 *  收藏图片
 *  POST 方式
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)collectionImageWithInfo:(NSDictionary *)dict
                completionBlock:(CollectionDAOBlock)completionBlock
                 setFailedBlock:(CollectionDAOBlock)failedBlock;


/**
 *  获取用户收藏夹列表
 *
 *  GET方式
 *
 *  @param dic             参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)getFavoriteList:(NSDictionary *)dic
        completionBlock:(CollectionDAOBlock)completionBlock
         setFailedBlock:(CollectionDAOBlock)failedBlock;



/**
 *  创建收藏夹
 *  POST 方式
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)createCollection:(NSDictionary *)dic
         completionBlock:(CollectionDAOBlock)completionBlock
          setFailedBlock:(CollectionDAOBlock)failedBlock;


/**
 *  获取收藏夹列表2
 *  GET 方式
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)userFavorite2:(NSDictionary *)dic
      completionBlock:(CollectionDAOBlock)completionBlock
       setFailedBlock:(CollectionDAOBlock)failedBlock;



/**
 *  删除收藏夹
 *  POST 方式
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)deleteFavorite:(NSDictionary *)dic
       completionBlock:(CollectionDAOBlock)completionBlock
        setFailedBlock:(CollectionDAOBlock)failedBlock;



/**
 *  编辑收藏夹
 *  POST 方式
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)editFavorite:(NSDictionary *)dic
     completionBlock:(CollectionDAOBlock)completionBlock
      setFailedBlock:(CollectionDAOBlock)failedBlock;


/**
 *  分页获取收藏商户列表
 *
 *  @param dic
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)favoriteShopList:(NSDictionary *)dic
         completionBlock:(CollectionDAOBlock)completionBlock
          setFailedBlock:(CollectionDAOBlock)failedBlock;


/**
 *  收藏某一商家
 *
 *  @param dic
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)collectMerchant:(NSDictionary *)dic
        completionBlock:(CollectionDAOBlock)completionBlock
         setFailedBlock:(CollectionDAOBlock)failedBlock;


// 取消收藏某一商家
- (void)cannercollectMerchant:(NSDictionary *)dic
              completionBlock:(CollectionDAOBlock)completionBlock
               setFailedBlock:(CollectionDAOBlock)failedBlock;

@end
