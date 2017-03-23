//
//  MarkInfo.h
//  Shitan
//
//  Created by 刘敏 on 14-10-20.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkInfo : NSObject

@property (nonatomic, strong) NSString *rawTag;       //标签说明
@property (nonatomic, strong) NSString *rawId;        //标签ID
@property (nonatomic, assign) NSInteger mId;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
