//
//  URLsAndGlobalKeys.h
//  Shitan
//
//  Created by 刘敏 on 14-9-12.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//  存储网络接口（宏定义）


#import "SettingModel.h"


///**
// *  域名
// */
//#ifdef DEBUG
//
//#define URL_Domain                   [SettingModel runtimeStatus]
//// GET 请求所用的URL
//#define URL_Common                   [NSString stringWithFormat:@"%@/rest/v2/", [SettingModel runtimeStatus]]
//
//// POST 请求所用的URL
//#define URL_CommonString(path)       [NSString stringWithFormat:@"%@/rest/v2/%@", [SettingModel runtimeStatus], path]
//
//
//#else

// 正式平台
#define URL_Domain                   @"http://shitan.me"
// GET 请求所用的URL
#define URL_Common                   @"http://shitan.me/rest/v2/"
// POST 请求所用的URL
#define URL_CommonString(path)       @"http://shitan.me/rest/v2/" path

// 阿里云oss （正式）
#define Aliyun_AccessKey             @"7YfUoq4WJzRwOX90"
#define Aliyun_SecretKey             @"5JF0upxoEC6mfJKg0ZPyUoLC3l47eR"
#define Aliyun_Bucket                @"ishare-file"

// 图片在服务器的地址（正式）
#define URL_IMAGEFILE                @"http://image.shitan.me/"

//#endif


// 阿里云oss
#define Aliyun_AccessKey             [SettingModel AliyunAccessKey]
#define Aliyun_SecretKey             [SettingModel AliyunSecretKey]
#define Aliyun_Bucket                [SettingModel AliyunBucket]

// 图片在服务器的地址
#define URL_IMAGEFILE                [SettingModel AliyunOSSImageURL]




//用户服务协议
#define URL_ServiceAgreement        @"http://file.shitan.me/html/0dd4572b10fc876eb9c5ed0455ed4176.html"



/**************************************  POST 请求  *********************************/

// 微信登录
#define URL_WeiChat_Login           URL_CommonString(@"user/weixinLogin")

//重置密码
#define URL_Reset_Password          URL_CommonString(@"user/resetPwd")

// 手机号注册
#define URL_Mobile_Register         URL_CommonString(@"user/mobileRegister")

// 手机号登录
#define URL_Mobile_Login            URL_CommonString(@"user/mobileLogin")

//上传图片
#define URL_UploadImg               URL_CommonString(@"file/uploadImg")

//上传头像
#define URL_UploadHeadImg           URL_CommonString(@"file/uploadHeadImg")

//图片发布
#define URL_PicturesReleased        URL_CommonString(@"img/create")

//关注好友
#define URL_UserFollow              URL_CommonString(@"user/follow")

//取消关注
#define URL_UserUnFollow            URL_CommonString(@"user/unfollow")

//更新用户信息
#define URL_UserUpdate              URL_CommonString(@"user/update")

//创建收藏夹
#define URL_FavoriteCreate          URL_CommonString(@"favorite/create")

//收藏图片
#define URL_CollectionImage         URL_CommonString(@"favorite/fav")

//删除收藏夹
#define URL_DeletFavorites          URL_CommonString(@"favorite/delete")

//编辑收藏夹
#define URL_UpdateFavorites         URL_CommonString(@"favorite/update")

//发表评论
#define URL_CommentsPic             URL_CommonString(@"comment/create")

//赞图片
#define URL_PraisePic               URL_CommonString(@"img/praise")

//举报图片
#define URL_ReportPic               URL_CommonString(@"img/report")

//隐藏图片
#define URL_HidePic                 URL_CommonString(@"img/hide")

//创建标签
#define URL_CreateMark              URL_CommonString(@"raw/create")

//创建标签
#define URL_NameCreate              URL_CommonString(@"name/create")

//创建地点
#define URL_AddressCreate           URL_CommonString(@"address/create")

//删除动态图片
#define URL_DeleteImage             URL_CommonString(@"img/delete")

//通讯录列表
#define URL_MobileUsers             URL_CommonString(@"user/mobileUsers")


//保存通讯录
#define URL_SaveContacts            URL_CommonString(@"user/saveContacts")

//绑定微博
#define URL_BindWeiBo               URL_CommonString(@"user/bindWeibo")


//绑定QQ
#define URL_BindQQ                  URL_CommonString(@"user/bindQq")

//绑定微信
#define URL_BindWeiXin              URL_CommonString(@"user/bindWeixin")

//绑定手机
#define URL_BindMobile              URL_CommonString(@"user/bindMobile")

//验证验证码是否正确
#define URL_UserCerificationCode    URL_CommonString(@"verificationCode/check")

//删除OSS图片
#define URL_DeleteOssImg            URL_CommonString(@"img/deleteOssImg")

//用户建议
#define URL_UserSuggest             URL_CommonString(@"suggest/create")

//取消赞
#define URL_CancelPraise            URL_CommonString(@"img/cancelPraise")

//团购初始化
#define URL_InitGroupBuying         URL_CommonString(@"group/init")

//团购列表
#define URL_GroupList               URL_CommonString(@"group/groupList")

//红包列表
#define URL_PacketList              URL_CommonString(@"group/packetList")

//优惠码
#define URL_CouponCode              URL_CommonString(@"group/couponCode")

//提现
#define URL_GroupCash               URL_CommonString(@"group/cash")

//增加收货地址
#define URL_BuyerAddrAdd            URL_CommonString(@"address/create")

//设置默认收货地址
#define URL_BuyerAddrSetDefault     URL_CommonString(@"address/setDefault")

//删除收货地址
#define URL_BuyerAddrDelete         URL_CommonString(@"address/deleteOne")

//删除全部收货地址
#define URL_BuyerALLAddrDelete      URL_CommonString(@"address/deleteAll")

//更新收货地址
#define URL_BuyerAddrUpdate         URL_CommonString(@"address/update")

//创建订单
#define URL_OrderCreate             URL_CommonString(@"order/create")

//收藏某一个商家
#define URL_FavoriteOfShop          URL_CommonString(@"favoriteShop/favorite")

//取消收藏某一商家
#define URL_CannerFavoriteOfShop    URL_CommonString(@"favoriteShop/unFavorite")


/************************************* Get 请求   ***********************************/
//获取注册验证码
#define URL_UserVerCode                 @"verificationCode/get?"

//手机号码手否被注册
#define URL_UserMobileIsRegisted        @"user/mobileIsRegisted?"

//获取个人信息
#define URL_UserInfo					@"user/info?"

//获取商家信息
#define URL_BusinessInfo                @"business/info?"

//获取粉丝列表
#define URL_UserFollowers				@"user/followers?"

//获取关注列表
#define URL_UserFolloweds               @"user/followeds?"

//判断用户1是否有关注用户2
#define URL_UserHasFollow               @"user/hasFollow?"

//获取动态图片列表(1.3 新接口)
#define URL_ImageListII                 @"img/list_ii?"

//获取最新的图片个数
#define URL_ImageNewCount               @"img/newCount?"

//获取图片信息
#define URL_ImageInfo                   @"img/info?"

//获取附近位置列表
#define URL_AddressNearList             @"address/nearest?"

//搜索本地和大众点评(基于同城的地点搜索)
#define URL_SearchAllAddress            @"address/searchAll?"

//收藏夹详情
#define URL_FavoriteInfo                @"favorite/info?"

//用户的收藏夹列表1
#define URL_FavoriteList                @"favorite/userFavorite1?"

//获取收藏夹列表2
#define URL_UserFavorite2               @"favorite/userFavorite2?"

//收藏夹图片列表
#define URL_FavoriteImgs                @"img/favoriteImgs?"

//获取评论列表
#define URL_CommentsList                @"comment/list?"

//搜索标签
#define URL_SearMark                    @"raw/search?"

//获取图片的标签
#define URL_ImageMark                   @"tag/get?"

//获取消息列表
#define URL_MsgGet                      @"message/list?"

//是否有未读消息
#define URL_HasUnreadMessage            @"message/hasUnread?"

//通知列表
#define URL_GetNoticeList               @"notice/list?"

//广播列表
#define URL_GetBroadcastList            @"broadcast/list?"

//获取某一标签下的图片
#define URL_GetImgeWithTags             @"img/tagImgs?"

//获取Top10
#define URL_GetRankingWithImages        @"topImg/get?"

//今日推荐
#define URL_RecommendOfToday            @"recommend/get?"

//获取关注好友的图片
#define URL_MyFriendImgs                @"img/myFriendImgs?"

//用户搜索
#define URL_SearchUserwithKeyword       @"user/search?"

//获取微博中我关注的且已在我们系统中的人
#define URL_WeiboFolloweds              @"user/weiboFolloweds?"

//邀请微博粉丝加入
#define URL_InviteWeiboFans             @"user/weiboFollowers?"

//根据关键字搜索美食名字
#define URL_SearchFoodName              @"name/search?"

//获取用户发布的时间
#define URL_PublishTimes                @"img/publishTimes?"

//用户的美食日志
#define URL_FoodDiary                   @"img/userImgs?"

//同城达人推荐
#define URL_DarenWithCity               @"img/experts?"

//获得图片下点赞列表
#define URL_PraiseList                  @"praise/list?"

//获取商家的菜单
#define URL_MerchantsDishes             @"address/dishes?"

//搜索美食或地点
#define URL_SearchImgOrAddress          @"search/searchImgOrAddress?"

//搜索美食和地点
#define URL_SearchImgAndAddress         @"search/searchImgAndAddress?"

//获取地址标签详细信息
#define URL_AddressTagInfo              @"address/addressTagInfo?"

//根据菜名查找店铺 or 根据店铺查找菜品
#define URL_FindShopsOrDishes           @"address_name/list?"

//某个店铺的某道菜
#define URL_AddressTagNameTagImgs       @"img/addressTagNameTagImgs?"

//店铺中的所有菜
#define URL_DishesListAll               @"name/listAll?"

//店铺中的其他菜
#define URL_DishesListOther             @"name/listOther?"

//已申请参加专题的用户列表
#define URL_SpecialUserList             @"special/applied?"

//专题PO图详情
#define URL_SpecialImgsList             @"special/imgs?"

//申请参加专题
#define URL_SpecialApply                @"special/apply?"

//专题活动的详情介绍
#define URL_SpecialDetails              @"special/details?"

//获取广告横幅列表
#define URL_BannerList                  @"special/banner?"

//获取专题列表
#define URL_SpecialList                 @"special/list?"

//用户参加的专题
#define URL_SpecialJoin                 @"special/join?"


//用户的优惠券信息
#define URL_CouponList                  @"coupons/findList?"

//查找购物时所有可用的优惠券
#define URL_CouponList2                 @"coupons/findList2?"

//前端上传API日志
#define URL_UploadAPILog                @"apiLog/upload?"

//用户收货地址列表
#define URL_BuyerAddrList               @"address/findList?"

//用户的订单列表
#define URL_OrderList                   @"order/findList?"

//首页商户列表
#define URL_MerchantsList               @"business/findList?"

//某个商户信息
#define URL_MerchantsInfo               @"business/findOne?"

//获取某个商户下的所有商品
#define URL_ProductList                 @"product/findList?"

//获取商品详情信息
#define URL_ProductDetail               @"product/detail?"

//获取某个商品的所有规格
#define URL_RulesFindList               @"rules/findList?"

//获取微信支付预付款ID
#define URL_GetWechatPrepayId           @"pay/createPrepayId?"

//查找某条订单记录详情
#define URL_GetOrderDes                 @"order/findOne?"

//查找某条订单记录详情
#define URL_GetOrderState               @"order/getOrderState?"

//查找某张订单下的所有清单记录
#define URL_GetDishesFindList           @"dishes/findList?"

//获取推荐的商户列表
#define URL_FindRecommendList           @"business/getRecommendList?"

//商户分类列表
#define URL_ClassifyFindList            @"classify/findList?"

//获取某一商户下的所有美食记录列表
#define URL_FoodFindList                @"food/findList?"

//分页获取收藏商户列表
#define URL_FavoriteShopFindList        @"favoriteShop/findList?"

//获取已开通的城市列表
#define URL_GetCityList                 @"cityCode/cityList?"

//模糊查询城市记录
#define URL_CityCodeCityList            @"cityCode/findList?"



/**************************************** 第三方get请求 ************************************/
//根据经纬度获取附近地点（腾讯地图）
#define URL_TencentGeocoder             @"http://apis.map.qq.com/ws/geocoder/v1/?"

//根据微信openID获取用户资料
#define URL_WechatUnionID               @"https://api.weixin.qq.com/sns/userinfo?"

//获取指定商户的团购信息(大众点评)
#define URL_DPMerchantsGroup            @"http://api.dianping.com/v1/deal/get_deals_by_business_id"

