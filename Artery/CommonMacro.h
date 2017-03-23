//
//  CommonMacro.h
//  Shitan
//
//  Created by 刘敏 on 14-9-12.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustmMacro.h"
#import "UIDevice+Resolutions.h"
#import "METoast.h"

/***********************************  公共枚举 *******************************/
//账户类型
typedef enum _AccountType{
    Acc_Ordinary    = 0,            //普通用户
    Acc_Admin       = 1,            //管理员
    Acc_SuperAdmin  = 2,            //超级管理员
    Acc_STBB        = 10,           //食探BB
    Acc_Merchant    = 99            //商家
}STAccountType;



//标签类型枚举
typedef enum _TipsType {
    Tip_FoodN       = 0,      //美食名（标签）
    Tip_Location    = 1,      //地点（标签）
    Tip_Normal      = 2       //普通（标签）
    
}MYTipsType;


//web入口
typedef enum _WebEntranceType {
    Type_Special     = 0,      //专题
    Type_Normal      = 1       //普通
    
}WebEntranceType;



//第三方登陆类型枚举
typedef enum _OpenAPIType {
	OpenAPI_Tencent = 0,
    OpenAPI_Weibo = 1,
    OpenAPI_WeiChat = 2,       //微信好友 (分享)
    OpenAPI_WeiChat_Friends    //微信朋友圈（分享）
} OpenAPITag;




typedef enum _PhoneSetType {
    STRetrievePasswordType = 0,             //重设密码
    STBindingMobileType = 1,                //绑定手机
    STAddAddressBook = 2                    //添加通讯录好友
} STPhoneSetType;



//TipsDetailViewCOntroller 入口来源
typedef enum _GroupImageSource {
    FistTypeTips = 0,                       //标签点击（入口来源：点击标签）
    SecondTypeTips = 1,                     //消息模块入口
} STTypeSourceType;


//CommentListViewController 入口来源（评论）
typedef enum _CommentEntranceSource
{
    QualityType = 0,                        //精选
    CityDYType = 1,                         //最新动态（同城）
    FocusDYType = 2,                        //关注动态
    SpecialType = 3,                        //专题入口
    OtherType = 4
}STCommntEntranceType;


typedef enum _ClassificationSearchResults
{
    ImageResults = 0,                    //单品图片
    PlaceResults = 1                     //店铺图片
}STSearchResults;



/**
 专题枚举
 */
typedef enum _SpecialType
{
    STPOImageType = 0,                        //PO图专题
    STSignUpType = 1,                         //报名专题
    STWebType  = 2                            //单纯的网页
    
}STSpecialType;


//订单状态
typedef enum _OrderStatus
{
    ORDER_CREATE        = -1,               //订单已创建
    ORDER_NOPAY         = 0,                //未支付
    ORDER_PAY_SUCCESS   = 1,                //支付成功
    ORDER_REFUND_ING    = 2,                //申请退款
    ORDER_REFUND_COMPLETE = 3,              //退款成功
    ORDER_CLOSE         = 4,                //交易关闭
    ORDER_COMPLETE      = 5                 //交易成功

}OrderStatus;

//优惠券类型
typedef enum _CouponsType
{
    Coupons_General             = 0,       //通用券（现金券）无消费金额、店铺限制
    Coupons_Full_Reduction      = 1,       //满减券
    Coupons_Special             = 2        //特殊券（如：双十一优惠券，元旦优惠券）
}CouponsType;

/******************************************************************************/
#define MAX_INPUT_LENGTH    512             //评论、发布文字的长度
#define kDesLabelMargin     12


#define CREATCONTROLLER(ClassName)          [[ClassName alloc] initWithNibName:[NSString stringWithFormat:@"%s",#ClassName] bundle:nil];

#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]



// 主色调（玫红）
#define MAIN_COLOR  [UIColor colorWithHex:0xe03941]

// 黄色
#define ST_YELLOW_COLOR [UIColor colorWithHex:0xf5a623]

// 主页标题文字颜色
#define MAIN_TITLE_COLOR  [UIColor colorWithHex:0x929292]

#define NAVIGATION_BACKGROUND_COLOR        [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1.0]

#define BACKGROUND_COLOR        [UIColor colorWithHex:0xefeff4]

// 动态详情正文颜色
#define MAIN_TEXT_COLOR         [UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]

// 动态详情人物名称颜色
#define MAIN_USERNAME_COLOR     [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0]

// 动态列表人名颜色
#define DYLIST_USERNAME_COLOR   [UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1.0]

// 动态详情时间名称颜色
#define MAIN_TIME_COLOR         [UIColor colorWithHex:0xa0a0a0]

// 动态列表时间颜色
#define DYLIST_TIME_COLOR       [UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0]

// 收藏CELL颜色
#define MINE_FAVORITE_BACKGROUND_COLOR       [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:235.0/255.0 alpha:1.0]

#define MINE_FAVORITE_BACKGROUND1_COLOR       [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:215.0/255.0 alpha:1.0]


//用于头像（缩略图）
#define  IMAGE_80_80_HEAD           @"@1e_80w_80h_0c_0i_1o_100Q_1x.jpg"

//用户美食缩略图
#define  IMAGE_160_160_FOOD         @"@1e_160w_160h_0c_0i_1o_100Q_1x.jpg"

//用户美食缩略图
#define  IMAGE_200_200_FOOD         @"@1e_200w_200h_0c_0i_1o_100Q_1x.jpg"

//用户美食缩略图
#define  IMAGE_320_320_FOOD         @"@1e_320w_320h_0c_0i_1o_100Q_1x.jpg"

//用户美食缩略图
#define  IMAGE_480_480_FOOD         @"@1e_480w_480h_0c_0i_1o_100Q_1x.jpg"

//版本号
#define APP_Version       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


//ios7导航栏遮住View
#define SYSTEMVERSION_IOS7  if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {\
self.edgesForExtendedLayout = UIRectEdgeNone;\
self.extendedLayoutIncludesOpaqueBars = NO;\
self.modalPresentationCapturesStatusBarAppearance = NO;\
}




/*****************************  系统控件相关 ****************************/

//系统版本
#define isIOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
#define isIOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)

//状态栏高度
#define IOSValue      ([[[UIDevice currentDevice] systemVersion] floatValue])
#define StatusbarSize ((IOSValue >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)?20.f:0.f)

//屏幕大小
#define MAINSCREEN   [UIScreen mainScreen].applicationFrame

//屏幕尺寸
#define MAINBOUNDS   [UIScreen mainScreen].bounds


#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//抽屉顶部距离 底部一样
#define STScaleTopMargin                    35

//抽屉拉出来右边剩余比例
#define STZoomScaleRight                    0.4

#define TabBarHeight                        49.0f
#define NaviBarHeight                       44.0f

#define IPHONE5_WIDTH                       320.0f
#define IPHONE6_WIDTH                       375.0f
#define IPHONE6_PLUS_WIDTH                  414.0f    //Plus有两种模式

#define CUSTOM_NAVBARHIGHT                  64.0f

#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define SelfDefaultToolbarHeight            self.navigationController.navigationBar.frame.size.height


#define ViewCtrlTopBarHeight                (isIOS7 ? (NaviBarHeight + StatusBarHeight) : NaviBarHeight)
#define IsUseIOS7SystemSwipeGoBack          (isIOS7 ? YES : NO)





#define kScreenHeight [UIScreen mainScreen].bounds.size.height




/*********************************** 动态列表文字 ***********************************/
#define EmotionItemPattern              @"\\[em:(\\d+):\\]"
#define PlaceHolder                     @" "

#define FontSize                        14.0f       //字体大小
#define LineSpacing                     10.0f       //字间距
#define limitline                       99          //行数（大于这个收起）

#define kSelf_SelectedColor [UIColor colorWithWhite:0 alpha:0.4] //点击背景  颜色
#define kUserName_SelectedColor [UIColor colorWithWhite:0 alpha:0.25]//点击姓名颜色

#define AttributedImageNameKey          @"ImageName"
