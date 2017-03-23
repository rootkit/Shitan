//
//  ParallaxHeaderView.m
//  ParallaxTableViewHeader
//
//  Created by Vinodh  on 26/10/14.
//  Copyright (c) 2014 Daston~Rhadnojnainva. All rights reserved.

//

#import <QuartzCore/QuartzCore.h>
#import "ParallaxHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ParallaxHeaderView ()
@property (weak, nonatomic) UIScrollView *imageScrollView;
@property (weak, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *bluredImageView;

@property (nonatomic, strong) UIImageView *headV;

@end

#define kDefaultHeaderFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

static CGFloat kParallaxDeltaFactor = 0.5f;
static CGFloat kMaxTitleAlphaOffset = 100.0f;

@implementation ParallaxHeaderView


+ (id)parallaxHeaderViewWithCGSize:(CGSize)headerSize;
{
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    [headerView initialSetup];
    return headerView;
}

- (void)awakeFromNib
{
    [self initialSetup];
}


- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    CGRect frame = self.imageScrollView.frame;
    
    if (offset.y > 0)
    {
        frame.origin.y = MAX(offset.y *kParallaxDeltaFactor, 0);
        self.imageScrollView.frame = frame;
        self.bluredImageView.alpha =   1 / kDefaultHeaderFrame.size.height * offset.y * 2;
        self.clipsToBounds = YES;
    }
    else
    {
        CGFloat delta = 0.0f;
        CGRect rect = kDefaultHeaderFrame;
        delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.imageScrollView.frame = rect;
        self.clipsToBounds = NO;
        self.headerTitleLabel.alpha = 1 - (delta) * 1 / kMaxTitleAlphaOffset;
        self.desLabel.alpha = 1 - (delta) * 1 / kMaxTitleAlphaOffset;
    }
}

#pragma mark -
#pragma mark Private

- (void)initialSetup
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.imageScrollView = scrollView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView = imageView;
    [self.imageScrollView addSubview:imageView];
    
    CGRect labelRect = CGRectMake(0, CGRectGetHeight(self.imageScrollView.frame) - 60, MAINSCREEN.size.width, 30);
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:labelRect];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    headerLabel.autoresizingMask = imageView.autoresizingMask;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:21.0];
    self.headerTitleLabel = headerLabel;
    [self.imageScrollView addSubview:self.headerTitleLabel];
    
    CGRect desRect = CGRectMake(0, CGRectGetHeight(self.imageScrollView.frame)/2 +5, MAINSCREEN.size.width, 30);
    UILabel *desLabel = [[UILabel alloc] initWithFrame:desRect];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    desLabel.autoresizingMask = imageView.autoresizingMask;
    desLabel.textColor = [UIColor whiteColor];
    desLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.desLabel = desLabel;
    [self.imageScrollView addSubview:self.desLabel];
    
    
    self.bluredImageView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    self.bluredImageView.autoresizingMask = self.imageView.autoresizingMask;
    self.bluredImageView.alpha = 0.0f;
    [self.imageScrollView addSubview:self.bluredImageView];
    
    [self addSubview:self.imageScrollView];
    
    
    UIView *mV = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(self.imageScrollView.frame)-45, 270, 45)];
    mV.autoresizingMask = imageView.autoresizingMask;
    [self.imageScrollView addSubview:mV];
}

- (void)setHeaderURL:(NSString *)headerURL
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:headerURL] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
}


- (UIImage *)screenShotOfView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(kDefaultHeaderFrame.size, YES, 0.0);
    [self drawViewHierarchyInRect:kDefaultHeaderFrame afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end