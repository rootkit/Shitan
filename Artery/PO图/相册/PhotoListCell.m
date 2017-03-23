//
//  PhotoListCell.m
//  Artery
//
//  Created by RichardLiu on 15/4/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "PhotoListCell.h"

@implementation PhotoListCell

- (void)awakeFromNib {
    // Initialization code
}


// 赋值
- (void)setCellWithCellInfo:(ALAssetsGroup *)group
{
    [self.imageV setImage:[UIImage imageWithCGImage:group.posterImage]];
    
    __block NSUInteger num = 0;
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            if ([type isEqualToString:@"ALAssetTypePhoto"]) {
                num++;
            }
        }
    }];

    NSString *tit = [NSString stringWithFormat:@"%@（%lu）", [group valueForProperty:ALAssetsGroupPropertyName], (unsigned long)num];
    [self.titLabel setText:tit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
