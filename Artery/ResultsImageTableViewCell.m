//
//  ResultsImageTableViewCell.m
//  Shitan
//
//  Created by RichardLiu on 15/3/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ResultsImageTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ItemInfo.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "HCSStarRatingView.h"

#define Interval_Width   16


@interface ResultsImageTableViewCell ()
@property (nonatomic, strong) NSArray *mArray;

@property (strong, nonatomic) HCSStarRatingView *starbBar;     //评分
@property (strong, nonatomic) UILabel *staeLabel;      //分数

@end

@implementation ResultsImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = BACKGROUND_COLOR;
    
    _titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 40)];
    _titLabel.text = @"本店美食";
    _titLabel.backgroundColor = [UIColor whiteColor];
    [_titLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    _titLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titLabel];


}

- (void)setCellWithCellInfo:(NSArray *)array isHideHead:(BOOL)isHide
{
    _mArray = array;
    
    NSUInteger mx = _mArray.count/2;
    NSUInteger my = _mArray.count%2;
    
    //单个图片宽度
    CGFloat singleW = (MAINSCREEN.size.width -Interval_Width*3)/2;
    //总高度
    CGFloat s_high= (singleW+Interval_Width) *(mx + my) + Interval_Width;
    
    if (isHide) {
        _coView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, s_high)];
        [_titLabel setHidden:YES];
    }
    else{
        _coView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, MAINSCREEN.size.width, s_high)];
    }


    NSUInteger key = 0;
    for (ItemInfo *item in array) {
        
        NSUInteger nx = key/2;
        NSUInteger ny = key%2;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setFrame:CGRectMake(Interval_Width + (singleW + Interval_Width)*ny, Interval_Width + (singleW + Interval_Width)*nx, singleW, singleW)];
        
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[Units foodImage480Thumbnails:item.nameImgUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_image.png"]];
        [btn setTag:key];
        
        btn.layer.cornerRadius = 3;//设置那个圆角的有多圆
        btn.layer.masksToBounds = YES;//设为NO去试试
        
        [btn addTarget:self action:@selector(btnImageTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_coView addSubview:btn];
        
        //底部文字说明
        UIView *blackV = [[UIView alloc] initWithFrame:CGRectMake(0, singleW-50, singleW, 50)];
        [blackV setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
        [btn addSubview:blackV];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, singleW-10, 30)];
        nameLabel.text = item.name;
        nameLabel.font = [UIFont systemFontOfSize:14.0];
        nameLabel.textColor = [UIColor whiteColor];
        [blackV addSubview:nameLabel];

        _starbBar = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 15, 90, 40)];
        _starbBar.maximumValue = 5;
        _starbBar.minimumValue = 0;
        _starbBar.tintColor = [UIColor whiteColor];
        _starbBar.backgroundColor = [UIColor clearColor];
        _starbBar.enabled = NO;
        [blackV addSubview:_starbBar];
        
        _staeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_starbBar.frame) + 10, 21, singleW - 10, 30)];
        [_staeLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_staeLabel setTextColor:[UIColor whiteColor]];
        //_staeLabel.text = item.score;
        [blackV addSubview:_staeLabel];
        
        _starbBar.value = item.score;
        if(item.score == 0)
        {
            [_starbBar setFrame:CGRectMake(MAINSCREEN.size.width-170, 60+MAINSCREEN.size.width+10, 100, 20)];
            [_staeLabel setFrame:CGRectMake(MAINSCREEN.size.width-60, 60+MAINSCREEN.size.width+10, 50, 20)];
            _staeLabel.text = @"未评分";
        }
        else
            [_staeLabel setText:[NSString stringWithFormat:@"%.1f分", (CGFloat)item.score]];

        key++;
        
        //评分
        
    }

    [self.contentView addSubview:_coView];

}


- (void)setController:(ResultDetailsViewController *)controller{
    _controller = controller;
}

- (void)setItemController:(ResultItemViewController *)itemController
{
    _itemController = itemController;
}


- (void)btnImageTapped:(UIButton *)sender
{
    ItemInfo *item = [_mArray objectAtIndex:sender.tag];
    if (_controller) {
        [_controller imageBtnTapped:item];
    }
    
    if (_itemController) {
        [_itemController imageBtnTapped:item];
    }
    
}




@end
