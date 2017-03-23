//
//  MD5Hash.h
//  CashBox
//
//  Created by 刘敏 on 12-9-7.
//  Copyright (c) 2012年 刘敏. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface MD5Hash : NSObject

//16位MD5加密方式
+ (NSString *)getMd5_16Bit_String:(NSString *)srcString;

//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;

//sha加密（大众点评）
+ (NSString *)getDZDPSha1String:(NSString *)srcString;

//sha1加密方式
+ (NSString *)getSha1String:(NSString *)srcString;

//sha256加密方式
+ (NSString *)getSha256String:(NSString *)srcString;

//sha384加密方式
+ (NSString *)getSha384String:(NSString *)srcString;

//sha512加密方式
+ (NSString*) getSha512String:(NSString*)srcString;


@end
