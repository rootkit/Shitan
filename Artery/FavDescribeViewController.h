//
//  FavDescribeViewController.h
//  Shitan
//
//  Created by 刘敏 on 14/12/16.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavInfo.h"


@protocol FavDescribeViewControllerDelegate;

@interface FavDescribeViewController : STChildViewController

@property (nonatomic, weak) id<FavDescribeViewControllerDelegate>delegate;
//编辑框
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) FavInfo* favInfo;

@end


@protocol FavDescribeViewControllerDelegate <NSObject>

- (void)updateFavDescribe:(NSString *)describe;

@end
