//
//  CommentInfo.h
//  Shitan
//
//  Created by 刘敏 on 14-10-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property (nonatomic, assign) NSInteger m_Id;

@property (nonatomic, strong) NSString *parentCommentId;        //父类评论ID
@property (nonatomic, strong) NSString *commentId;              //评论ID
@property (nonatomic, strong) NSString *commentUserId;          //评论者ID
@property (nonatomic, strong) NSString *commentUserNickname;    //评论者昵称
@property (nonatomic, strong) NSString *commentUserPortraitUrl; //评论者头像

@property (nonatomic, assign) NSUInteger userType;              //评论者类型

@property (nonatomic, strong) NSString *commentedUserId;        //被评论者ID
@property (nonatomic, strong) NSString *commentedUserNickname;  //被评论者昵称
@property (nonatomic, strong) NSString *content;                //评论的内容

@property (nonatomic, strong) NSString *createTime;             //创建时间
@property (nonatomic, strong) NSString *updateTime;             //更新时间

@property (nonatomic, strong) NSString *imgId;                  //图像ID

@property (nonatomic, assign) NSInteger mRow;                   //行号 （临时数据）


- (instancetype)initWithParsData:(NSDictionary *)dict;


@end
