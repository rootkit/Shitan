//
//  BroadcastInfo.h
//  Shitan
//
//  Created by 刘敏 on 14-10-29.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BroadcastInfo : NSObject

@property (weak, nonatomic) NSString *broadcastId;
@property (weak, nonatomic) NSString *descriptions;
@property (weak, nonatomic) NSString *createTime;
@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *url;

@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger m_Id;



- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
