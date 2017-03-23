//
//  TipsTableViewCell.m
//  Shitan
//
//  Created by 刘敏 on 14/12/9.
//  Copyright (c) 2014年 刘 敏. All rights reserved.
//

#import "TipsTableViewCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TimeUtil.h"
#import "TipInfo.h"


@implementation TipsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor = BACKGROUND_COLOR;
    
    //开启触摸响应
    self.contentView.userInteractionEnabled = YES;
    self.bgroundView.userInteractionEnabled = YES;
    self.picImageV.userInteractionEnabled = YES;
    
//    UIImageView *lineV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_line"]];
//    [lineV setFrame:CGRectMake(0, 59.5, MAINSCREEN.size.width, 0.5)];
//    [self.bgroundView addSubview:lineV];
    
    
    _desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.bgroundView addSubview:_desLabel];
    
    if (!_dao) {
        self.dao = [[UserRelationshipDAO alloc] init];
    }
    
    if (!_mDao) {
        self.mDao = [[ImageDAO alloc] init];
    }
    
    self.bubbleArray = [[NSMutableArray alloc] init];
    
    _isShow = YES;
    
    _viewWidth.constant = MAINSCREEN.size.width;
    _picHight.constant = MAINSCREEN.size.width;
}

- (void)setController:(STChildViewController *)controller{
    if (_favController) {
        _favController = (FavoriteDetailViewController *)controller;
    }
    
}



// 赋值
- (void)setCellWithCellInfo:(DynamicInfo *)dInfo isShowfocusButton:(BOOL)_show
{
    _dInfo = dInfo;
    
    CGFloat m_hight = 0.0;
    [self.headV sd_setBackgroundImageWithURL:[NSURL URLWithString:[Units headImageThumbnails:dInfo.portraitUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_default.png"]];
    
    //头像圆角
    [self.headV.layer setCornerRadius:CGRectGetHeight([self.headV bounds]) / 2];
    self.headV.layer.masksToBounds = YES;
    
    //发布者昵称
    self.nameLabel.text = dInfo.nickname;
    //时间
    self.timeLabel.text = [TimeUtil getTimeStrStyle1:dInfo.createTime];
    
    
    //已关注的好友和自己不再显示关注按钮
    if (dInfo.hasFollowTheAuthor || [[AccountInfo sharedAccountInfo].userId isEqualToString:dInfo.userId] || !_show) {
        [_focusButton setHidden:YES];
    }
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:dInfo.imgUrl] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    
    /********************************    单击手势    ***********************************/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBubble:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    
    //开启触摸事件响应
    [self.picImageV addGestureRecognizer:tapGesture];
    
    //绘制标签
    if (dInfo.tags) {
        [self drawBubbleView:dInfo.tags];
    }
    
    
    if ([dInfo.imgDesc length] > 0) {
        m_hight = [self calculateDesLabelheight:dInfo.imgDesc];
        
        _viewHight.constant = MAINSCREEN.size.width+60 + m_hight+32;
    }
    else{
        _viewHight.constant = MAINSCREEN.size.width+60;
    }
    

    
}

//隐藏标签（正常是显示的，点击之后隐藏）
- (void)hideBubble:(UITapGestureRecognizer *)tapGesture
{
    _isShow = !_isShow;
    if (_isShow) {
        //显示
        for (BubbleView *bv in _bubbleArray) {
            [bv setHidden:NO];
        }
    }
    else
    {
        //隐藏
        for (BubbleView *bv in _bubbleArray) {
            [bv setHidden:YES];
        }
    }
}

// 计算DesLabl的高度
- (CGFloat)calculateDesLabelheight:(NSString *)text
{
    //设置自动行数与字符换行
    [self.desLabel setNumberOfLines:0];
    self.desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    // 测试字串
    UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:14.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(MAINSCREEN.size.width-24, 2000);
    
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;

    [self.desLabel setFrame:CGRectMake(12, MAINSCREEN.size.width +72, size.width, size.height)];
    [self.desLabel setText:text];
    [self.desLabel setFont:font];
    [self.desLabel setTextColor:MAIN_TEXT_COLOR];
    
    return size.height;
}

//绘制标签
- (void)drawBubbleView:(NSArray *)array
{
    NSInteger mTAG = 9000;
    
    for (TipInfo *tInfo in array) {
        
        CGPoint newPoint = [self fixedCoordinates:CGPointMake(tInfo.point_X, tInfo.point_Y)];
        
        BubbleView *bubbleV = [[BubbleView alloc] initWithFrame:CGRectMake(newPoint.x, newPoint.y, 0, 26) initWithInfo:tInfo];
        
        
        //设置标签TAG值
        bubbleV.tag = mTAG++;
        bubbleV.delegate = self;
        
        [self.picImageV addSubview:bubbleV];
        
        //填充到标签数组
        [self.bubbleArray addObject:bubbleV];
    }
}


//修正坐标
- (CGPoint)fixedCoordinates:(CGPoint)oldPoint
{
    //二者取最大值
    CGFloat mBig = _dInfo.imgWidth > _dInfo.imgHeight ? _dInfo.imgWidth : _dInfo.imgHeight;
    
    CGFloat m_ratioX = MAINSCREEN.size.width / mBig;        //X轴系数
    CGFloat m_ratioY = MAINSCREEN.size.width / mBig;        //Y轴系数
    
    CGPoint endPoint = CGPointZero;
    
    endPoint.x = oldPoint.x * m_ratioX;
    endPoint.y = oldPoint.y * m_ratioY;
    //修复越界
    if (endPoint.y > MAINSCREEN.size.width-26) {
        
        endPoint.y = MAINSCREEN.size.width-26;
    }
    
    
    return endPoint;
}


#pragma mark - 按钮响应事件
- (IBAction)focusButtonTapped:(id)sender
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followerUserId"];
    [dict setObject:_dInfo.userId forKey:@"followedUserId"];
    
    //关注好友
    [_dao requestUserFollow:dict completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            //重新获取
            [AccountInfo sharedAccountInfo].followedCount++;
            
            [_focusButton setHidden:YES];
            
            //TODO：重新获取动态
        }
        else
        {
            CLog(@"%@", [result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}



//头像
- (IBAction)headButtonTapped:(id)sender
{
    if (_favController) {
        [_favController imgaeHeadTapped:_dInfo];
    }
}


#pragma mark - 标签点击事件响应
- (void)clickBubbleViewWithInfo:(NSInteger)mtag
{
    BubbleView *bv = (BubbleView *)[self.picImageV viewWithTag:mtag];

    if (_favController) {
        [_favController clickBubbleViewWithInfo:bv shopWithInfo:_dInfo.sInfo];
    }
}

//- (void)setBubbleArray:(NSMutableArray *)bubbleArray{
//    
//    [_bubbleArray removeAllObjects];
//    _bubbleArray = bubbleArray;
//    
//}
@end
