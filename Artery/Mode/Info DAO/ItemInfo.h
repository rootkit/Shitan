//
//  ItemInfo.h
//  Shitan
//
//  Created by RichardLiu on 15/4/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemInfo : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *mId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nameId;
@property (nonatomic, strong) NSString *nameImgUrl;
@property (nonatomic, assign) NSUInteger score;


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
