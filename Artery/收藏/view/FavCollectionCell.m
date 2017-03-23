//
//  FavCollectionCell.m
//  Shitan
//
//  Created by 刘敏 on 14/11/29.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FavCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation FavCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FavCollectionCell" owner:self options: nil];
        
        if(arrayOfViews.count < 1){return nil;}
        
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
                
        [self initView];
    }
    return self;
}



- (void)initView{
    
    //图片圆角
    self.backgroundColor = MINE_FAVORITE_BACKGROUND_COLOR;
    
    _largerIamgeWidth.constant = (MAINSCREEN.size.width-36)/2 - 8;
    
    _smallIMageHigth.constant = _smallIMageWidth.constant = (_largerIamgeWidth.constant-8.0)/3.0;
    
    [self.layer setCornerRadius:4];
    self.layer.masksToBounds = YES;
    
    [_favoritePic1.layer setCornerRadius:4];
    _favoritePic1.layer.masksToBounds = YES;
    [_favoritePic2.layer setCornerRadius:4];
    _favoritePic2.layer.masksToBounds = YES;
    [_favoritePic3.layer setCornerRadius:4];
    _favoritePic3.layer.masksToBounds = YES;
    [_favoritePic4.layer setCornerRadius:4];
    _favoritePic4.layer.masksToBounds = YES;
    
    //设置背景色
    _favoritePic1.backgroundColor = MINE_FAVORITE_BACKGROUND1_COLOR;
    _favoritePic2.backgroundColor = MINE_FAVORITE_BACKGROUND1_COLOR;
    _favoritePic3.backgroundColor = MINE_FAVORITE_BACKGROUND1_COLOR;
    _favoritePic4.backgroundColor = MINE_FAVORITE_BACKGROUND1_COLOR;
    
    _favoritePic1.image = [UIImage imageNamed:@"mine_fav.png"];
    _favoritePic2.image = [UIImage imageNamed:@"mine_fav.png"];
    _favoritePic3.image = [UIImage imageNamed:@"mine_fav.png"];
    _favoritePic4.image = [UIImage imageNamed:@"mine_fav.png"];
    
    _favoritePic1.tag = 1000;
    _favoritePic2.tag = 1001;
    _favoritePic3.tag = 1002;
    _favoritePic4.tag = 1003;
}

//解析数据
- (void)initWithParsData:(FavInfo *)fInfo
{
    
    [self initView];
    
    _favoriteTitleLabel.text = fInfo.title;
    
    NSArray *topNImgs = fInfo.topNImgs;
    
    int i = 1000;
    
    for (NSDictionary *item in topNImgs) {
        UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[item objectForKey:@"imgUrl"]]];
        i ++ ;
    }
}


@end
