//
//  FavInfo.h
//  Shitan
//
//  Created by 刘敏 on 14-11-3.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavInfo : NSObject

@property (weak, nonatomic) NSString *favoriteDesc;         //收藏夹描述
@property (weak, nonatomic) NSString *favoriteId;           //收藏夹ID
@property (weak, nonatomic) NSArray *topNImgs;              //顶部大图
@property (weak, nonatomic) NSString *imgId;                //图片ID
@property (weak, nonatomic) NSString *imgUrl;               //图片url
@property (weak, nonatomic) NSString *title;                //收藏夹标题

@property (assign, nonatomic) NSInteger mId;


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
