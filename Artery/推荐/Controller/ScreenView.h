//
//  ScreenView.h
//  Shitan
//
//  Created by Richard Liu on 15/9/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STConditionView.h"

@protocol ScreenViewDelegate;

@interface ScreenView : UIView

@property (nonatomic, assign) STConditionButtonType sType;
@property (nonatomic, weak) id<ScreenViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger indexA;  //第一个菜单索引

@property (nonatomic, strong) NSString *areaKey;
@property (nonatomic, strong) NSString *classKey;


- (void)showScreenViewToView:(UIView *)superView;

+ (instancetype)screenView;

@end


@protocol ScreenViewDelegate <NSObject>

- (void)screenView:(ScreenView *)view seletedBtnWithKeyword:(NSString *)keyword
 seletedWithCityID:(NSString *)cityId type:(STConditionButtonType)mType;

@end