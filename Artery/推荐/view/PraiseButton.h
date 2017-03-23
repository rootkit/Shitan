//
//  PraiseButton.h
//  Shitan
//
//  Created by Richard Liu on 15/6/29.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PraiseButton : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isPrais;

- (instancetype)initWithFrame:(CGRect)frame;



@end
