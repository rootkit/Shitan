//
//  PraiseModel.h
//  Shitan
//
//  Created by 刘敏 on 15/2/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DynamicMode;

@interface PraiseModel : NSManagedObject

@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSNumber * hasFollowTheAuthor;
@property (nonatomic, retain) NSNumber * mID;
@property (nonatomic, retain) NSString * imgId;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * portraitUrl;
@property (nonatomic, retain) NSString * praiseId;
@property (nonatomic, retain) NSString * userId;

@property (nonatomic, retain) DynamicMode *dyInfo;



@end
