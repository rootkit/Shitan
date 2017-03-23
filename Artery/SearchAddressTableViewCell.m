//
//  SearchAddressTableViewCell.m
//  Shitan
//
//  Created by RichardLiu on 15/2/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "SearchAddressTableViewCell.h"
#import "ItemInfo.h"
#import "ShopInfo.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation SearchAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, MAINSCREEN.size.width, 152)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_scrollView];
    
    UIImageView *posV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 35, 20, 20)];
    
    [posV setImage:[UIImage imageNamed:@"imported_layers.png"]];
    [self.contentView addSubview:posV];
    

    
    
}


- (void)setCellWithCellInfo:(CompositeInfo *)cInfo
{
    
    self.sInfo = cInfo.sInfo;
    CLog(@"%@",cInfo.sInfo);
    
    self.addressName = [[UILabel alloc] init];
    [self.addressName setFont:[UIFont boldSystemFontOfSize:15.0]];
    [self.contentView addSubview:self.addressName];
    
    if (cInfo.sInfo.addressName && cInfo.sInfo.branchName.length > 1) {
        self.addressName.text = [NSString stringWithFormat:@"%@（%@）", cInfo.sInfo.addressName, cInfo.sInfo.branchName];
    }
    else{
        self.addressName.text = cInfo.sInfo.addressName;
    }
    
    //距离
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.distanceLabel.textColor = [UIColor grayColor];
    
    self.distanceLabel.text = [Units getDistanceByLatitude:cInfo.sInfo.distance];
    self.distanceLabel.backgroundColor = [UIColor clearColor];
    self.distanceLabel.font = [UIFont systemFontOfSize:13.0];
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.distanceLabel];
    
    
    //详细地址
    _addressDetail = [UILabel new];
    _addressDetail.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_addressDetail];
    
    _addressDetail.text = cInfo.sInfo.address;
    _addressDetail.font = [UIFont systemFontOfSize:13.0];
    
    CGSize size = [_addressDetail boundingRectWithSize:CGSizeMake(MAINSCREEN.size.width-95, 0)];
    _addressDetail.numberOfLines = 0;
    
    CLog(@"高度：%f", size.height);
    
    if (size.height > 20) {
        _distanceLabel.frame = CGRectMake(MAINSCREEN.size.width-80, 31, 68, 21);
       _addressDetail.frame = CGRectMake(34, 33, size.width, size.height);
    }
    else{
        _distanceLabel.frame = CGRectMake(MAINSCREEN.size.width-80, 36, 68, 21);
        _addressDetail.frame = CGRectMake(34, 38, size.width, size.height);
    }
    
    _addressDetail.textColor = [UIColor grayColor];
    
    _sInfo = cInfo.sInfo;
    
    [self initImage:cInfo.nameTagExts];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 70, MAINSCREEN.size.width, 0.5)];
    [self addSubview:lineView];
    lineView.backgroundColor = BACKGROUND_COLOR;
    
}


- (void)initImage:(NSArray *)array
{
    _imageArray = array;
    
    NSUInteger key = 0;
    
    
    
    _scrollView.contentSize = CGSizeMake(15+165*array.count, 152);
    
    for (ItemInfo *item in array) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(15+165*key, 1, 150, 150)];
        
        btn.layer.cornerRadius = 6;//设置那个圆角的有多圆
        btn.layer.masksToBounds = YES;//设为NO去试试
        
        CLog(@"%@", [Units foodImage480Thumbnails:item.nameImgUrl]);
        
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[Units foodImage480Thumbnails:item.nameImgUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_image.png"]];
        [btn setTag:key];
        
        [btn addTarget:self action:@selector(btnImageTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        
        //底部文字说明
        UIView *blackV = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 150, 30)];
        [blackV setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
        [btn addSubview:blackV];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 140, 30)];
        nameLabel.text = item.name;
        nameLabel.font = [UIFont systemFontOfSize:13.0];
        nameLabel.textColor = [UIColor whiteColor];
        [blackV addSubview:nameLabel];

        key++;
    }
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    [self.addressName sizeToFit];
    self.addressName.frame = CGRectMake(15, 9, self.addressName.frame.size.width, self.addressName.frame.size.height);
    
    UIImageView *dealV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grouponicon_icon"]];
    [self.contentView addSubview:dealV];
    [dealV sizeToFit];
    if (self.sInfo.dealFlag == 2) {
        dealV.frame = CGRectMake(CGRectGetMaxX(self.addressName.frame) + 6, 11, 15, 15);
    }
    else{
        dealV.frame = CGRectZero;
    }
    dealV.layer.cornerRadius = 2;//设置那个圆角的有多圆
    dealV.layer.masksToBounds = YES;//设为NO去试试
    
}

//- (void)btnImageTapped:(UIButton *)sender
//{
//    ItemInfo *item = [_imageArray objectAtIndex:sender.tag];
//    [_controller imageBtnTapped:_sInfo itemWithInfo:item];
//}

//
//- (void)setController:(SearchSTViewController *)controller{
//    _controller = controller;
//}


@end
