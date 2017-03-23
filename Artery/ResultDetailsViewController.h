//
//  ResultDetailsViewController.h
//  Shitan
//
//  Created by RichardLiu on 15/3/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STChildViewController.h"
#import "ShopInfo.h"
#import "ItemInfo.h"


@interface ResultDetailsViewController : STChildViewController

@property (nonatomic, strong) ShopInfo *sInfo;

- (void)imageBtnTapped:(ItemInfo *)tInfo;

@end
