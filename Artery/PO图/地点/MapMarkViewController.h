//
//  MapMarkViewController.h
//  Artery
//
//  Created by RichardLiu on 15/3/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TencentPostion.h"
#import "TencentMapInfo.h"

@protocol MapMarkViewControllerDelegate;

@interface MapMarkViewController : STChildViewController

@property (nonatomic, weak) id<MapMarkViewControllerDelegate> delegate;

@end


@protocol MapMarkViewControllerDelegate <NSObject>

- (void)selectedMapMarkWithInfo:(TencentPostion *)pInfo otherInfo:(TencentMapInfo *)oInfo;


@end