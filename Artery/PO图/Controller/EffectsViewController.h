//
//  EffectsViewController.h
//  Artery
//
//  Created by 刘敏 on 14-10-5.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "DMBaseViewController.h"

@interface EffectsViewController : DMBaseViewController

@property (strong, nonatomic) UIImage *cacheImage;
@property (weak, nonatomic) IBOutlet UIButton *effButton;

@property (strong, nonatomic) UIScrollView *fitScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHight;


@end
