//
//  FavInfo.m
//  Shitan
//
//  Created by 刘敏 on 14-11-3.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//  收藏夹

#import "FavInfo.h"

@implementation FavInfo

- (instancetype)initWithParsData:(NSDictionary *)dict{
    
    
    if ([dict objectForKey:@"favoriteDesc"] != [NSNull null])
    {
        self.favoriteDesc = [dict objectForKey:@"favoriteDesc"];
    }
    
    if ([dict objectForKey:@"favoriteId"] != [NSNull null]) {
        self.favoriteId = [dict objectForKey:@"favoriteId"];
    }
    
    if ([dict objectForKey:@"imgId"] != [NSNull null]) {
        self.imgId = [dict objectForKey:@"imgId"];
    }
    
    if ([dict objectForKey:@"title"] != [NSNull null]) {
        self.title = [dict objectForKey:@"title"];
    }
    
    
    if ([dict objectForKey:@"imgUrl"] != [NSNull null]) {
        self.imgUrl = [dict objectForKey:@"imgUrl"];
    }
    
    if ([dict objectForKey:@"id"] != [NSNull null]) {
        self.mId = [[dict objectForKey:@"id"] integerValue];
    }

    if ([dict objectForKey:@"topNImgs"] != [NSNull null]) {
        self.topNImgs = [dict objectForKey:@"topNImgs"];
    }
    
    return self;
}

@end
