//
//  AboutViewController.h
//  Shitan
//
//  Created by 刘敏 on 14/12/3.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : STChildViewController

@property (nonatomic, weak) IBOutlet UILabel *versionLabel;

- (IBAction)checkNewVersion:(id)sender;

@end
