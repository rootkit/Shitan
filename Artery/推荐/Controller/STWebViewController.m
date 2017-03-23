//
//  STWebViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-10-29.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STWebViewController.h"
#import <ASIHTTPRequest/TReachability.h>
#import "SGActionView.h"
#import "ShareModel.h"


@interface STWebViewController ()<UIWebViewDelegate, UIActionSheetDelegate>
{
    NSTimer *_timer;            // 用于UIWebView保存图片
    int _gesState;              // 用于UIWebView保存图片
    NSString *_imgURL;          // 用于UIWebView保存图片
}
//分享
@property (nonatomic, strong) NSArray *openArray;
@property (nonatomic, strong) NSArray *openImageArray;

@end

@implementation STWebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(_mType == Type_Special)
    {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(get_more) forControlEvents:UIControlEventTouchUpInside];
        [self setNavBarRightBtn:rightBtn];
        
        _titName = _bInfo.title;
        _urlSting = _bInfo.h5Url;
        
    }
    
    [self setNavBarTitle:_titName];
    
    
    _urlSting = [_urlSting stringByReplacingOccurrencesOfString:@" " withString:@"_"];;
    CLog(@"%@", _urlSting);
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlSting]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0]];
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setOpaque:YES];//使网页透明
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ((![self IsEnableWiFi]) && (![self IsEnable3G])) {
        
    }
    else{
        
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [_webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (BOOL)IsEnable3G {
    return ([[TReachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
    
}

- (BOOL)IsEnableWiFi {
    return ([[TReachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
    
}



//获取更多
- (void)get_more{
    [self summarizeShareData];
    
    [SGActionView sharedActionView].style = SGActionViewStyleLight;
    [SGActionView showGridMenuWithTitle:nil
                             itemTitles:_openArray
                                 images:_openImageArray
                         selectedHandle:^(NSInteger index)  {
                             [self didClickOnImageIndex:index];
                         }];
}


- (void)summarizeShareData{
    NSMutableArray *tA = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tB = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
    {
        [tA addObject:@"QQ好友"];
        [tA addObject:@"QQ空间"];
        
        [tB addObject:[UIImage imageNamed:@"sns_icon_1"]];
        [tB addObject:[UIImage imageNamed:@"sns_icon_2"]];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechhat://"]])
    {
        [tA addObject:@"微信好友"];
        [tA addObject:@"微信朋友圈"];
        
        [tB addObject:[UIImage imageNamed:@"sns_icon_4"]];
        [tB addObject:[UIImage imageNamed:@"sns_icon_5"]];
    }
    
    _openArray = tA;
    _openImageArray = tB;
}





- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    if (imageIndex == 0)
    {
        return;
    }
    NSString *description = _bInfo.shareDesc;
    //跳转链接
    NSString *url = _bInfo.h5Url;
    
    
    
    //图片DATA
    NSData *imageData = nil;
    if([_bInfo.shareImgUrl length] > 1)
    {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_bInfo.shareImgUrl]];
    }
    else{
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage320Thumbnails:_bInfo.bannerImgUrl]]];
    }
    
    
    NSString * name = [_openArray objectAtIndex:imageIndex-1];
    if ([name isEqualToString:@"QQ好友"]) {
        [[ShareModel getInstance] qqFriendsShareMessageWithUrl:url thumbnail:imageData describe:description title:_bInfo.shareTitle];
    }
    
    if ([name isEqualToString:@"QQ空间"]) {
        [[ShareModel getInstance] qqZoneShareMessageWithUrl:url thumbnail:imageData describe:description title:_bInfo.shareTitle];
    }
    
    if ([name isEqualToString:@"微信好友"]) {
        [[ShareModel getInstance] wechatFriendsMessageWithUrl:url thumbnail:imageData describe:description title:_bInfo.shareTitle];
    }
    
    if ([name isEqualToString:@"微信朋友圈"]) {
        [[ShareModel getInstance] wechatCircleMessageWithUrl:url thumbnail:imageData describe:_bInfo.shareTitle title:_bInfo.shareTitle];
    }
}

@end
