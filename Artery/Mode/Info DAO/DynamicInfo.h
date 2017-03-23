//
//  DynamicInfo.h
//  Shitan
//
//  Created by 刘敏 on 14-10-12.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopInfo.h"
#import "CommentInfo.h"
#import "PraiseInfo.h"

@interface DynamicInfo : NSObject

@property (nonatomic, assign) NSInteger m_Id;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSString *addressId;

@property (nonatomic, assign) NSInteger commentCount;       //评论数
@property (nonatomic, assign) NSInteger praiseCount;        //赞数
@property (nonatomic, assign) NSUInteger userType;          //账户类型

@property (nonatomic, assign) BOOL hasPraise;               //是否已经赞过
//@property (nonatomic, assign) BOOL hasCollection;         //是否已经收藏

@property (nonatomic, assign) NSUInteger imgHeight;         //图片高度
@property (nonatomic, assign) NSUInteger imgWidth;          //图片宽度

@property (nonatomic, assign) BOOL hasFollowTheAuthor;      //是否已关注（YES为已经关注，NO为未关注）

@property (nonatomic, strong) NSString *longitude;          //经度
@property (nonatomic, strong) NSString *latitude;           //纬度

@property (nonatomic, strong) NSString *imgId;              //图片ID
@property (nonatomic, strong) NSString *imgUrl;             //图片url
@property (nonatomic, strong) NSString *imgDesc;            //图片描述
@property (nonatomic, strong) NSString *userId;             //图片发布者的ID

@property (nonatomic, assign) NSUInteger score;              //分数

@property (nonatomic, strong) NSString *city;               //城市

@property (nonatomic, strong) NSString *createTime;         //创建时间
@property (nonatomic, strong) NSString *portraitUrl;        //发布者的头像
@property (nonatomic, strong) NSString *nickname;           //昵称

@property (nonatomic, strong) NSString *name;               //菜名

@property (nonatomic, strong) NSArray *tags;                //标签数组

@property (nonatomic, strong) ShopInfo* sInfo;              //商铺信息
@property (nonatomic, strong) NSMutableArray *comInfo;      //评论信息
@property (nonatomic, strong) NSMutableArray *persInfo;     //赞的用户信息


@property (nonatomic, copy) NSMutableString *praiseText;    //评论文本
@property (nonatomic, copy) NSMutableString *commentText;   //点赞文本


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
