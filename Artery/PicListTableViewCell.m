//
//  PicListTableViewCell.m
//  Shitan
//
//  Created by Jia HongCHI on 14/12/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PicListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation PicListTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.contentView.userInteractionEnabled = YES;
}

- (void)initWithParsData:(NSArray *)imgArray intWithSection:(NSInteger)section{
    
    [self.contentView setBackgroundColor:MINE_FAVORITE_BACKGROUND_COLOR];
    for (int i = 0; i < imgArray.count; i++) {
        NSDictionary *dic = [imgArray objectAtIndex:i];
        DynamicInfo *dInfo = [[DynamicInfo alloc] initWithParsData:dic];
        UIImageView *picImageview = [[UIImageView alloc] init];
        
        [picImageview sd_setImageWithURL:[NSURL URLWithString:[Units foodImage320Thumbnails:dInfo.imgUrl]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
        NSInteger x = i/3;
        NSInteger y = i%3;
        
        
        CGFloat imageWidth = (MAINSCREEN.size.width-50.0)/3.0;
        
        picImageview.frame = CGRectMake(10 + (y*(imageWidth+5.0)), 10 + (x*(imageWidth+5.0)), imageWidth, imageWidth);
        
        
        
        picImageview.tag = section*10000 +i;
                
        /********************************    单击手势    ***********************************/
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageViewTapped:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        
        //开启触摸事件响应
        [picImageview addGestureRecognizer:tapGesture];
        
        /**********************************************************/
        picImageview.userInteractionEnabled = YES;
        
        [self.contentView addSubview:picImageview];
    }
}



- (void)clickImageViewTapped:(UITapGestureRecognizer *)sender
{
    NSInteger section = sender.view.tag/10000;
    NSInteger row = sender.view.tag%10000;
    
    if (_delegate &&  [_delegate respondsToSelector:@selector(clickImageViewTappedWithSection:withRow:)]) {
        
        [_delegate clickImageViewTappedWithSection:section withRow:row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
