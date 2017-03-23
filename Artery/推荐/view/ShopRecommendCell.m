//
//  ShopRecommendCell.m
//  Shitan
//
//  Created by Richard Liu on 15/6/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ShopRecommendCell.h"

@implementation ShopRecommendCell

+ (ShopRecommendCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopRecommendCell";
    
    ShopRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ShopRecommendCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView {
    
    //标题、文字
    ShopMiddleContentsView *bottomView = [[ShopMiddleContentsView alloc] init];
    self.bottomView = bottomView;
    [self.contentView addSubview:self.bottomView];
    
    //图片
    ShopMiddleScrollView *scrollView = [[ShopMiddleScrollView alloc] init];
    self.scrollView = scrollView;
    [self.contentView addSubview:self.scrollView];
}


- (void)setRecommendModelFrame:(RecommendModelFrame *)recommendModelFrame
{
    _recommendModelFrame = recommendModelFrame;
    
    self.bottomView.recommendModelFrame = _recommendModelFrame;
    self.bottomView.frame = _recommendModelFrame.bottomViewFrame;
    
    self.scrollView.recommendModelFrame = _recommendModelFrame;
    self.scrollView.frame = _recommendModelFrame.scrollViewFrame;

}


@end
