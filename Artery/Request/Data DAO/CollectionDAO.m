//
//  CollectionDAO.m
//  Shitan
//
//  Created by 刘敏 on 14-10-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.

//  收藏

#import "CollectionDAO.h"
#import "RequestModel.h"

@implementation CollectionDAO



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
             setFailedBlock:(CollectionDAOBlock)failedBlock{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_FavoriteImgs
                                             getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




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
             setFailedBlock:(CollectionDAOBlock)failedBlock{
    [[RequestModel shareInstance] requestModelWithAPI:URL_FavoriteInfo
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




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
                 setFailedBlock:(CollectionDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_CollectionImage
                                             postDict:dict
                                      completionBlock:completionBlock
                                      setFailedBlock:failedBlock];

}




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
         setFailedBlock:(CollectionDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_FavoriteList
                                              getDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




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
                         setFailedBlock:(CollectionDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_FavoriteCreate
                                             postDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




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
          setFailedBlock:(CollectionDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserFavorite2
                                             getDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


/**
 *  删除收藏夹
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)deleteFavorite:(NSDictionary *)dic
       completionBlock:(CollectionDAOBlock)completionBlock
        setFailedBlock:(CollectionDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_DeletFavorites
                                              postDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



/**
 *  编辑收藏夹
 *
 *  @param dict            参数
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)editFavorite:(NSDictionary *)dic
     completionBlock:(CollectionDAOBlock)completionBlock
      setFailedBlock:(CollectionDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_UpdateFavorites
                                             postDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


//分页获取收藏商户列表
- (void)favoriteShopList:(NSDictionary *)dic
         completionBlock:(CollectionDAOBlock)completionBlock
          setFailedBlock:(CollectionDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_FavoriteShopFindList
                                              getDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}


// 收藏某一商家
- (void)collectMerchant:(NSDictionary *)dic
        completionBlock:(CollectionDAOBlock)completionBlock
         setFailedBlock:(CollectionDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_FavoriteOfShop
                                             postDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

// 取消收藏某一商家
- (void)cannercollectMerchant:(NSDictionary *)dic
        completionBlock:(CollectionDAOBlock)completionBlock
         setFailedBlock:(CollectionDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_CannerFavoriteOfShop
                                             postDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


@end
