//
//  UserRelationshipDAO.m
//  Shitan
//
//  Created by 刘敏 on 14-11-5.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "UserRelationshipDAO.h"
#import "RequestModel.h"

@implementation UserRelationshipDAO


//获取粉丝列表
- (void)requestUserFollowers:(NSDictionary *)dict
             completionBlock:(UserRelationshipDAOBlock)completionBlock
              setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserFollowers
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


//获取关注列表
- (void)requestUserFolloweds:(NSDictionary *)dict
             completionBlock:(UserRelationshipDAOBlock)completionBlock
              setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserFolloweds
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



//根据UserId获取User信息
- (void)requestUserInfo:(NSDictionary *)dict
        completionBlock:(UserRelationshipDAOBlock)completionBlock
         setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserInfo
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



//获取商家信息
- (void)requestBusinessInfo:(NSDictionary *)dict
            completionBlock:(UserRelationshipDAOBlock)completionBlock
             setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_BusinessInfo
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




//关注好友
- (void)requestUserFollow:(NSDictionary *)dict
          completionBlock:(UserRelationshipDAOBlock)completionBlock
           setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserFollow
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

// 取消关注好友
- (void)requestUserUnFollow:(NSDictionary *)dict
            completionBlock:(UserRelationshipDAOBlock)completionBlock
             setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserUnFollow
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



// 判断用户1是否有关注用户2
- (void)requestUserHasFollow:(NSDictionary *)dict
             completionBlock:(UserRelationshipDAOBlock)completionBlock
              setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserHasFollow
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


//通讯录列表
- (void)requestInviteFrendsWithPhone:(NSDictionary *)dict
                     completionBlock:(UserRelationshipDAOBlock)completionBlock
                      setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_MobileUsers
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


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
             setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_SaveContacts
                                            postDict:dict
                                     completionBlock:completionBlock
                                      setFailedBlock:failedBlock];
}



// 获取微博中我关注的且已在我们系统中的人
- (void)requestWeiboFrendsWithMyApp:(NSDictionary *)dict
                    completionBlock:(UserRelationshipDAOBlock)completionBlock
                     setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_WeiboFolloweds
                                             getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




// 邀请微博粉丝加入
- (void)requestInviteFrendsWithWeibo:(NSDictionary *)dict
                     completionBlock:(UserRelationshipDAOBlock)completionBlock
                      setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_InviteWeiboFans
                                             getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



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
              setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_DarenWithCity
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}


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
           setFailedBlock:(UserRelationshipDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_PraiseList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}


@end
