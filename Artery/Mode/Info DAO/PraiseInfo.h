//
//  PraiseInfo.h
//  Shitan
//
//  Created by 刘敏 on 15/1/30.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PraiseInfo : NSObject

@property (nonatomic, assign) NSInteger mID;
@property (nonatomic, assign) BOOL hasFollowTheAuthor;      //是否已关注（YES为已经关注，NO为未关注）

@property (nonatomic, strong) NSString *imgId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *portraitUrl;
@property (nonatomic, strong) NSString *praiseId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *createTime;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
