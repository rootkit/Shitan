//
//  STRate.h
//  Shitan
//
//  Created by Richard Liu on 15/4/24.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STRate : NSObject
{
    NSUInteger numberOfExecutions;
}

+ (void)loadRate;

+ (NSUInteger)numberOfExecutions;

- (id)initWithNumberOfExecutions:(NSUInteger) executionCount;



@end
