//
//  StoryBoardUtilities.m
//  Shitan
//
//  Created by Richard Liu on 15/4/22.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "StoryBoardUtilities.h"

@implementation StoryBoardUtilities

+ (UIViewController*)viewControllerForStoryboardName:(NSString*)storyboardName class:(id)classA
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    NSString* className = nil;
    
    if ([classA isKindOfClass:[NSString class]])
        className = [NSString stringWithFormat:@"%@", classA];
    else
        className = [NSString stringWithFormat:@"%s", class_getName([classA class])];
    
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@", className]];
    return viewController;
}


@end
