//
//  DPAPI.h
//  Shitan
//
//  Created by 刘敏 on 15/5/21.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPAPI : NSObject

@property (nonatomic, strong) NSString *urlString;


+ (DPAPI *)sharedDPAPI;

//基础url+字典
- (void)requestWithURL:(NSString *)url
					  params:(NSMutableDictionary *)params;

//基础url+string
- (void)requestWithURL:(NSString *)url
				 paramsString:(NSString *)paramsString;

+ (NSDictionary *)parseQueryString:(NSString *)query;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;

@end
