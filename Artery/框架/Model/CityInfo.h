//
//  CityInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/9/1.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityInfo : NSObject

@property (nonatomic , strong) NSNumber              * mId;
@property (nonatomic , strong) NSString              * cityId;
@property (nonatomic , strong) NSString              * parentId;
@property (nonatomic , strong) NSString              * name;
@property (nonatomic , strong) NSString              * pinyin;
@property (nonatomic , strong) NSString              * createTime;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
