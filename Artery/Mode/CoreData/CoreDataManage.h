//
//  CoreDataManage.h
//  Shitan
//
//  Created by 刘敏 on 15/2/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ShopModel.h"
#import "DynamicMode.h"
#import "TipModel.h"
#import "CommentModel.h"
#import "PraiseModel.h"
#import "ShopInfo.h"
#import "PraiseInfo.h"
#import "CommentInfo.h"
#import "TipInfo.h"



@interface CoreDataManage : NSObject

/*  被管理的对象模型
 *  相当于实体，不过它包含 了实体间的关系
 */
@property (readonly, strong, nonatomic) NSManagedObjectModel            *managedObjectModel;


/*  被管理的对象上下文
 *  操作实际内容
 *  作用：插入数据  查询  更新  删除
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext          *managedObjectContext;


/*  持久化存储助理
 *  相当于数据库的连接器
 */
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator    *persistentStoreCoordinator;

@property (assign, nonatomic) NSInteger tableTag;

/********************** DynamicMode *****************************/

//插入数据
- (void)insertCoreData:(NSArray*)dataArray;

//查询所有数据
- (NSArray*)selectCoreData;

//清空数据
- (void)clearAllData;


//查询（根据关键字查询：默认使用imageID来查询， 适用于赞）得到相应的表之后插入数据，再更新数据
- (void)selectDataWithPraise:(PraiseInfo *)pInfo;

//查询（根据关键字查询：默认使用imageID来查询， 适用于评论）得到相应的表之后插入数据，再更新数据
- (void)selectDataWithComment:(CommentInfo *)cInfo;

//查询（根据关键字查询：默认使用userID来查询， 适用于关注）得到相应的表之后插入数据，再更新数据
- (void)selectDataWithFocus:(NSString *)userID;

//清除数据(取消赞)
- (void)clearDataWithPraise:(PraiseInfo *)pInfo;

//删除图片信息
- (void)clearDataWithDyInfo:(NSString *)imageId;

@end
