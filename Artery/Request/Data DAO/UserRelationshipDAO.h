//
//  UserRelationshipDAO.h
//  Shitan
//
//  Created by 刘敏 on 14-11-5.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//  用户关系

#import <Foundation/Foundation.h>

typedef void (^UserRelationshipDAOBlock)(NSDictionary *result);


@interface UserRelationshipDAO : NSObject


/**
 *  获取商家信息
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestBusinessInfo:(NSDictionary *)dict
            completionBlock:(UserRelationshipDAOBlock)completionBlock
             setFailedBlock:(UserRelationshipDAOBlock)failedBlock;


/**
 *  获取粉丝列表
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserFollowers:(NSDictionary *)dict
             completionBlock:(UserRelationshipDAOBlock)completionBlock
              setFailedBlock:(UserRelationshipDAOBlock)failedBlock;


/**
 *  获取关注列表
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserFolloweds:(NSDictionary *)dict
             completionBlock:(UserRelationshipDAOBlock)completionBlock
              setFailedBlock:(UserRelationshipDAOBlock)failedBlock;



/**
 *  根据UserId获取User信息
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserInfo:(NSDictionary *)dict
        completionBlock:(UserRelationshipDAOBlock)completionBlock
         setFailedBlock:(UserRelationshipDAOBlock)failedBlock;



/**
 *  关注好友
 *  POST方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserFollow:(NSDictionary *)dict
          completionBlock:(UserRelationshipDAOBlock)completionBlock
           setFailedBlock:(UserRelationshipDAOBlock)failedBlock;


/**
 *  取消关注好友
 *  POST方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserUnFollow:(NSDictionary *)dict
            completionBlock:(UserRelationshipDAOBlock)completionBlock
             setFailedBlock:(UserRelationshipDAOBlock)failedBlock;



/**
 *  判断用户1是否有关注用户2
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock     
 */
- (void)requestUserHasFollow:(NSDictionary *)dict
             completionBlock:(UserRelationshipDAOBlock)completionBlock
              setFailedBlock:(UserRelationshipDAOBlock)failedBlock;



/**
 *  通讯录列表
 *  POST 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestInviteFrendsWithPhone:(NSDictionary *)dict
                     completionBlock:(UserRelationshipDAOBlock)completionBlock
                      setFailedBlock:(UserRelationshipDAOBlock)failedBlock;





/**
 *  用户保存通讯录
 *  POST 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestSaveContacts:(NSDictionary *)dict
            completionBlock:(UserRelationshipDAOBlock)completionBlock
             setFailedBlock:(UserRelationshipDAOBlock)failedBlock;






/**
 *  获取微博中我关注的且已在我们系统中的人
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestWeiboFrendsWithMyApp:(NSDictionary *)dict
                    completionBlock:(UserRelationshipDAOBlock)completionBlock
                     setFailedBlock:(UserRelationshipDAOBlock)failedBlock;




/**
 *  邀请微博粉丝加入
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestInviteFrendsWithWeibo:(NSDictionary *)dict
                     completionBlock:(UserRelationshipDAOBlock)completionBlock
                      setFailedBlock:(UserRelationshipDAOBlock)failedBlock;



/**
 *  同城达人推荐
 *  GET 方式
 *  
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestDarenWithCity:(NSDictionary *)dict
             completionBlock:(UserRelationshipDAOBlock)completionBlock
              setFailedBlock:(UserRelationshipDAOBlock)failedBlock;


/**
 *  获得图片点赞列表
 *  GET 方式
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestPraiseList:(NSDictionary *)dict
          completionBlock:(UserRelationshipDAOBlock)completionBlock
           setFailedBlock:(UserRelationshipDAOBlock)failedBlock;




@end
