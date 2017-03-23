//
//  STWebViewController.h
//  Shitan
//
//  Created by 刘敏 on 14-10-29.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "BannerInfo.h"

@interface STWebViewController : STChildViewController

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@property (nonatomic, assign) WebEntranceType mType;  //入口来源

@property (nonatomic, strong) BannerInfo *bInfo;      //专题数据
@property (nonatomic, strong) NSString *urlSting;     //链接
@property (nonatomic, strong) NSString *titName;      //标题

@end
