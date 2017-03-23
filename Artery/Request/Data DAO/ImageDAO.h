//
//  ImageDAO.h
//  Shitan
//
//  Created by 刘敏 on 14-10-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//  与图片（）相关的

#import <Foundation/Foundation.h>

typedef void (^ImageDAOBlock)(NSDictionary *result);

@interface ImageDAO : NSObject


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
         setFailedBlock:(ImageDAOBlock)failedBlock;



/**
 *  获取图片列表
 *  GET方式
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestImageList:(NSDictionary *)dic
         completionBlock:(ImageDAOBlock)completionBlock
          setFailedBlock:(ImageDAOBlock)failedBlock;


/**
 *  获取图片列表(新接口)
 *  GET方式
 *  @param dic             参数列表
 *  @param completionBlock 返回参数（成功）
 *  @param failedBlock     返回参数（失败）
 */
- (void)requestNewImageList:(NSDictionary *)dic
                completionBlock:(ImageDAOBlock)completionBlock
             setFailedBlock:(ImageDAOBlock)failedBlock;


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
              setFailedBlock:(ImageDAOBlock)failedBlock;


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
          setFailedBlock:(ImageDAOBlock)failedBlock;



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
             setFailedBlock:(ImageDAOBlock)failedBlock;


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
          setFailedBlock:(ImageDAOBlock)failedBlock;


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
          setFailedBlock:(ImageDAOBlock)failedBlock;



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
          setFailedBlock:(ImageDAOBlock)failedBlock;




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
                setFailedBlock:(ImageDAOBlock)failedBlock;




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
            setFailedBlock:(ImageDAOBlock)failedBlock;


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
//          setFailedBlock:(ImageDAOBlock)failedBlock;



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
             setFailedBlock:(ImageDAOBlock)failedBlock;



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
             setFailedBlock:(ImageDAOBlock)failedBlock;



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
          setFailedBlock:(ImageDAOBlock)failedBlock;




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
               setFailedBlock:(ImageDAOBlock)failedBlock;


@end
