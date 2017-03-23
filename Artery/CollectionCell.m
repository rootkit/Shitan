//
//  CollectionCell.m
//  Shitan
//
//  Created by 刘敏 on 14-11-3.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation CollectionCell

- (void)awakeFromNib
{
    // Initialization code
}

// 赋值
- (void)setCellWithCellInfo:(FavInfo *)fInfo
{
    
    if (fInfo.favoriteId) {
        if(fInfo.imgUrl)
        {
            [_headV sd_setImageWithURL:[NSURL URLWithString:fInfo.imgUrl] placeholderImage:[UIImage imageNamed:@"head_default.png"]];
        }
        else
            [_headV setBackgroundColor:MINE_FAVORITE_BACKGROUND_COLOR];
    }else{
        [_headV setImage:[UIImage imageNamed:@"bg_favorite_cell_create.png"]];
    }

    [_nameLabel setText:fInfo.title];
    
    [_headV.layer setCornerRadius:4];
    _headV.layer.masksToBounds = YES;
}



@end
