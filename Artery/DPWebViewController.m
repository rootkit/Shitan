//
//  DPWebViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "DPWebViewController.h"
#import <ASIHTTPRequest/TReachability.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

#define StatuBar_Heigh   20.0f

@interface DPWebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic, assign) NSUInteger mPage;
@property (nonatomic, weak) UIButton *endBtn;

@end

@implementation DPWebViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navbar addSubview:_progressView];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavBarTitle:_titName];
    
    UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(44, 22, 40, 40)];
    _endBtn = endBtn;
    [_endBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_endBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [_endBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_endBtn addTarget:self action:@selector(shutDown:) forControlEvents:UIControlEventTouchUpInside];
    [_endBtn setHidden:YES];
    [self.navbar addSubview:_endBtn];
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight+StatuBar_Heigh, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"ia_back.png" imgHighlight:nil imgSelected:nil target:self action:@selector(back:)]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView = webView;
    if (isIOS8) {
        [_webView setFrame:CGRectMake(0, -2, MAINSCREEN.size.width, MAINSCREEN.size.height+20)];
    }
    else{
        [_webView setFrame:CGRectMake(0, StatuBar_Heigh-2, MAINSCREEN.size.width, MAINSCREEN.size.height)];
    }
    
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    [self.view addSubview:_webView];
    
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlSting]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0]];
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setOpaque:YES];//使网页透明
    
    for (id subview in _webView.subviews){
        if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).bounces = NO;
            
        }
        
    }
}


- (void)back:(id)sender
{
    if (!_webView.canGoBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [_webView goBack];
        [_endBtn setHidden:NO];
    }
}

- (void)shutDown:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


@end
