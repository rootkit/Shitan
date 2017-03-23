//
//  DPAPI.m
//  Shitan
//
//  Created by 刘敏 on 15/5/21.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "DPAPI.h"
#import "MD5Hash.h"

static DPAPI * _dpInfo = nil;

@interface DPAPI (PrivateMethods)

@end

@implementation DPAPI

+ (DPAPI *)sharedDPAPI{
	@synchronized(self){
		if (!_dpInfo) {
			_dpInfo = [[DPAPI alloc] init];
		}
	}
	
	return _dpInfo;
}


//基础url+字典
- (void)requestWithURL:(NSString *)url
					  params:(NSMutableDictionary *)params{
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    //URL已经是拼全
    self.urlString  = [[self class] serializeURL:url params:params];
}


//基础url+string
- (void)requestWithURL:(NSString *)url
                paramsString:(NSString *)paramsString{
    [self requestWithURL:[NSString stringWithFormat:@"%@?%@", url, paramsString] params:nil];
}


+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params
{
    
    if (!params) {
		return nil;
	}
    
    CLog(@"%@", params);
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
	NSURL* parsedURL = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [paramsDic setDictionary:[self parseQueryString:[parsedURL query]]];

    
	if (params) {
		[paramsDic setValuesForKeysWithDictionary:params];
	}
	
	NSMutableString *signString = [NSMutableString stringWithString:K_DP_APP_KEY];
	NSMutableString *paramsString = [NSMutableString stringWithFormat:@"appkey=%@", K_DP_APP_KEY];
	NSArray *sortedKeys = [[paramsDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
	for (NSString *key in sortedKeys) {
		[signString appendFormat:@"%@%@", key, [paramsDic objectForKey:key]];
		[paramsString appendFormat:@"&%@=%@", key, [paramsDic objectForKey:key]];
	}
    
	[signString appendString:K_DP_APPSECRET];
    
    NSString *sign = [MD5Hash getDZDPSha1String:signString];
    
    [paramsString appendFormat:@"&sign=%@", [sign uppercaseString]];
    
    CLog(@"%@",paramsString);
    
    CLog(@"%@",[NSString stringWithFormat:@"%@://%@%@?%@", [parsedURL scheme], [parsedURL host], [parsedURL path], [paramsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]);
    
    
    return  [NSString stringWithFormat:@"%@://%@%@?%@", [parsedURL scheme], [parsedURL host], [parsedURL path], [paramsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

}


+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
		
		if ([elements count] <= 1) {
			return nil;
		}
		
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}



- (void)setUrlString:(NSString *)stURL
{
    if (_urlString != stURL) {
        _urlString = stURL;
    }
}




@end
