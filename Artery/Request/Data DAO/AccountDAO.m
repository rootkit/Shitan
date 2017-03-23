//
//  AccountDAO.m
//  Shitan
//
//  Created by 刘敏 on 14-9-17.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "AccountDAO.h"
#import "RequestModel.h"

@implementation AccountDAO

//更新User信息
- (void)requestUserUpdate:(NSDictionary *)dict
        completionBlock:(AccountDAOBlock)completionBlock
         setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserUpdate
                                              postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


/**
 *  用户搜索（通过昵称、手机号码）
 *  请求方式 GET
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestUserwithSearch:(NSDictionary *)dict
              completionBlock:(AccountDAOBlock)completionBlock
               setFailedBlock:(AccountDAOBlock)failedBlock
{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_SearchUserwithKeyword
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}



/**
 *  获取注册验证码
 *  请求方式 GET
 *
 *  @param dict
 */
- (void)requestVerificationCode:(NSDictionary *)dict
                completionBlock:(AccountDAOBlock)completionBlock
                 setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserVerCode
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



/**
 *  验证验证码的正确性
 *  请求方式 POST
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestCheckverificationCode:(NSDictionary *)dict
                     completionBlock:(AccountDAOBlock)completionBlock
                      setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserCerificationCode
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



/**
 *  验证手机号码是否被注册
 *  请求方式 GET
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestMobileIsRegister:(NSDictionary *)dict
                completionBlock:(AccountDAOBlock)completionBlock
                 setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserMobileIsRegisted
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

/**
 *  手机注册
 *  请求方式 POST
 *
 *  @param dict
 */
- (void)requestMobleRegister:(NSDictionary *)dict
             completionBlock:(AccountDAOBlock)completionBlock
              setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_Mobile_Register
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


/**
 *  绑定手机
 *  请求方式 POST
 
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestBindMobile:(NSDictionary *)dict
          completionBlock:(AccountDAOBlock)completionBlock
           setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BindMobile
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}


/**
 *  微信登录
 *  请求方式 POST
 *
 *  @param dict
 */
- (void)requestWechatLogin:(NSDictionary *)dict
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_WeiChat_Login
                                             postDict:dict
                                      completionBlock:^(NSDictionary *result){
                                          if ([[result objectForKey:@"code"] integerValue] == 200) {
                                              [[AccountInfo sharedAccountInfo] parsAccountData:[result objectForKey:@"obj"]];
                                              [theAppDelegate loginSuccess];
                                          }
                                          else{
                                              MET_MIDDLE([result objectForKey:@"msg"]);
                                          }
                                          
                                          [theAppDelegate.HUDManager hideHUD];
                                      }
                                       setFailedBlock:^(NSDictionary *result) {
                                           MET_MIDDLE([result objectForKey:@"msg"]);
                                           [theAppDelegate.HUDManager hideHUD];
                                       }];
}




/**
 *  手机号码登录
 *  请求方式 POST
 *
 *  @param loginTyp 登录方式
 */
- (void)requestMobleLogin:(NSDictionary *)dict
{

    [[RequestModel shareInstance] requestModelWithAPI:URL_Mobile_Login
                                              postDict:dict
                                      completionBlock:^(NSDictionary *result){
                                          
                                          if ([[result objectForKey:@"code"] integerValue] == 200) {
                                              
                                              [[AccountInfo sharedAccountInfo] parsAccountData:[result objectForKey:@"obj"]];
                                              
                                              [theAppDelegate loginSuccess];
                                          }
                                          else if([[result objectForKey:@"code"] integerValue] == 500)
                                          {
                                              MET_MIDDLE([result objectForKey:@"msg"]);
                                          }
                                          
                                          
                                      }
                                       setFailedBlock:^(NSDictionary *result) {
                                           MET_MIDDLE([result objectForKey:@"msg"]);
                                       }];
}


//重置密码
- (void)requestRestPassword:(NSDictionary *)dict
            completionBlock:(AccountDAOBlock)completionBlock
             setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_Reset_Password
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


/**
 *  绑定微博账户
 *  POST
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestBindWeibo:(NSDictionary *)dict
         completionBlock:(AccountDAOBlock)completionBlock
          setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BindWeiBo
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



/**
 *  绑定QQ
 *  POST
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestBindQQ:(NSDictionary *)dict
      completionBlock:(AccountDAOBlock)completionBlock
       setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BindQQ
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



/**
 *  绑定微信
 *  POST
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestBindWeiChat:(NSDictionary *)dict
           completionBlock:(AccountDAOBlock)completionBlock
            setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BindWeiXin
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




/**
 *  用户提交一条建议
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestSuggestCreate:(NSDictionary *)dict
             completionBlock:(AccountDAOBlock)completionBlock
              setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserSuggest
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

/**
 *  获取微信用户基本信息
 *  get
 *
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)requestWechatUnionid:(NSDictionary *)dict
             completionBlock:(AccountDAOBlock)completionBlock
              setFailedBlock:(AccountDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_WechatUnionID
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}


@end
