//
//  ClassInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/8/13.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassInfo : NSObject

@property (nonatomic , strong) NSString              * parentId;
@property (nonatomic , strong) NSNumber              * sort;
@property (nonatomic , strong) NSString              * geoHash;
@property (nonatomic , strong) NSString              * cId;
@property (nonatomic , strong) NSNumber              * latitude;
@property (nonatomic , strong) NSNumber              * longitude;
@property (nonatomic , strong) NSString              * cName;
@property (nonatomic , strong) NSString              * icon;
@property (nonatomic , strong) NSString              * createTime;

@property (nonatomic , strong) NSArray               * classArray;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
