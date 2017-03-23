//
//  NewFavCollectionCell.m
//  Shitan
//
//  Created by Jia HongCHI on 14-10-5.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "NewFavCollectionCell.h"

@implementation NewFavCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NewFavCollectionCell" owner:self options: nil];
        
        if(arrayOfViews.count < 1){return nil;}
        
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        
        
        self = [arrayOfViews objectAtIndex:0];
        
        
        //图片圆角
        [self.layer setCornerRadius:4];
        self.layer.masksToBounds = YES;
        self.backgroundColor = MINE_FAVORITE_BACKGROUND_COLOR;
        
    }
    return self;
}

@end
