//
//  CommentModel.h
//  Shitan
//
//  Created by 刘敏 on 15/2/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DynamicMode;

@interface CommentModel : NSManagedObject

@property (nonatomic, retain) NSString * commentedUserId;
@property (nonatomic, retain) NSString * commentedUserNickname;
@property (nonatomic, retain) NSString * commentId;
@property (nonatomic, retain) NSString * commentUserId;
@property (nonatomic, retain) NSString * commentUserNickname;
@property (nonatomic, retain) NSString * commentUserPortraitUrl;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSNumber * m_Id;
@property (nonatomic, retain) NSString * imgId;
@property (nonatomic, retain) NSString * parentCommentId;

@property (nonatomic, retain) DynamicMode *dyInfo;


@end
