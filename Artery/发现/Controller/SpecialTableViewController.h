//
//  SpecialTableViewController.h
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//  专题

#import "STBaseHomeTableViewController.h"
#import "FoundViewController.h"

@interface SpecialTableViewController : STBaseHomeTableViewController

@property (nonatomic, weak) FoundViewController *twitterVC;

// 获取精选
- (void)requestEssenceImagesList;


@end
