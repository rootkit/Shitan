//
//  ResultImagesModel.h
//  Shitan
//
//  Created by RichardLiu on 15/3/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultsImageTableViewCell.h"


@interface ResultImagesModel : NSObject

+ (ResultsImageTableViewCell *)findCellWithTableView:(UITableView *)tableView;

@end
