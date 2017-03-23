//
//  ImageDAO.m
//  Shitan
//
//  Created by 刘敏 on 14-10-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ImageDAO.h"
#import "RequestModel.h"

@implementation ImageDAO


/**
 *  发布图片
 *  POST方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)publishPictures:(NSDictionary *)dict
        completionBlock:(ImageDAOBlock)completionBlock
         setFailedBlock:(ImageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PicturesReleased
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}



///**
// *  获取图片列表
// *  GET方式
// *  @param dic             参数列表
// *  @param completionBlock 返回参数（成功）
// *  @param failedBlock     返回参数（失败）
// */
//- (void)requestImageList:(NSDictionary *)dic
//         completionBlock:(ImageDAOBlock)completionBlock
//          setFailedBlock:(ImageDAOBlock)failedBlock
//{
//    [[RequestModel shareInstance] requestModelWithAPI:URL_ImageList
//                                              getDict:dic
//                                      completionBlock:completionBlock
//                                       setFailedBlock:failedBlock];
//}
//


/**
 *  获取图片列表(新接口)
 *  GET方式
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestNewImageList:(NSDictionary *)dic
            completionBlock:(ImageDAOBlock)completionBlock
             setFailedBlock:(ImageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ImageListII
                                              getDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



/**
 *  获取最新的图片个数
 *  GET方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestImageNewCount:(NSDictionary *)dic
             completionBlock:(ImageDAOBlock)completionBlock
              setFailedBlock:(ImageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ImageNewCount
                                              getDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


/**
 *  赞图片
 *  POST 方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestPraisePic:(NSDictionary *)dic
         completionBlock:(ImageDAOBlock)completionBlock
          setFailedBlock:(ImageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PraisePic
                                             postDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


/**
 *  取消赞图片
 *  POST 方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestCancelPraise:(NSDictionary *)dic
            completionBlock:(ImageDAOBlock)completionBlock
             setFailedBlock:(ImageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_CancelPraise
                                             postDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



/**
 *  举报图片
 *  POST 方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestReportPic:(NSDictionary *)dic
         completionBlock:(ImageDAOBlock)completionBlock
          setFailedBlock:(ImageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ReportPic
                                             postDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


/**
 *  隐藏图片
 *  POST 方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestHideImage:(NSDictionary *)dic
         completionBlock:(ImageDAOBlock)completionBlock
          setFailedBlock:(ImageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_HidePic
                                             postDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}


/**
 *  获取图片信息
 *  GET 方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestImageInfo:(NSDictionary *)dic
         completionBlock:(ImageDAOBlock)completionBlock
          setFailedBlock:(ImageDAOBlock)failedBlock{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_ImageInfo
                                              getDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}



/**
 *  获取某一标签下的图片
 *  GET方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestImageListByTags:(NSDictionary *)dic
               completionBlock:(ImageDAOBlock)completionBlock
                setFailedBlock:(ImageDAOBlock)failedBlock{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetImgeWithTags
                                              getDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



/**
 *  删除图片
 *  POST 方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestDeleteImage:(NSDictionary *)dic
           completionBlock:(ImageDAOBlock)completionBlock
            setFailedBlock:(ImageDAOBlock)failedBlock
{
 
    [[RequestModel shareInstance] requestModelWithAPI:URL_DeleteImage
                                             postDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];

}



///**
// *  是否赞过图片
// *  GET 方式
// *
// *  @param dic                 参数列表
// *  @param completionBlock     返回参数（成功）
// *  @param failedBlock         返回参数（失败）
// */
//- (void)requestHasPraise:(NSDictionary *)dic
//         completionBlock:(ImageDAOBlock)completionBlock
//          setFailedBlock:(ImageDAOBlock)failedBlock
//{
//    [[RequestModel shareInstance] requestModelWithAPI:URL_HasPraise
//                                             getDict:dic 
//                                      completionBlock:completionBlock
//                                       setFailedBlock:failedBlock];
//}



/**
 *  关注的好友的图片
 *  GET 方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestMyFriendImgs:(NSDictionary *)dic
            completionBlock:(ImageDAOBlock)completionBlock
             setFailedBlock:(ImageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_MyFriendImgs
                                              getDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];

}




/**
 *  获取某个用户发布图片的时间
 *  GET 方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestPublishTimes:(NSDictionary *)dic
            completionBlock:(ImageDAOBlock)completionBlock
             setFailedBlock:(ImageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PublishTimes
                                              getDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




/**
 *  用户的美食日志
 *  GET 方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestFoodDiary:(NSDictionary *)dic
         completionBlock:(ImageDAOBlock)completionBlock
          setFailedBlock:(ImageDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_FoodDiary
                                              getDict:dic
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}





/**
 *  删除OSS图片 (删除oss(阿里云图片服务)上的图片, 不涉及我们自己的DB)
 *  POST 方式
 *
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestDeleteOssImage:(NSDictionary *)dict
              completionBlock:(ImageDAOBlock)completionBlock
               setFailedBlock:(ImageDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_DeleteOssImg
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




@end
