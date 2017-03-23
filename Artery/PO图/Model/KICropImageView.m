//
//  KICropImageView.m
//  Artery
//
//  Created by 刘敏 on 15/1/10.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//  注意：图片统一按1280*1280来裁剪

#import "KICropImageView.h"

#define TOP_HEIGHT 64

@implementation KICropImageView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [[self scrollView] setFrame:self.bounds];
    [[self maskView] setFrame:self.bounds];
    
    if (CGSizeEqualToSize(_cropSize, CGSizeZero)) {
        [self setCropSize:CGSizeMake(MAINSCREEN.size.width, MAINSCREEN.size.width)];
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate:self];
        [_scrollView setBounces:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [[self scrollView] addSubview:_imageView];
    }
    return _imageView;
}

//遮罩区域
- (KICropImageMaskView *)maskView {
    if (_maskView == nil) {
        _maskView = [[KICropImageMaskView alloc] init];
        [_maskView setBackgroundColor:[UIColor clearColor]];
        [_maskView setUserInteractionEnabled:NO];
        [self addSubview:_maskView];
        [self bringSubviewToFront:_maskView];
    }
    return _maskView;
}

- (void)setImage:(UIImage *)image {
    if (image != _image) {
        [_image release];
        _image = nil;
        _image = [image retain];
    }
    [[self imageView] setImage:_image];
    
    [self updateZoomScale];
}

/*****更新缩放系数****/
- (void)updateZoomScale {
    _scrollView.scrollEnabled = YES;
    [[self scrollView] setUserInteractionEnabled:YES];

    CLog(@"图片的宽度跟高度：%02f, %02f", _image.size.width, _image.size.height);
    
    CGFloat m_zoom = 0.0;
    //宽度大于高度,以最短的边做填充
    if(_image.size.width > _image.size.height && _image.size.height > 0)
    {
        //缩放系数
        m_zoom = MAINSCREEN.size.width/_image.size.height;
        [[self imageView] setFrame:CGRectMake(0, 0, _image.size.width*m_zoom, MAINSCREEN.size.width)];
    }
    
    if (_image.size.height > _image.size.width && _image.size.width > 0) {
        //缩放系数
        m_zoom = MAINSCREEN.size.width/_image.size.width;
        [[self imageView] setFrame:CGRectMake(0, 0, MAINSCREEN.size.width, _image.size.height*m_zoom)];
    }
    
    if (_image.size.height == _image.size.width && _image.size.height > 0) {
        [[self imageView] setFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.width)];
    }

    CGFloat width = _image.size.width/2;
    CGFloat height = _image.size.height/2;
    
    
    CGFloat xScale = _cropSize.width / width;
    CGFloat yScale = _cropSize.height / height;
    
    CGFloat min = 1.0;
    CGFloat max = MAX(xScale, yScale);
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        max = 1.0 / [[UIScreen mainScreen] scale];
    }
    
    if (min > max) {
        max = min;
    }
    
    [[self scrollView] setMinimumZoomScale:min];
    [[self scrollView] setMaximumZoomScale:max + 1.0f];
    
    [[self scrollView] setZoomScale:max animated:YES];
    
    
}


/*****照片填充****/
- (void)photoFilling
{
    _scrollView.scrollEnabled = NO;
    [[self scrollView] setUserInteractionEnabled:NO];

    
    [[self scrollView] setContentOffset:CGPointMake(0, -TOP_HEIGHT)];
    
    CLog(@"图片的宽度跟高度：%02f, %02f", _image.size.width, _image.size.height);
    
    CGFloat m_zoom = 0.0;
    //宽度大于高度,以最短的边做填充
    if(_image.size.width > _image.size.height && _image.size.height > 0)
    {
        //缩放系数
        m_zoom = MAINSCREEN.size.width/_image.size.width;
        CGFloat m_difference = (MAINSCREEN.size.width -_image.size.height*m_zoom)/2;
        [[self imageView] setFrame:CGRectMake(0, m_difference, MAINSCREEN.size.width, _image.size.height*m_zoom)];
    }
    
    if (_image.size.height > _image.size.width && _image.size.width > 0) {
        //缩放系数
        m_zoom = MAINSCREEN.size.width/_image.size.height;
        CGFloat m_difference = (MAINSCREEN.size.width -_image.size.width*m_zoom)/2;
        [[self imageView] setFrame:CGRectMake(m_difference, 0, _image.size.width*m_zoom, MAINSCREEN.size.width)];
    }
    
    if (_image.size.height == _image.size.width && _image.size.height > 0) {
        [[self imageView] setFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.width)];
    }
    
}


- (void)setCropSize:(CGSize)size {
    _cropSize = size;
    [self updateZoomScale];
    
    CGFloat width = _cropSize.width;
    CGFloat height = _cropSize.height;
    
    CGFloat x = (CGRectGetWidth(MAINSCREEN) - width) / 2;

    [_maskView setCropSize:_cropSize];
    
    CGFloat top = TOP_HEIGHT;
    CGFloat left = x;
    CGFloat right = CGRectGetWidth(MAINSCREEN)- width - x;
    CGFloat bottom = CGRectGetHeight(MAINSCREEN)- height - top;
    _imageInset = UIEdgeInsetsMake(top, left, bottom, right);
    [[self scrollView] setContentInset:_imageInset];
    
    [[self scrollView] setContentOffset:CGPointMake(0, 0)];
}




//裁剪图片
- (UIImage *)cropImage
{
    //裁剪之前隐藏线条
    [_maskView removeFromSuperview];
    
    
    /**
     *  图片裁剪
     *
     *  @param MAINSCREEN.size.width 屏幕宽度
     *
     *  @return 返回裁剪后的图片
     */
    CGSize msize = CGSizeMake(MAINSCREEN.size.width, MAINSCREEN.size.width+TOP_HEIGHT);
    
    // 缩放比例（高清分辨率为2倍， iPhone 6 Plus 为3x）
    UIGraphicsBeginImageContextWithOptions(msize, NO, 4.0);

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    CLog(@"%f, %f", viewImage.size.width, viewImage.size.height);
    
    
    //测试用
//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    
    //二次裁剪（这里可以设置想要截图的区域）
    CGRect rect = CGRectMake(0, TOP_HEIGHT*4, 1500, 1500);
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    image = [self scaleToSize:image size:CGSizeMake(1280, 1280)];
    
    CLog(@"%f, %f", image.size.width, image.size.height);
    
    return image;
}


//缩小图片尺寸
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    // 创建一个bitmap的context
    
    // 并把它设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    //返回新的改变大小后的图片
    return scaledImage;
}




#pragma UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self imageView];
}

- (void)dealloc {
    [_scrollView release];
    _scrollView = nil;
    [_imageView release];
    _imageView = nil;
    [_maskView release];
    _maskView = nil;
    [_image release];
    _image = nil;
    [super dealloc];
}
@end

#pragma KISnipImageMaskView

#define kMaskViewBorderWidth 1.0f

@implementation KICropImageMaskView

- (void)setCropSize:(CGSize)size {
    
    CGFloat x = (CGRectGetWidth(MAINSCREEN) - size.width) / 2;
    _cropRect = CGRectMake(x, TOP_HEIGHT, size.width, size.height);
    
    [self setNeedsDisplay];
}

- (CGSize)cropSize {
    return _cropRect.size;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 1, 1, 1, .6);
    CGContextFillRect(ctx, MAINSCREEN);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextStrokeRectWithWidth(ctx, _cropRect, kMaskViewBorderWidth);
    
    CGContextClearRect(ctx, _cropRect);
}

@end
