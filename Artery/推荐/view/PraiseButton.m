//
//  PraiseButton.m
//  Shitan
//
//  Created by Richard Liu on 15/6/29.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//  宽80， 高60

#import "PraiseButton.h"

@interface PraiseButton ()

@property (nonatomic, weak) UIImageView *btnImageV;
@property (nonatomic, weak) UILabel *desL;

@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation PraiseButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        
        UIImageView *btnImageV = [[UIImageView alloc] initWithFrame:CGRectMake(32, 16, 15, 13)];
        _btnImageV = btnImageV;
        [self addSubview:_btnImageV];
       
        UILabel *desL = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 80, 20)];
        _desL = desL;
        [_desL setBackgroundColor:[UIColor clearColor]];
        _desL.textColor = [UIColor whiteColor];
        _desL.font = [UIFont systemFontOfSize:14.0];
        _desL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_desL];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    _desL.text = title;
}

- (void)setIsPrais:(BOOL)isPrais
{
    _isPrais = isPrais;
    if (_isPrais) {
        [_btnImageV setImage:[UIImage imageNamed:@"button_have_heart"]];
    }
    else
        [_btnImageV setImage:[UIImage imageNamed:@"button_no_heart"]];
}



@end
