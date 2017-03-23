//
//  DynamicModelCell.m
//  Shitan
//
//  Created by Avalon on 15/4/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "DynamicModelCell.h"

@implementation DynamicModelCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"DynamicModel";
    
    DynamicModelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
       cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpDynamicView];
        self.contentView.userInteractionEnabled = YES;
        
    }
    
    return self;
}

- (void)setUpDynamicView{
    DynamicHeadView *headView = [[DynamicHeadView alloc] init];
    self.headView = headView;
    self.headView.dynamicModelFrame = self.dynamicModelFrame;
    [self.contentView addSubview:self.headView];
    
    DynamicContentsView *contentsView = [[DynamicContentsView alloc] init];
    self.contentsView = contentsView;
    [self.contentView addSubview:self.contentsView];
    
    DynamicBottomView *bottomView = [[DynamicBottomView alloc] init];
    self.bottomView = bottomView;
     [self.contentView addSubview:self.bottomView];

     DynamicToolsbarView *toolsbarView = [[DynamicToolsbarView alloc] init];
     self.toolsbarView = toolsbarView;
     [self.contentView addSubview:self.toolsbarView];
}


#pragma mark - 把模型中得frame赋给view
- (void)setDynamicModelFrame:(DynamicModelFrame *)dynamicModelFrame{
    
    _dynamicModelFrame = dynamicModelFrame;
    
    self.headView.dynamicModelFrame = _dynamicModelFrame;
    self.headView.frame = _dynamicModelFrame.headViewFrame;

    self.contentsView.dynamicModelFrame = _dynamicModelFrame;
    self.contentsView.frame = _dynamicModelFrame.contenViewFrame;
    
    self.bottomView.dynamicModelFrame = _dynamicModelFrame;
    self.bottomView.frame = _dynamicModelFrame.bottomViewFrame;
    
    self.toolsbarView.dynamicModelFrame = _dynamicModelFrame;
    self.toolsbarView.frame = _dynamicModelFrame.toolsFrame;
}

- (void)setLineNO:(NSUInteger)lineNO
{
    _lineNO = lineNO;
    self.toolsbarView.lineNO = lineNO;
    self.bottomView.lineNO = lineNO;
}

@end
