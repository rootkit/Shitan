//
//  TipModel.h
//  Shitan
//
//  Created by 刘敏 on 15/2/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DynamicMode;

@interface TipModel : NSManagedObject

@property (nonatomic, retain) NSString * branchName;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSNumber * directionFlag;
@property (nonatomic, retain) NSNumber * mId;
@property (nonatomic, retain) NSString * imgId;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSString * tagId;
@property (nonatomic, retain) NSNumber * tagType;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;

@property (nonatomic, retain) DynamicMode *dyInfo;


@end
