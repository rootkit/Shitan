//
//  ResultDetailsCell.m
//  Artery
//
//  Created by Avalon on 15/4/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ResultDetailsCell.h"

@implementation ResultDetailsCell


+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"detailsCell";
    
    ResultDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ResultDetailsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
    
    
}



@end
