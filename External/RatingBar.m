//
//  RatingBar.m
//  MyRatingBar
//
//  Created by Leaf on 14-8-28.
//  Copyright (c) 2014年 Leaf. All rights reserved.
//

#import "RatingBar.h"

#define ZOOM 0.8f


@interface RatingBar()

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,assign) CGFloat starWidth;
@end

@implementation RatingBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.bottomView = [[UIView alloc] initWithFrame:self.bounds];
        self.topView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:self.bottomView];
        [self addSubview:self.topView];
        
        self.topView.clipsToBounds = YES;
        self.topView.userInteractionEnabled = NO;
        self.bottomView.userInteractionEnabled = NO;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:pan];
        
        //图片的宽度
        CGFloat width = 26;
        self.starWidth = width;
        for(int i = 0; i<5; i++){
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 22)];
            img.center = CGPointMake((i+1.5)*width, frame.size.height/2);
            img.image = [UIImage imageNamed:@"icon_score"];
            [self.bottomView addSubview:img];
            UIImageView *img2 = [[UIImageView alloc] initWithFrame:img.frame];
            img2.center = img.center;
            img2.image = [UIImage imageNamed:@"icon_score_selected"];
            [self.topView addSubview:img2];
        }
        self.enable = YES;
        
    }
    return self;
}


//设置View的颜色
- (void)setViewColor:(UIColor *)backgroundColor{
    if(_viewColor!=backgroundColor){
        self.backgroundColor = backgroundColor;
        self.topView.backgroundColor = backgroundColor;
        self.bottomView.backgroundColor = backgroundColor;
    }
}


//设置初始星星的个数
- (void)setStarNumber:(NSInteger)starNumber{
    if(_starNumber!= starNumber){
        _starNumber = starNumber;
        self.topView.frame = CGRectMake(0, 0, self.starWidth*(starNumber+1), self.bounds.size.height);
    }
}



- (void)tap:(UITapGestureRecognizer *)gesture{
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (int)(point.x/self.starWidth)+1;
        self.topView.frame = CGRectMake(0, 0, self.starWidth*count, self.bounds.size.height);
        
        if(count > 5){
            _starNumber = 5;
        }else{
            _starNumber = count-1;
        }
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(ratingBarWithStarNumber:)]) {
            [_delegate ratingBarWithStarNumber:_starNumber];
        }
    }
}



- (void)pan:(UIPanGestureRecognizer *)gesture{
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (int)(point.x/self.starWidth);
        
        if(count>=0 && count<=5 && _starNumber!=count){
            self.topView.frame = CGRectMake(0, 0, self.starWidth*(count+1), self.bounds.size.height);
            _starNumber = count;
            
            if (_delegate && [_delegate respondsToSelector:@selector(ratingBarWithStarNumber:)]) {
                [_delegate ratingBarWithStarNumber:_starNumber];
            }
        }
    }
}

@end
