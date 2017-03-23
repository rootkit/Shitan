//
//  ScreenCell.m
//  Shitan
//
//  Created by Richard Liu on 15/8/13.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ScreenCell.h"
#import <SDWebImage/UIButton+WebCache.h>

#define ICON_H   70.0
#define kImageMargin        15.0f

@interface ScreenCell ()

@property (nonatomic, weak) UILabel *nameL;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) ClassInfo *tInfo;                 //存储cell的临时数据

@end

@implementation ScreenCell

+ (ScreenCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ScreenCell";
    
    ScreenCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[ScreenCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setUpChildView
{
    //大标题
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    _nameL = nameL;
    [_nameL setFont:[UIFont boldSystemFontOfSize:15.0]];
    [self.contentView addSubview:_nameL];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, MAINSCREEN.size.width, 95)];
    _scrollView = scrollView;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
}

- (void)setCellWithCellInfo:(ClassInfo *)mInfo
{
    _tInfo = mInfo;
    
    [_nameL setText:mInfo.cName];
    
    if (mInfo.classArray.count > 0) {
        _scrollView.contentSize = CGSizeMake(kImageMargin + (ICON_H + kImageMargin*2) * mInfo.classArray.count, 95);
        NSUInteger key = 0;
        
        for (ClassInfo *iten in mInfo.classArray) {
            UIButton *mV = [[UIButton alloc] initWithFrame:CGRectMake(kImageMargin + (ICON_H + kImageMargin) * key , 20, ICON_H, ICON_H)];
            mV.tag = 1000+key;
            mV.contentMode = UIViewContentModeScaleAspectFill;
            [mV setTitle:iten.cName forState:UIControlStateNormal];
            [mV.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
            [mV addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];

            [mV setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [mV setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
            //圆角
            mV.layer.cornerRadius = ICON_H/2; //设置那个圆角的有多圆
            mV.layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
            mV.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
            mV.layer.masksToBounds = YES;  //设为NO去试试

            [_scrollView addSubview:mV];
            
            key++;
        }
    }
}


- (void)btnTapped:(UIButton *)sender
{
    NSUInteger row = sender.tag - 1000;
    ClassInfo *mInfo = [_tInfo.classArray objectAtIndex:row];
    
    if (_delegate) {
        [_delegate seletedBtnWithKeyword:mInfo];
    }
}


@end
