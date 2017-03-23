//
//  STLeftMenuView.h
//  Shitan
//
//  Created by Richard Liu on 15/8/24.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//LeftView按钮类型
typedef NS_ENUM(NSInteger, STLeftButtonType) {
    STLeftButtonTypeHome = 0,          //首页
    STLeftButtonTypeFound,             //发现
    STLeftButtonTypeCollection,        //收藏
    STLeftButtonTypeMessage,           //消息
    STLeftButtonTypeMine,              //我的
    STLeftButtonTypeSeting,            //设置
};

typedef NS_ENUM(NSInteger, STNormalButtonType) {
    STNormalWeiXin  = 100,          //微信
    STNormalPhone,                  //手机
};


@protocol STLeftMenuViewDelegate <NSObject>

@optional

//更新UI
- (void)updateLeftMenu;

//左边按钮被点击时调用
- (void)leftMenuViewButtonClcikFrom:(STLeftButtonType)fromIndex to:(STLeftButtonType)toIndex;

//常规按钮点击时调用
- (void)normaluttonClcikFrom:(STNormalButtonType)index;

//cictyBtn城市改变时调用
- (void)leftMenuViewCictyButtonChange;

@end


@interface STLeftMenuView : UIView

@property (nonatomic, weak) id <STLeftMenuViewDelegate> delegate;

- (void)setCityName:(NSString *)cityName;


- (void)jumpMessage;

@end
