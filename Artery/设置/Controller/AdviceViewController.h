//
//  AdviceViewController.h
//  Shitan
//
//  Created by 刘敏 on 15/1/20.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdviceViewControllerDelegate;


@interface AdviceViewController : STChildViewController

@property (nonatomic, weak) id<AdviceViewControllerDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, assign) BOOL isNote;



@end


@protocol AdviceViewControllerDelegate <NSObject>

- (void)updateNote:(NSString *)note;

@end
