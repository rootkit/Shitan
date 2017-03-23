//
//  DynamicInfo.m
//  Shitan
//
//  Created by 刘敏 on 14-10-12.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "DynamicInfo.h"
#import "TipInfo.h"

@implementation DynamicInfo


//解析数据
- (instancetype)initWithParsData:(NSDictionary *)dict
{
    //初始化数组
    self.comInfo = [[NSMutableArray alloc] init];
    self.persInfo = [[NSMutableArray alloc] init];

    self.m_Id = [[dict objectForKeyNotNull:@"id"] integerValue];
    
    self.status = [[dict objectForKeyNotNull:@"status"] integerValue];
    
    //评论数
    self.commentCount = [[dict objectForKeyNotNull:@"commentCount"] integerValue];
    //赞数
    self.praiseCount = [[dict objectForKeyNotNull:@"praiseCount"] integerValue];
    
    //是否已经赞过
    self.hasPraise = [[dict objectForKeyNotNull:@"hasPraiseTheImg"] boolValue];
    
    //是否已经收藏
    //self.hasCollection = [[dict objectForKeyNotNull:@"hasCollectionTheImg"] boolValue];
    

    self.imgHeight = [[dict objectForKeyNotNull:@"imgHeight"] integerValue];

    
    self.imgWidth = [[dict objectForKeyNotNull:@"imgWidth"] integerValue];
    
    self.imgId = [dict objectForKeyNotNull:@"imgId"];
    self.imgUrl = [dict objectForKeyNotNull:@"imgUrl"];
    
    if ([dict objectForKey:@"imgDesc"] != [NSNull null]) {
        self.imgDesc = [dict objectForKeyNotNull:@"imgDesc"];
    }
    
    self.userId = [dict objectForKeyNotNull:@"userId"];
    
    if ([dict objectForKey:@"longitude"] != [NSNull null]) {
        self.longitude = [dict objectForKeyNotNull:@"longitude"];
    }
    
    if ([dict objectForKey:@"latitude"] != [NSNull null]) {
        self.latitude = [dict objectForKeyNotNull:@"latitude"];
    }
    
    if ([dict objectForKey:@"city"] != [NSNull null]) {
        self.city = [dict objectForKeyNotNull:@"city"];
    }
    
    self.name = [dict objectForKeyNotNull:@"name"];
    
    self.score = [[dict objectForKeyNotNull:@"score"] integerValue];
    
    //创建时间
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    
    self.userType = [[dict objectForKeyNotNull:@"userType"] integerValue];

    
    //发布者的头像
    self.portraitUrl = [dict objectForKeyNotNull:@"portraitUrl"];
    //昵称
    self.nickname = [dict objectForKeyNotNull:@"nickname"];
    
    //是否已经关注
    if ([dict objectForKey:@"hasFollowTheAuthor"] != [NSNull null])
    {
        self.hasFollowTheAuthor = [[dict objectForKeyNotNull:@"hasFollowTheAuthor"] boolValue];
    }

    //标签信息
    if ([dict objectForKey:@"tags"] != [NSNull null] && [[dict objectForKey:@"tags"] isKindOfClass:[NSArray class]]) {
        self.tags = [self encapsulationTipArray:[dict objectForKey:@"tags"]];
    }
    
    //商铺信息
    if([dict objectForKey:@"shopInfo"] != [NSNull null] && [[dict objectForKey:@"shopInfo"] isKindOfClass:[NSDictionary class]])
    {
        self.sInfo = [[ShopInfo alloc] initWithParsData:[dict objectForKey:@"shopInfo"]];
    }
    
    //评论
    if([dict objectForKey:@"commenters"] != [NSNull null] && [[dict objectForKey:@"commenters"] isKindOfClass:[NSArray class]])
    {
        [self.comInfo addObjectsFromArray:[self encapsulationCommentArray:[dict objectForKey:@"commenters"]]];
    }
    
    
    //赞的用户信息
    if([dict objectForKey:@"praisers"] != [NSNull null] && [[dict objectForKey:@"praisers"] isKindOfClass:[NSArray class]])
    {
        [self.persInfo addObjectsFromArray:[self encapsulationPraiseArray:[dict objectForKey:@"praisers"]]];
       
    }
    
    self.addressId = [dict objectForKeyNotNull:@"addressId"];
    
    return self;
}


//封装标签数组
- (NSArray *)encapsulationTipArray:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in array) {
        TipInfo *tInfo = [[TipInfo alloc] initWithParsData:item];
        [tempArray addObject:tInfo];
     }
    
    return tempArray;
    
}


//封装评论数组
- (NSArray *)encapsulationCommentArray:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in array) {
        CommentInfo *cInfo = [[CommentInfo alloc] initWithParsData:item];
        [tempArray addObject:cInfo];
    }
    
    return tempArray;
    
}


//封装赞数组
- (NSArray *)encapsulationPraiseArray:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in array) {
        PraiseInfo *pInfo = [[PraiseInfo alloc] initWithParsData:item];
        [tempArray addObject:pInfo];
    }
    
    return tempArray;
}

- (NSString *)encapsulationPraiseString:(NSString *)string{
    NSMutableString *tempArray = [[NSMutableString alloc] initWithCapacity:0];
    
//    for (NSDictionary *item in tempString) {
//        <#statements#>
//    }
    return nil;
}


@end
