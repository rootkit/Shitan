//
//  ShopToolCell.m
//  Shitan
//
//  Created by Richard Liu on 15/8/29.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ShopToolCell.h"

@implementation ShopToolCell

+ (ShopToolCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopToolCell";
    
    ShopToolCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ShopToolCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //设置顶部
    ShopToolView *headView = [[ShopToolView alloc] init];
    self.headView = headView;
    [self.contentView addSubview:self.headView];
}



#pragma mark - 把模型中得frame赋给view
- (void)setToolFrame:(ToolModelFrame *)toolFrame{
    _toolFrame = toolFrame;
    self.headView.headFrame = _toolFrame;
    self.headView.frame = _toolFrame.toolsFrame;
    
}

@end
