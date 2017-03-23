//
//  BannerInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/4/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "BannerInfo.h"

@implementation BannerInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    
    self.specialId = [dict objectForKeyNotNull:@"specialId"];
    self.coverImgUrl = [dict objectForKeyNotNull:@"coverImgUrl"];
    self.topImgUrl = [dict objectForKeyNotNull:@"topImgUrl"];
    self.specialType = [[dict objectForKeyNotNull:@"specialType"] integerValue];
    self.sort = [[dict objectForKeyNotNull:@"sort"] integerValue];
    self.showCount = [[dict objectForKeyNotNull:@"showCount"] integerValue];

    self.beginTime = [dict objectForKeyNotNull:@"beginTime"];
    self.endTime = [dict objectForKeyNotNull:@"endTime"];
    self.cityId = [dict objectForKeyNotNull:@"cityId"];
    
    self.state = [[dict objectForKeyNotNull:@"state"] integerValue];
    self.title = [dict objectForKeyNotNull:@"title"];
    self.des  = [dict objectForKeyNotNull:@"description"];

    self.h5Url = [dict objectForKeyNotNull:@"h5Url"];
    self.successCount = [[dict objectForKeyNotNull:@"successCount"] integerValue];
    self.commentCount = [[dict objectForKeyNotNull:@"commentCount"] integerValue];
    
    
    self.bannerImgUrl = [dict objectForKeyNotNull:@"bannerImgUrl"];
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    self.updateTime = [dict objectForKeyNotNull:@"updateTime"];
    self.leftTime = [[dict objectForKeyNotNull:@"leftTime"] integerValue];

    
    self.mid = [[dict objectForKeyNotNull:@"id"] integerValue];
    self.isBanner = [[dict objectForKeyNotNull:@"isBanner"] boolValue];
    self.maxApply = [[dict objectForKeyNotNull:@"maxApply"] integerValue];
    self.applyCount = [[dict objectForKeyNotNull:@"applyCount"] integerValue];
    

    self.shareTitle = [dict objectForKeyNotNull:@"shareTitle"];
    self.shareImgUrl = [dict objectForKeyNotNull:@"shareImgUrl"];
    self.shareDesc = [dict objectForKeyNotNull:@"shareDesc"];
    self.mTag = [dict objectForKeyNotNull:@"tag"];                      //专题标签

    
    return self;
    
}

@end
