//
//  DynamicToolsbarView.m
//  Shitan
//
//  Created by Avalon on 15/5/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "DynamicToolsbarView.h"
#import "DynamicModelFrame.h"

#import "SGActionView.h"
#import "TipInfo.h"
#import "ShareModel.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "ImageDAO.h"

#import "CommentListViewController.h"


@interface DynamicToolsbarView ()

//数据源
@property (nonatomic, strong) ImageDAO *dao;


//点赞
@property (nonatomic, weak) UIButton *praiseButton;

//评论
@property (nonatomic, weak) UIButton *commentButton;

//收藏
@property (nonatomic, weak) UIButton *collectionButton;

//更多
@property (nonatomic, weak) UIButton *moreButton;

@property (nonatomic, weak) UIView *lineView;

//分享
@property (nonatomic, strong) NSArray *openArray;
@property (nonatomic, strong) NSArray *openImageArray;

@end


@implementation DynamicToolsbarView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initDao];
        
        [self setUpChildView];
    }
    
    return self;
}

- (void)initDao{
    
    if (_dao == nil) {
        _dao = [[ImageDAO alloc] init];
    }
}

- (void)setLineNO:(NSUInteger)lineNO
{
    _lineNO = lineNO;
}

- (void)setUpChildView{
    
    UIImageView *dyLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 4)];
    [dyLine setImage:[UIImage imageNamed:@"dy_line.png"]];
    [self addSubview:dyLine];
    
    self.praiseButton = [self setUpOneButtonWithTag:0 image:[UIImage imageNamed:@"btn_like"] highlightedImage:nil];
    
    self.commentButton = [self setUpOneButtonWithTag:1 image:[UIImage imageNamed:@"btn_comment"] highlightedImage:[UIImage imageNamed:@"btn_comment_highlighted"]];
    
    self.collectionButton = [self setUpOneButtonWithTag:2 image:[UIImage imageNamed:@"btn_fav"] highlightedImage:[UIImage imageNamed:@"btn_fav_highlighted"]];
    
    self.moreButton = [self setUpOneButtonWithTag:3 image:[UIImage imageNamed:@"btn_more"] highlightedImage:[UIImage imageNamed:@"btn_more_highlighted"]];
 
    UIView *lineView=  [[UIView alloc] init];
    self.lineView = lineView;
    self.lineView.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:_lineView];
}

- (void)setDynamicModelFrame:(DynamicModelFrame *)dynamicModelFrame{
    
    _dynamicModelFrame = dynamicModelFrame;
    
    self.praiseButton.frame = dynamicModelFrame.praiseButtonFrame;
    self.commentButton.frame = dynamicModelFrame.commentButtonFrame;
    self.collectionButton.frame = dynamicModelFrame.collectionButtonFrame;
    self.moreButton.frame = dynamicModelFrame.moreButtonFrame;
    self.lineView.frame = dynamicModelFrame.lineViewFrame;
    
    if (self.dynamicModelFrame.dInfo.hasPraise) {
        [self.praiseButton setImage:[UIImage imageNamed:@"btn_like_highlighted"] forState:UIControlStateNormal];
    }
    else {
        [self.praiseButton setImage:[UIImage imageNamed:@"btn_like"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 生成按钮
- (UIButton *)setUpOneButtonWithTag:(NSInteger)index
                              image:(UIImage *)image
                   highlightedImage:(UIImage *)highImage{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.tag = index;
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    return btn;
    
}

#pragma mark - 按钮的响应事件
- (void)btnClick:(UIButton *)sender{
    
    if (!theAppDelegate.isLogin) {
        STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
        STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
        nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        nc.view.layer.shadowOpacity = 0.2;
        
        [theAppDelegate.mainVC presentViewController:nc animated:YES completion:nil];
        
        return;
    }
    
    
    if (sender.tag == 3) {
        [self summarizeShareData];
        
        [SGActionView sharedActionView].style = SGActionViewStyleLight;
        [SGActionView showGridMenuWithTitle:nil
                                 itemTitles:_openArray
                                     images:_openImageArray
                             selectedHandle:^(NSInteger index) {
                                 [self didClickOnImageIndex:index];
                             }];
    }
    else
    {
        if (sender.tag == 0)
        {
            if (self.dynamicModelFrame.dInfo.hasPraise) {
                //取消赞
                [self requestCancelPraise];
            }
            else
                [self getPraiseImage];
        }
        
        if ([self.delegate respondsToSelector:@selector(dynamicToolsbarView:withIndex:DynamicInfo:indexWithRow:)]) {
            
            [self.delegate dynamicToolsbarView:self withIndex:sender.tag DynamicInfo:self.dynamicModelFrame.dInfo indexWithRow:self.lineNO];
        }
    }

}


#pragma mark 分享及增删改查
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
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]])
    {
        [tA addObject:@"微信好友"];
        [tA addObject:@"微信朋友圈"];
        
        [tB addObject:[UIImage imageNamed:@"sns_icon_4"]];
        [tB addObject:[UIImage imageNamed:@"sns_icon_5"]];
    }
    
    if ([self.dynamicModelFrame.dInfo.userId isEqualToString:[AccountInfo sharedAccountInfo].userId])
    {
        [tA addObject:@"删除"];
        [tB addObject:[UIImage imageNamed:@"sns_icon_6"]];
    }
    else
    {
        //0为普通用户，1为管理员，2为超级管理员
        if ([AccountInfo sharedAccountInfo].userType != 0) {
            [tA addObject:@"举报"];
            [tB addObject:[UIImage imageNamed:@"sns_icon_7"]];
            
            [tA addObject:@"隐藏"];
            [tB addObject:[UIImage imageNamed:@"sns_icon_8"]];
        }
        else
        {
            [tA addObject:@"举报"];
            [tB addObject:[UIImage imageNamed:@"sns_icon_7"]];
        }
    }
    
    [tA addObject:@"下载"];
    [tB addObject:[UIImage imageNamed:@"sns_icon_9"]];
    
    _openArray = tA;
    _openImageArray = tB;
}


- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    if (imageIndex == 0)
    {
        return;
    }
    NSString *description = @"美食推荐";
    
    NSArray *tagsArray = self.dynamicModelFrame.dInfo.tags;
    
    if (self.dynamicModelFrame.dInfo.tags != nil) {
        for (TipInfo *tInfo in tagsArray) {
            if (tInfo.tipType == Tip_FoodN) {
                description = [description stringByAppendingString:[NSString stringWithFormat:@":%@", tInfo.title]];
            }
        }
        
        for (TipInfo *tInfo in tagsArray) {
            if (tInfo.tipType == Tip_Location) {
                description = [description stringByAppendingString:[NSString stringWithFormat:@" 地点:%@", tInfo.title]];
            }
        }
        
        for (TipInfo *tInfo in tagsArray) {
            if (tInfo.tipType == Tip_Normal) {
                description = [description stringByAppendingString:[NSString stringWithFormat:@" #%@", tInfo.title]];
            }
        }
    }
    
    NSString * name = [_openArray objectAtIndex:imageIndex-1];
    if ([name isEqualToString:@"QQ好友"]) {
        //QQ好友
        //跳转链接
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=QQ&uid=%@",self.dynamicModelFrame.dInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:self.dynamicModelFrame.dInfo.imgUrl]]];
        
        [[ShareModel getInstance] qqFriendsShareMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"QQ空间"]) {
        //QQ空间
        //分享跳转URL
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=Qzone&uid=%@",self.dynamicModelFrame.dInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:self.dynamicModelFrame.dInfo.imgUrl]]];
        
        [[ShareModel getInstance] qqZoneShareMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"微信好友"]) {
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=Weixin&uid=%@",self.dynamicModelFrame.dInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:self.dynamicModelFrame.dInfo.imgUrl]]];
        
        [[ShareModel getInstance] wechatFriendsMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"微信朋友圈"]) {
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=Weixin&uid=%@",self.dynamicModelFrame.dInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:self.dynamicModelFrame.dInfo.imgUrl]]];
        
        [[ShareModel getInstance] wechatCircleMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"删除"]) {
        //删除图片
        [self deleteImage];
        
        if ([self.delegate respondsToSelector:@selector(dynamicToolsbarView:imageID:indexWithRow:)]) {
            
            [self.delegate dynamicToolsbarView:self imageID:self.dynamicModelFrame.dInfo.imgId indexWithRow:self.lineNO];
        }
    }
    
    if ([name isEqualToString:@"举报"]) {
        //举报
        [self reportImage];
    }
    
    if ([name isEqualToString:@"隐藏"]) {
        //隐藏图片
        [self hideImage];
        
        if ([self.delegate respondsToSelector:@selector(dynamicToolsbarView:imageID:indexWithRow:)]) {
            
            [self.delegate dynamicToolsbarView:self imageID:self.dynamicModelFrame.dInfo.imgId indexWithRow:self.lineNO];
        }
    }
    
    if ([name isEqualToString:@"下载"]) {
        //下载图片
        [self downloadImage];
    }
    
}


#pragma mark SGAction 事件
//下载图片
- (void)downloadImage{
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSURL *imageUrl = [NSURL URLWithString:self.dynamicModelFrame.dInfo.imgUrl];
  
    NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        UIImage *downImage = [UIImage imageWithData:data];
        CLog(@"转换图片");
        [library saveImage:downImage toAlbum:@"食探" completion:^(NSURL *assetURL, NSError *error) {
            //刷新
            MET_MIDDLE(@"下载成功");
            
        } failure:^(NSError *error) {
            if (error != nil) {
                CLog(@"Big error: %@", [error description]);
            }
        }];
    }];
    
  
}

//隐藏图片
- (void)hideImage
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:self.dynamicModelFrame.dInfo.imgId forKey:@"imgId"];
    [dic setObject:self.dynamicModelFrame.dInfo.userId forKey:@"userId"];
    
    [_dao requestHideImage:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}

//删除图片
- (void)deleteImage
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:self.dynamicModelFrame.dInfo.imgId forKey:@"imgId"];
    [dic setObject:self.dynamicModelFrame.dInfo.userId forKey:@"userId"];
    
    [_dao requestDeleteImage:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            //刷新
            MET_MIDDLE(@"删除成功");
            
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
    
}

//举报图片
- (void)reportImage
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:self.dynamicModelFrame.dInfo.imgId forKey:@"imgId"];
    [dic setObject:self.dynamicModelFrame.dInfo.userId forKey:@"userId"];
    
    [_dao requestReportPic:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            //刷新
            MET_MIDDLE(@"举报成功");
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}


//点过
- (void)getPraiseImage
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dic setObject:self.dynamicModelFrame.dInfo.imgId forKey:@"imgId"];
    
    [_dao requestPraisePic:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            CLog(@"点赞成功");
        }
        else
        {
//            MET_MIDDLE([result objectForKey:@"msg"])
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
        
    }];
}



//取消赞
- (void)requestCancelPraise
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dic setObject:self.dynamicModelFrame.dInfo.imgId forKey:@"imgId"];
    
    [_dao requestCancelPraise:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            CLog(@"取消点赞成功");
        }
        else
        {
//            MET_MIDDLE([result objectForKey:@"msg"])
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
        
    }];
    
}



@end
