//
//  StoryBoardUtilities.h
//  Shitan
//
//  Created by Richard Liu on 15/4/22.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface StoryBoardUtilities : NSObject

+ (UIViewController*)viewControllerForStoryboardName:(NSString*)storyboardName class:(id)classA;

@end
