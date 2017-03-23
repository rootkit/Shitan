//
//  CoreDataManage.m
//  Shitan
//
//  Created by 刘敏 on 15/2/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//


#import "CoreDataManage.h"
#import "DynamicModelFrame.h"

@interface CoreDataManage()

@end


@implementation CoreDataManage

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



//创建管理对象模型
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}


//创建托管对象上下文
//托管对象上下文类似于应用程序和数据存储之间的一块缓冲区。这块缓冲区包含所有未被写入数据存储的托管对象。你可以添加、删除、更改缓冲区内的托管对象。在很多时候，当你需要读、插入、删除对象时，你将会调用托管对象上下文的方法。
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

//创建持久化数据存储协调器
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    //创建数据库存储位置
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString * filepath = nil;
    if (_tableTag == 0)
    {
        filepath = [pathDocuments stringByAppendingPathComponent:@"QualityRecordDB.sqlite"];
    }
    if (_tableTag == 1) {
        filepath = [pathDocuments stringByAppendingPathComponent:@"CityRecordDB.sqlite"];
    }
    else if(_tableTag == 2){                           
        filepath = [pathDocuments stringByAppendingPathComponent:@"FocusRecordDB.sqlite"];
    }
    else if(_tableTag == 3)
    {
        filepath = [pathDocuments stringByAppendingPathComponent:@"TempDB.sqlite"];
    }

    NSError *error = nil;
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:filepath] options:nil error:&error]) {
        CLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}


////插入数据
- (void)insertCoreData:(NSArray*)dataArray{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (NSDictionary *item in  dataArray) {
        DynamicMode *dyn = (DynamicMode *)[NSEntityDescription insertNewObjectForEntityForName:@"Dynamic" inManagedObjectContext:context];
        
        dyn.city = [item objectForKeyNotNull:@"city"];
        dyn.commentCount = [item objectForKeyNotNull:@"commentCount"];
        dyn.createTime  = [item objectForKeyNotNull:@"createTime"];
        dyn.hasFollowTheAuthor = [item objectForKeyNotNull:@"hasFollowTheAuthor"];
        dyn.hasPraiseTheImg = [item objectForKeyNotNull:@"hasPraiseTheImg"];
        dyn.m_Id = [item objectForKeyNotNull:@"id"];
        dyn.imgCategory = [NSString stringWithFormat:@"%@",[item objectForKeyNotNull:@"imgCategory"]];
        dyn.imgDesc = [item objectForKeyNotNull:@"imgDesc"];
        dyn.imgHeight = [item objectForKeyNotNull:@"imgHeight"];
        dyn.imgId = [item objectForKeyNotNull:@"imgId"];
        dyn.imgUrl = [item objectForKeyNotNull:@"imgUrl"];
        dyn.imgWidth = [item objectForKeyNotNull:@"imgWidth"];
        dyn.latitude = [item objectForKeyNotNull:@"latitude"];
        dyn.longitude = [item objectForKeyNotNull:@"longitude"];
        dyn.nickname = [item objectForKeyNotNull:@"nickname"];
        dyn.portraitUrl = [item objectForKeyNotNull:@"portraitUrl"];
        dyn.praiseCount = [item objectForKeyNotNull:@"praiseCount"];
        dyn.score = [item objectForKeyNotNull:@"score"];
        dyn.snsPlatform = [item objectForKeyNotNull:@"snsPlatform"];
        dyn.status = [item objectForKeyNotNull:@"status"];
        dyn.userId = [item objectForKeyNotNull:@"userId"];
        dyn.addressId = [item objectForKeyNotNull:@"addressId"];
        dyn.userType = [item objectForKeyNotNull:@"userType"];
        
        //商户信息
        if ([item objectForKeyNotNull:@"shopInfo"]) {
            //ShopModel
            ShopModel *shop = (ShopModel *)[NSEntityDescription insertNewObjectForEntityForName:@"ShopModel" inManagedObjectContext:context];
            
            shop.address = [[item objectForKeyNotNull:@"shopInfo"] objectForKeyNotNull:@"address"];
            shop.addressName = [[item objectForKeyNotNull:@"shopInfo"] objectForKeyNotNull:@"addressName"];
            shop.avgPrice = [NSNumber numberWithFloat:[[[item objectForKeyNotNull:@"shopInfo"] objectForKeyNotNull:@"avgPrice"] floatValue]];
            shop.branchName = [[item objectForKeyNotNull:@"shopInfo"] objectForKeyNotNull:@"branchName"];
            shop.latitude = [[item objectForKeyNotNull:@"shopInfo"] objectForKeyNotNull:@"latitude"];
            shop.longitude = [[item objectForKeyNotNull:@"shopInfo"] objectForKeyNotNull:@"longitude"];
            shop.phone = [[item objectForKeyNotNull:@"shopInfo"] objectForKeyNotNull:@"phone"];
            
            dyn.shopInfo = shop;
        }
        
        //标签信息
        if ([[item objectForKeyNotNull:@"tags"] isKindOfClass:[NSArray class]] && [[item objectForKeyNotNull:@"tags"] count] > 0) {
            
            for (NSDictionary *tags in [item objectForKeyNotNull:@"tags"]) {
                //TipModel
                TipModel *tips = (TipModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Tags" inManagedObjectContext:context];
                
                tips.branchName = [tags objectForKeyNotNull:@"branchName"];
                tips.createTime = [tags objectForKeyNotNull:@"createTime"];
                tips.directionFlag = [tags objectForKeyNotNull:@"directionFlag"];
                tips.mId = [tags objectForKeyNotNull:@"id"];
                tips.imgId = [tags objectForKeyNotNull:@"imgId"];
                
                //标签名
                if ([[tags objectForKeyNotNull:@"branchName"] length] > 0) {
                    
                    NSString *nameT = [tags objectForKeyNotNull:@"tag"];
                    
                    tips.tag = [[[nameT stringByAppendingString:@"("] stringByAppendingString:[tags objectForKey:@"branchName"]] stringByAppendingString:@")"];
                }
                else
                {
                    tips.tag = [tags objectForKeyNotNull:@"tag"];
                }

                tips.tagId = [tags objectForKeyNotNull:@"tagId"];
                tips.tagType = [tags objectForKeyNotNull:@"tagType"];
                tips.x = [tags objectForKeyNotNull:@"x"];
                tips.y = [tags objectForKeyNotNull:@"y"];
                
                [dyn addTagsObject:tips];
            }
        }
        
        //赞信息
        if ([[item objectForKeyNotNull:@"praisers"] isKindOfClass:[NSArray class]] && [[item objectForKeyNotNull:@"praisers"] count] > 0) {
            
            for (NSDictionary *key in [item objectForKeyNotNull:@"praisers"]) {
                //TipModel
                PraiseModel *par = (PraiseModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Praise" inManagedObjectContext:context];
                
                par.mID = [key objectForKeyNotNull:@"id"];
                par.imgId = [key objectForKeyNotNull:@"imgId"];
                par.userId = [key objectForKeyNotNull:@"userId"];
                par.praiseId = [key objectForKeyNotNull:@"praiseId"];
                par.nickName = [key objectForKeyNotNull:@"nickName"];
                par.createTime = [key objectForKeyNotNull:@"createTime"];
                par.portraitUrl = [key objectForKeyNotNull:@"portraitUrl"];
                par.hasFollowTheAuthor = [key objectForKeyNotNull:@"hasFollowTheAuthor"];
                
                [dyn addPraisersObject:par];
            }
        }
        
        //评论信息
        if ([[item objectForKeyNotNull:@"commenters"] isKindOfClass:[NSArray class]] && [[item objectForKeyNotNull:@"commenters"] count] > 0) {
            
            for (NSDictionary *key in [item objectForKeyNotNull:@"commenters"]) {
                //TipModel
                CommentModel *comment = (CommentModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Commenters" inManagedObjectContext:context];
                
                comment.m_Id = [key objectForKeyNotNull:@"id"];
                comment.imgId = [key objectForKeyNotNull:@"imgId"];
                comment.content = [key objectForKeyNotNull:@"content"];
                comment.commentId = [key objectForKeyNotNull:@"commentId"];
                comment.createTime = [key objectForKeyNotNull:@"createTime"];
                comment.commentUserId = [key objectForKeyNotNull:@"commentUserId"];
                comment.parentCommentId = [key objectForKeyNotNull:@"parentCommentId"];
                comment.commentedUserId = [key objectForKeyNotNull:@"commentedUserId"];
                comment.commentUserNickname = [key objectForKeyNotNull:@"commentUserNickname"];
                comment.commentedUserNickname = [key objectForKeyNotNull:@"commentedUserNickname"];
                comment.commentUserPortraitUrl = [key objectForKeyNotNull:@"commentUserPortraitUrl"];
                
                [dyn addCommentersObject:comment];
            }
        }
        
        
        NSError * error = nil;
        if ([[self managedObjectContext] save:&error])
        {
            CLog( @"数据成功插入");
        }
        else
        {
            CLog(@"add entity error = %@",error);
        }
    }
}


//查询
- (NSArray*)selectCoreData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //获取数据的请求
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * desption = [NSEntityDescription entityForName:@"Dynamic" inManagedObjectContext:context];
    [request setEntity:desption];
    
    NSMutableArray *tempA = [[NSMutableArray alloc] init];
    
    NSError * error = nil;
    NSArray * result = [context executeFetchRequest:request error:&error];
    if (!error)
    {
        [result enumerateObjectsUsingBlock:^(DynamicMode * obj, NSUInteger idx, BOOL *stop) {
            
            DynamicInfo *dInfo = [[DynamicInfo alloc] init];
            dInfo.city = obj.city;
            dInfo.m_Id = [obj.m_Id integerValue];
            dInfo.status = [obj.status integerValue];
            dInfo.commentCount = [obj.commentCount integerValue];
            dInfo.praiseCount = [obj.praiseCount integerValue];
            dInfo.hasPraise = [obj.hasPraiseTheImg boolValue];
            dInfo.imgHeight = [obj.imgHeight integerValue];
            dInfo.imgWidth = [obj.imgWidth integerValue];
            dInfo.hasFollowTheAuthor = [obj.hasFollowTheAuthor boolValue];
            dInfo.longitude = [obj.latitude stringValue];
            dInfo.latitude = [obj.latitude stringValue];
            dInfo.imgId = obj.imgId;
            dInfo.imgUrl = obj.imgUrl;
            dInfo.imgDesc = obj.imgDesc;
            dInfo.userId = obj.userId;
            dInfo.createTime = obj.createTime;
            dInfo.portraitUrl = obj.portraitUrl;
            dInfo.nickname = obj.nickname;
            dInfo.score = [obj.score integerValue];
            dInfo.addressId = obj.addressId;
            dInfo.userType = [obj.userType integerValue];
            
            //商户信息
            ShopModel *shop = obj.shopInfo;
            {
                ShopInfo *s_Info = [[ShopInfo alloc] init];
                s_Info.address = shop.address;
                s_Info.addressName = shop.addressName;
                s_Info.avgPrice = [shop.avgPrice stringValue];
                s_Info.branchName = shop.branchName;
                s_Info.phone = shop.phone;
                s_Info.longitude = [shop.longitude stringValue];
                s_Info.latitude = [shop.latitude stringValue];
                
                dInfo.sInfo = s_Info;
            }
            
            
            //评论信息
            NSArray *comSet = [obj.commenters allObjects];
            NSMutableArray *comArray = [[NSMutableArray alloc] initWithCapacity:comSet.count];
            for (CommentModel *comm in comSet) {
                CommentInfo *c_Info = [[CommentInfo alloc] init];
                
                c_Info.m_Id = [comm.m_Id integerValue];
                c_Info.parentCommentId = comm.parentCommentId;
                c_Info.commentId = comm.commentId;
                c_Info.commentUserId = comm.commentUserId;
                c_Info.commentUserNickname = comm.commentUserNickname;
                c_Info.commentUserPortraitUrl = comm.commentUserPortraitUrl;
                c_Info.commentedUserId = comm.commentedUserId;
                c_Info.commentedUserNickname = comm.commentedUserNickname;
                c_Info.content = comm.content;
                c_Info.createTime = comm.createTime;
                c_Info.imgId = comm.imgId;
                
                [comArray addObject:c_Info];
            }
            dInfo.comInfo = comArray;
            
            
            
            //标签信息
            NSSet *setA = obj.tags;
            NSMutableArray *tipsArray = [[NSMutableArray alloc] initWithCapacity:setA.count];
            for(TipModel *item in setA) {
                TipInfo *t_Info = [[TipInfo alloc] init];
                t_Info.createTime = item.createTime;
                t_Info.imgId = item.imgId;
                t_Info.title = item.tag;
                t_Info.tagId = item.tagId;
                t_Info.point_X = [item.x floatValue];
                t_Info.point_Y = [item.y floatValue];
                t_Info.mId = [item.mId integerValue];
                t_Info.isLeft = [item.directionFlag boolValue];
                t_Info.tipType = (MYTipsType)[item.tagType integerValue];
                [tipsArray addObject:t_Info];
            }
            dInfo.tags = tipsArray;
            
            
            
            //赞信息
            NSSet *praisSet = obj.praisers;
            NSMutableArray *praisArray = [[NSMutableArray alloc] initWithCapacity:praisSet.count];
            for (PraiseModel *pItem in praisSet) {
                PraiseInfo *p_Info = [[PraiseInfo alloc] init];
                
                p_Info.mID = [pItem.mID integerValue];
                p_Info.hasFollowTheAuthor = [pItem.hasFollowTheAuthor boolValue];
                p_Info.imgId = pItem.imgId;
                p_Info.nickName = pItem.nickName;
                p_Info.portraitUrl = pItem.portraitUrl;
                p_Info.praiseId = pItem.praiseId;
                p_Info.userId = pItem.userId;
                p_Info.createTime = pItem.createTime;
                
                [praisArray addObject:p_Info];
            }
            dInfo.persInfo = praisArray;
            
            DynamicModelFrame *dynamicModelFrame = [[DynamicModelFrame alloc] init];
            dynamicModelFrame.dInfo = dInfo;

            [tempA addObject:dynamicModelFrame];

        }];
        
    }
    else
    {
        CLog(@"error seach  = %@",error);
    }
    
    return tempA;
}


//清空数据
- (void)clearAllData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    for (NSInteger i = 0; i< 4; i++) {
        NSEntityDescription * desption = nil;
        
        if (i == 0) {
            desption = [NSEntityDescription entityForName:@"Dynamic" inManagedObjectContext:context];
        }
        if (i == 1) {
            desption = [NSEntityDescription entityForName:@"Commenters" inManagedObjectContext:context];
        }
        if (i == 2) {
            desption = [NSEntityDescription entityForName:@"Praise" inManagedObjectContext:context];
        }
        if (i == 3) {
            desption = [NSEntityDescription entityForName:@"Tags" inManagedObjectContext:context];
        }

        [request setEntity:desption];
        
        NSError * error = nil;
        NSArray * datas = [context executeFetchRequest:request error:&error];
        
        if (!error && datas && [datas count])
        {
            for (NSManagedObject *obj in datas)
            {
                [context deleteObject:obj];
            }
            if (![context save:&error])
            {
                CLog(@"error:%@",error);
            }
        }
    }
}


//查询（根据关键字查询：默认使用imageID来查询， 适用于赞）到相应的表之后插入数据，再更新数据
- (void)selectDataWithPraise:(PraiseInfo *)pInfo
{
    CLog(@"%ld", (long)self.tableTag);
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * desption = [NSEntityDescription entityForName:@"Dynamic" inManagedObjectContext:context];
    [request setEntity:desption];
    
    //查询
    NSPredicate *qcmd = [NSPredicate predicateWithFormat:@"imgId=%@", pInfo.imgId];
    [request setPredicate:qcmd];
    
    NSArray *objecs = [context executeFetchRequest:request error:nil];
    CLog(@"%@", objecs);
    
    DynamicMode *obj = [objecs objectAtIndex:0];
    
    //赞状态
    obj.hasPraiseTheImg = [NSNumber numberWithBool:YES];
    //赞数目统计
    obj.praiseCount = [NSNumber numberWithInteger:[obj.praiseCount integerValue]+1];
    
    
    
    
    PraiseModel *par = (PraiseModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Praise" inManagedObjectContext:context];
    
    par.mID = [NSNumber numberWithInteger:pInfo.mID];
    par.imgId = pInfo.imgId;
    par.userId = pInfo.userId;
    par.praiseId = pInfo.praiseId;
    par.nickName = pInfo.nickName;
    par.createTime = pInfo.createTime;
    par.portraitUrl = pInfo.portraitUrl;
    par.hasFollowTheAuthor = [NSNumber numberWithBool:pInfo.hasFollowTheAuthor];
    
    [obj addPraisersObject:par];
    
    NSError * error = nil;
    if ([context save:&error])
    {
        CLog( @"数据成功插入");
    }
    else
    {
        CLog(@"add entity error = %@",error);
    }
}


//查询（根据关键字查询：默认使用imageID来查询， 适用于评论）到相应的表之后插入数据，再更新数据
- (void)selectDataWithComment:(CommentInfo *)cInfo
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * desption = [NSEntityDescription entityForName:@"Dynamic" inManagedObjectContext:context];
    [request setEntity:desption];
    
    //查询
    NSPredicate *qcmd = [NSPredicate predicateWithFormat:@"imgId=%@", cInfo.imgId];
    [request setPredicate:qcmd];
    
    NSArray *objecs = [context executeFetchRequest:request error:nil];
    CLog(@"%@", objecs);

    DynamicMode *obj = [objecs objectAtIndex:0];
    //评论数目统计
    obj.commentCount = [NSNumber numberWithInteger:[obj.commentCount integerValue]+1];
    
    //有4条要先清空一条（最老的一条）
    if(obj.commenters.count == 4){
        //判断评论是不是已经有4条
        NSArray *setA = [obj.commenters allObjects];
        NSSortDescriptor *sorter  = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
        NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sorter count:1];
        
        //排列后的数组
        NSMutableArray *sortArray = [[NSMutableArray alloc] initWithArray:[setA sortedArrayUsingDescriptors:sortDescriptors]];
        
        
        CommentModel *tempCom = [sortArray objectAtIndex:0];
        [obj removeCommentersObject:tempCom];
    }
    
    
    
    CommentModel *com = (CommentModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Commenters" inManagedObjectContext:context];

    
    com.commentedUserId = cInfo.commentedUserId;
    com.commentedUserNickname = cInfo.commentedUserNickname;
    com.commentId = cInfo.commentId;
    com.commentUserId = cInfo.commentUserId;
    com.commentUserNickname = cInfo.commentUserNickname;
    com.commentUserPortraitUrl = cInfo.commentUserPortraitUrl;
    com.content = cInfo.content;
    com.createTime = cInfo.createTime;
    com.imgId = cInfo.imgId;
    com.parentCommentId = cInfo.parentCommentId;
    
    [obj addCommentersObject:com];
    
    NSError * error = nil;
    if ([context save:&error])
    {
        CLog( @"数据成功插入");
    }
    else
    {
        CLog(@"add entity error = %@",error);
    }
}


//查询（根据关键字查询：默认使用userID来查询， 适用于关注）得到相应的表之后插入数据，再更新数据
- (void)selectDataWithFocus:(NSString *)userID
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * desption = [NSEntityDescription entityForName:@"Dynamic" inManagedObjectContext:context];
    [request setEntity:desption];
    
    //查询
    NSPredicate *qcmd = [NSPredicate predicateWithFormat:@"userId=%@", userID];
    [request setPredicate:qcmd];
    
    NSArray *objecs = [context executeFetchRequest:request error:nil];
    CLog(@"%@", objecs);
    
    for(DynamicMode *item in objecs)
    {
        item.hasFollowTheAuthor = [NSNumber numberWithBool:YES];
        
    }
    
    NSError * error = nil;
    if ([context save:&error])
    {
        CLog( @"更新数据库");
    }
    else
    {
        CLog(@"add entity error = %@",error);
    }
}


//清除数据(取消赞)
- (void)clearDataWithPraise:(PraiseInfo *)pInfo
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * desption = [NSEntityDescription entityForName:@"Dynamic" inManagedObjectContext:context];
    [request setEntity:desption];
    
    //查询
    NSPredicate *qcmd = [NSPredicate predicateWithFormat:@"imgId=%@", pInfo.imgId];
    [request setPredicate:qcmd];
    
    NSArray *objecs = [context executeFetchRequest:request error:nil];
    CLog(@"%@", objecs);
    
    DynamicMode *obj = [objecs objectAtIndex:0];
    
    //赞状态
    obj.hasPraiseTheImg = [NSNumber numberWithBool:NO];
    //赞数目统计
    obj.praiseCount = [NSNumber numberWithInteger:[obj.praiseCount integerValue]-1];
    
    
    NSSet *setA = obj.praisers;
    for(PraiseModel *par in setA) {
        if([par.userId isEqualToString:pInfo.userId])
        {
            //删除
            [obj removePraisersObject:par];
            break;
        }
    }
    
    
    if([context hasChanges]) {
        NSError * error = nil;
        if ([context save:&error])
        {
            CLog( @"数据删除成功");
        }
        else
        {
            CLog(@"add entity error = %@",error);
        }
    }
}


//删除图片信息
- (void)clearDataWithDyInfo:(NSString *)imageId
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * desption = [NSEntityDescription entityForName:@"Dynamic" inManagedObjectContext:context];
    [request setEntity:desption];
    
    //查询
    NSPredicate *qcmd = [NSPredicate predicateWithFormat:@"imgId=%@", imageId];
    [request setPredicate:qcmd];
    
    NSArray *fetchResult = [context executeFetchRequest:request error:nil];
    
    for(DynamicMode *obj in fetchResult) {
        
        //删除赞
        NSSet *setA = obj.praisers;
        if (setA) {
            [obj removePraisers:setA];
        }

        //删除评论
        NSSet *setB = obj.commenters;
        if (setB) {
            [obj removeCommenters:setB];
        }

        //删除标签
        NSSet *setC = obj.tags;
        if (setC) {
            [obj removeTags:setC];
        }

        [context deleteObject:obj];
    }
    
    if([context hasChanges]) {
        NSError * error = nil;
        if ([context save:&error])
        {
            CLog( @"数据删除成功");
        }
        else
        {
            CLog(@"add entity error = %@",error);
        }
    }

}

@end
