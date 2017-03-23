//
//  CollectionCell.h
//  Shitan
//
//  Created by 刘敏 on 14-11-3.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavInfo.h"


@interface CollectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headV;        //头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;     //名字

// 赋值
- (void)setCellWithCellInfo:(FavInfo *)fInfo;


@end
