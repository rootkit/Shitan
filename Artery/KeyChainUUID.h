//
//  KeyChainUUID.h
//  KeyChainUDID
//
//  Created by Emck on 8/17/13.
//  Copyright (c) 2013 Apptem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainUUID : NSObject

// 获取UUID
+ (NSString*)Value;

// 删除UUID
+ (void)Renew;

@end