//
//  RequestModel.h
//  Artery
//
//  Created by 刘敏 on 14-9-15.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^RequestModelBlock)(NSDictionary *result);

@interface RequestModel : NSObject

//静态单例
+ (id)shareInstance;



/********************************************** 异步请求 ********************************/
/**
 *  GET请求(带参)
 *
 *  @param api             接口名字
 *  @param getDict         GET数据 （字典）
 *  @param completionBlock 成功返回闭包
 *  @param failedBlock     失败返回闭包
 */
- (void)requestModelWithAPI:(NSString *)api
                    getDict:(NSDictionary *)getDict
            completionBlock:(RequestModelBlock)completionBlock
             setFailedBlock:(RequestModelBlock)failedBlock;



/**
 *  POST请求(带参)
 *
 *  @param api             接口名字
 *  @param postDict        POST数据（字典）
 *  @param completionBlock 成功返回闭包
 *  @param failedBlock     失败返回闭包
 */
- (void)requestModelWithAPI:(NSString *)api
                   postDict:(NSDictionary *)postDict
            completionBlock:(RequestModelBlock)completionBlock
             setFailedBlock:(RequestModelBlock)failedBlock;




/**
 *  上传图片
 *
 *  @param api             接口名字
 *  @param image           图片Data
 *  @param completionBlock 成功返回闭包
 *  @param failedBlock     失败返回闭包
 */
- (void)requestModelWithAPI:(NSString *)api
                  postImage:(UIImage *)image
            completionBlock:(RequestModelBlock)completionBlock
             setFailedBlock:(RequestModelBlock)failedBlock;



/**
 *  上传文件
 *
 *  @param api             接口名字
 *  @param pathName        文件路径
 *  @param completionBlock 成功返回闭包
 *  @param failedBlock     失败返回闭包
 */
- (void)requestModelWithAPI:(NSString *)api
                  postFiles:(NSString *)pathName
            completionBlock:(RequestModelBlock)completionBlock
             setFailedBlock:(RequestModelBlock)failedBlock;





/********************************************** 大众点评 ********************************/

/**
 *  GET请求(带参)
 *
 *  @param api             接口名字
 *  @param getDict         GET数据 （字典）
 *  @param completionBlock 成功返回闭包
 *  @param failedBlock     失败返回闭包
 */
- (void)requestModelWithDianPingAPI:(NSString *)api
                            getDict:(NSDictionary *)getDict
                    completionBlock:(RequestModelBlock)completionBlock
                     setFailedBlock:(RequestModelBlock)failedBlock;

@end
