//
//  MarkPlistOperation.h
//  Artery
//
//  Created by RichardLiu on 15/3/26.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkPlistOperation : NSObject

+ (NSArray *)readPlist;

+ (void)writePlist:(NSDictionary *)mark;

@end
