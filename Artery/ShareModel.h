//
//  ShareModel.h
//  Shitan
//
//  Created by 刘敏 on 14/12/19.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//
//  分享管理类

#import <Foundation/Foundation.h>
#import "UMSocialControllerService.h"

@interface ShareModel : NSObject<UMSocialUIDelegate>

//单列
+ (ShareModel *)getInstance;

/*********************************** 邀请（不带参数） ************************************/
// 微信朋友圈
- (void)wechatInvitation;


// QQ空间
- (void)qzoneInvitation;


// 微博
- (void)weiboInvitation:(NSString *)nickName;


// QQ
- (void)qqInvitation;


// 微信好友
- (void)wechatFriendsInvitation;


// 发布图片到微博
- (void)sendMessageToWeibo:(UIImage *)image
               description:(NSString *)describe;


///*********************************** 分享 ************************************/

/**
 *  分享给QQ好友
 *
 *  @param url            跳转链接
 *  @param thumbnailData  缩略图
 *  @param describe       文字描述
 */
- (void)qqFriendsShareMessageWithUrl:(NSString *)url
                           thumbnail:(NSData *)thumbnailData
                            describe:(NSString *)describe
                               title:(NSString *)tit;



//QQ空间
- (void)qqZoneShareMessageWithUrl:(NSString *)url
                        thumbnail:(NSData *)thumbnailData
                         describe:(NSString *)describe
                            title:(NSString *)tit;

//微博
- (void)weiboShareMessageWithUrl:(NSString *)url
                       thumbnail:(NSString *)thumbnail
                        describe:(NSString *)describe
                           title:(NSString *)tit;


//微信好友
- (void)wechatFriendsMessageWithUrl:(NSString *)url
                          thumbnail:(NSData *)thumbnailData
                           describe:(NSString *)describe
                              title:(NSString *)tit;


//微信朋友圈
- (void)wechatCircleMessageWithUrl:(NSString *)url
                         thumbnail:(NSData *)thumbnailData
                          describe:(NSString *)describe
                             title:(NSString *)tit;


///***********************************团购返利**********************************/

/**
 *  分享给QQ好友
 *
 *  @param url            跳转链接
 *  @param thumbnailData  缩略图
 *  @param describe       文字描述
 */
- (void)qqFriendsShareRebateCodeWithUrl:(NSString *)url
                           thumbnail:(NSData *)thumbnailData
                            describe:(NSString *)describe
                               title:(NSString *)tit;



//QQ空间
- (void)qqZoneShareRebateCodeWithUrl:(NSString *)url
                        thumbnail:(NSData *)thumbnailData
                         describe:(NSString *)describe
                            title:(NSString *)tit;

//微博
- (void)weiboShareRebateCodeWithUrl:(NSString *)url
                          thumbnail:(NSData *)thumbnailData
                           describe:(NSString *)describe
                              title:(NSString *)tit;


//微信好友
- (void)wechatFriendsRebateCodeWithUrl:(NSString *)url
                          thumbnail:(NSData *)thumbnailData
                           describe:(NSString *)describe
                              title:(NSString *)tit;


//微信朋友圈
- (void)wechatCircleRebateCodeWithUrl:(NSString *)url
                         thumbnail:(NSData *)thumbnailData
                          describe:(NSString *)describe
                             title:(NSString *)tit;




@end
