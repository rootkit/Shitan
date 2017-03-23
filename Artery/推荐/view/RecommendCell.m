//
//  RecommendCell.m
//  Shitan
//
//  Created by Richard Liu on 15/6/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RecommendCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageProgressView.h"
#import "ImageLoadingView.h"
#import "CollectionDAO.h"

@interface RecommendCell ()

@property (nonatomic, strong) CollectionDAO *favoriteDao;
@property (nonatomic, weak) UIImageView *picV;
@property (nonatomic, weak) UILabel *titL;
@property (nonatomic, weak) UILabel *nameL;

@property (nonatomic, assign) CGFloat mHigh;
@property (nonatomic, weak) UIImageView *pV;
@property (nonatomic, weak) UILabel *pL;

@property (nonatomic, weak) UIImageView *maskLayer;
//等待加载图片
@property (nonatomic, strong) ImageLoadingView *loadingView;

@end

@implementation RecommendCell

//
- (void)initDao{
    
    if (!self.favoriteDao) {
        self.favoriteDao = [[CollectionDAO alloc]init];
    }
}


+ (RecommendCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RecommendCell";
    
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[RecommendCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
        
        [self initDao];
    }
    
    return self;
}


- (void)setUpChildView {
    self.contentView.backgroundColor = BACKGROUND_COLOR;

    if (MAINSCREEN.size.width == IPHONE6_PLUS_WIDTH) {
        _mHigh = IMAGE_H_IPHONE6_Plus;
    }
    else if (MAINSCREEN.size.width == IPHONE6_WIDTH) {
        _mHigh = IMAGE_H_IPHONE6;
    }
    else
        _mHigh = IMAGE_H_IPHONE5;
    
    //图片
    UIImageView *picV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, _mHigh)];
    _picV = picV;
    _picV.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_picV];
    
    
    //遮罩
    CALayer *maskLayer = [CALayer layer];
    [maskLayer setFrame:CGRectMake(0, CGRectGetHeight(_picV.frame)-60, MAINSCREEN.size.width, 60)];
    [maskLayer setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.4].CGColor];
    [_picV.layer addSublayer:maskLayer];
    
    //标题
    UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(10, _mHigh-55, MAINSCREEN.size.width-56, 26)];
    _titL = titL;
    [_titL setFont:[UIFont boldSystemFontOfSize:19.0]];
    [_titL setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:_titL];

  
    UIImageView *posV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_location_icon"]];
    [posV setFrame:CGRectMake(10, _mHigh-23, 8, 12)];
    [self.contentView addSubview:posV];
    
    
    //店铺名称
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(22, _mHigh-28, 300, 20)];
    _nameL = nameL;
    [_nameL setFont:[UIFont systemFontOfSize:12.0]];
    [_nameL setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:_nameL];
    
    //热度
    UIImageView *pV = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width - 48, _mHigh-23, 14, 10)];
    _pV = pV;
    [_pV setImage:[UIImage imageNamed:@"browse"]];
    [self.contentView addSubview:_pV];
    
    
    UILabel *pL = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width - 28, _mHigh-28, 45, 20)];
    _pL = pL;
    [_pL setFont:[UIFont systemFontOfSize:12.0]];
    [_pL setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:_pL];
}


- (void)setCellWithCellInfo:(RecommendInfo *)mInfo
{
    if (mInfo.coverUrl) {
        [self configureView:mInfo.coverUrl];
    }
    else {
        _picV.image = [UIImage imageNamed:@"default_image.png"];
    }
    
    [_titL setText:mInfo.title];
    
    NSString *st = [NSString stringWithFormat:@"%@   %@", mInfo.name, [Units getDistanceByLatitude:(NSString *)mInfo.distance]];
    
    [_nameL setText:st];

    _pL.text =  [NSString stringWithFormat:@"%lu", (long)mInfo.browse];

    
}

#pragma mark - 下载图片
- (void)configureView:(NSString *)imageURL
{
    if (imageURL) {
        [_loadingView showLoading];
        [_loadingView setFrame:CGRectMake(CGRectGetWidth(_picV.frame)/2, CGRectGetWidth(_picV.frame)/2, CGRectGetWidth(_picV.frame), CGRectGetHeight(_picV.frame))];
        [_picV addSubview:_loadingView];
        
        dispatch_after(0.2, dispatch_get_global_queue(0, 0), ^{
            __block ImageLoadingView *loadingView = _loadingView;
            
            [_picV sd_setImageWithURL:[NSURL URLWithString:imageURL]
                     placeholderImage:[UIImage imageNamed:@"default_image.png"]
                              options:SDWebImageLowPriority
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 
                                 if (!loadingView) {
                                     loadingView = [[ImageLoadingView alloc] init];
                                 }
                                 
                                 if (receivedSize > kMinProgress) {
                                     loadingView.progress = (float)receivedSize/expectedSize;
                                 }
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                [loadingView removeFromSuperview];
                                loadingView = nil;
                            }];
        });
    }
}


@end
