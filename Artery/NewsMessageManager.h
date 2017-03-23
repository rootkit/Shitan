//
//  NewsMessageManager.h
//  Shitan
//
//  Created by 刘敏 on 15/1/3.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageDAO.h"

@interface NewsMessageManager : NSObject

@property (nonatomic, strong) MessageDAO *dao;

@property (nonatomic, strong) NSTimer *timeToStart;   //计时器
@property (assign) NSInteger  timeNum;                //计时器的时间


+ (id)shareInstance;

- (void)getUnreadMessages;

//开始倒计时
- (void)startclock;

@end
