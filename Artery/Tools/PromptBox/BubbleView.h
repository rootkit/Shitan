//
//  BubbleView.h
//  Shitan
//
//  Created by 刘敏 on 14-10-18.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PulsingHaloLayer.h"
#import "TipInfo.h"


@protocol BubbleViewDelegate;

@interface BubbleView : UIView

@property (nonatomic, weak) id<BubbleViewDelegate> delegate;
@property (nonatomic, strong) PulsingHaloLayer *halo;

@property (nonatomic, unsafe_unretained) MYTipsType tipType;   //是否是地图标签、常规标签
@property (nonatomic, assign) BOOL isLeft;          //起泡框是否在左边
@property (nonatomic, assign) BOOL isMove;          //是否能移动

@property (nonatomic, strong) NSString *tipID;      //标签ID
@property (nonatomic, strong) NSString *tipName;    //标签名字




/**
 *  创建BubbleView
 *
 *  @param frame  位置、大小
 *  @param title  标题
 *  @param mPoint 坐标点
 *  @param isMark tipType（ 0为美食名， 1为地点， 2为普通 ）
 *
 *  @return BubbleView
 */
- (instancetype)initWithFrame:(CGRect)frame initWithTitle:(NSString *)title
         startPoint:(CGPoint)mPoint tipType:(MYTipsType)tipType;





/**
 *  创建BubbleView   (动态时使用)
 *
 *  @param frame  位置、大小
 *  @param info   标签信息
 *
 *  @return BubbleView
 */
- (instancetype)initWithFrame:(CGRect)frame initWithInfo:(TipInfo *)info;


@end


@protocol BubbleViewDelegate <NSObject>

@optional

// 删除标签
- (void)deleteBubbleView:(NSInteger)mtag;

// 获取标签的详情（详情页标签点击事件）
- (void)clickBubbleViewWithInfo:(NSInteger)mtag;



@end
