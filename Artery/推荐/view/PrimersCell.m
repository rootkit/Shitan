//
//  PrimersCell.m
//  Shitan
//
//  Created by Richard Liu on 15/8/28.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PrimersCell.h"

@implementation PrimersCell


+ (PrimersCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PrimersCell";
    
    PrimersCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PrimersCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    PrimersView *pView = [[PrimersView alloc] init];
    _pView = pView;
    
    [self.contentView addSubview:_pView];
}

- (void)setPrimersModelFrame:(PrimersModelFrame *)primersModelFrame
{
    _primersModelFrame = primersModelFrame;
    
    self.pView.primersModelFrame = _primersModelFrame;
}


@end
