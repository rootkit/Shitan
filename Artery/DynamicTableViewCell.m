//
//  DynamicTableViewCell.m
//  Shitan
//
//  Created by 刘敏 on 14/11/30.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "DynamicTableViewCell.h"
#import <SDWebImage/UIImage+WebP.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TimeUtil.h"
#import "TipInfo.h"
#import "CommentInfo.h"
#import "MLEmojiLabel.h"
#import "ImageLoadingView.h"
#import "HCSStarRatingView.h"


#define  OFFSET_X_LEFT      30      //评论或者赞（文字距离左侧的距离）
#define  OFFSET_X_RIGHT     12

#define PRAISE_MORE     @"PRAISE_MORE"        //赞多于x人
#define COMMENTS_MORE   @"COMMENTS_MORE"      //更多评论

@interface DynamicTableViewCell ()<MLEmojiLabelDelegate, TTTAttributedLabelDelegate>

@property (nonatomic, strong) ImageLoadingView *loadingView;

@property (weak, nonatomic) HCSStarRatingView *starbBar;     //评分
@property (weak, nonatomic) UILabel *staeLabel;      //分数

@end

@implementation DynamicTableViewCell


- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor = BACKGROUND_COLOR;
    
    //背景(先设一个默认高度)
    self.bgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.width+60+45)];
    self.bgroundView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgroundView];
    
    //顶部
    self.headV = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headV.frame = CGRectMake(10, 10, 40, 40);
    [self.headV addTarget:self action:@selector(headButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgroundView addSubview:self.headV];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 11, 173, 21)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:14.0]];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.nameLabel setTextColor:MAIN_USERNAME_COLOR];
    [self.bgroundView addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 34, 90, 18)];
    [self.timeLabel setFont:[UIFont systemFontOfSize:12.0]];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [self.timeLabel setTextColor:[UIColor lightGrayColor]];
    [self.bgroundView addSubview:self.timeLabel];
    
    
    self.focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.focusButton.frame = CGRectMake(MAINSCREEN.size.width-65, 18, 50, 23);
    [self.focusButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [self.focusButton setImage:[UIImage imageNamed:@"btn_dynamic_follow.png"] forState:UIControlStateNormal];

    [self.focusButton setTitle:@" 关注" forState:UIControlStateNormal];
    [self.focusButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.focusButton addTarget:self action:@selector(focusButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgroundView addSubview:self.focusButton];

    //图片
    self.picImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, MAINSCREEN.size.width, MAINSCREEN.size.width)];
    [self.bgroundView addSubview:self.picImageV];
    
    //评分
    HCSStarRatingView *starbBar = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width-160, 60+MAINSCREEN.size.width+10, 100, 20)];
    _starbBar = starbBar;
    _starbBar.maximumValue = 5;
    _starbBar.minimumValue = 0;
    _starbBar.tintColor = MAIN_COLOR;
    _starbBar.backgroundColor = [UIColor clearColor];
    _starbBar.enabled = NO;
    [self.bgroundView addSubview:_starbBar];
    
    UILabel *staeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width-50, 60+MAINSCREEN.size.width+12, 40, 20)];
    _staeLabel = staeLabel;
    [_staeLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_staeLabel setTextColor:MAIN_COLOR];
    [self.bgroundView addSubview:_staeLabel];
    
    //开启触摸响应
    self.contentView.userInteractionEnabled = YES;
    self.bgroundView.userInteractionEnabled = YES;
    self.picImageV.userInteractionEnabled = YES;

    // 进度条
    _loadingView = [[ImageLoadingView alloc] init];
    
    _desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_desLabel setTextColor:MAIN_TEXT_COLOR];
    [self.bgroundView addSubview:_desLabel];
    
    if (!_dao) {
        self.dao = [[UserRelationshipDAO alloc] init];
    }
    
    if (!_mDao) {
        self.mDao = [[ImageDAO alloc] init];
    }
    
    _bubbleArray = [[NSMutableArray alloc] init];

    _isShow = YES;
    
    /************************************************ 底部View ***********************************************/
    //赞、评论、收藏、更多按钮
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, MAINSCREEN.size.width, 45)];
    [self.bgroundView addSubview:_bottomView];
    
    
    UIImageView *dyLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 4)];
    [dyLine setImage:[UIImage imageNamed:@"dy_line.png"]];
    [_bottomView addSubview:dyLine];

    /******************    赞     ********************/
    _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_praiseButton setFrame:CGRectMake(0, 5, 45, 39)];
    [_praiseButton setImage:[UIImage imageNamed:@"btn_like.png"] forState:UIControlStateNormal];
    [_praiseButton addTarget:self action:@selector(praiseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_praiseButton];
    
    /******************    评论     ********************/
    _commentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentsButton setFrame:CGRectMake(70, 5, 45, 39)];
    
    [_commentsButton setImage:[UIImage imageNamed:@"btn_comment.png"] forState:UIControlStateNormal];
    [_commentsButton setImage:[UIImage imageNamed:@"btn_comment_highlighted.png"] forState:UIControlStateHighlighted];
    [_commentsButton addTarget:self action:@selector(commentsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_commentsButton];
    
    /******************    收藏     ********************/
    _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectionButton setFrame:CGRectMake(140, 5, 45, 39)];

    
    [_collectionButton setImage:[UIImage imageNamed:@"btn_fav.png"] forState:UIControlStateNormal];
    [_collectionButton setImage:[UIImage imageNamed:@"btn_fav_highlighted.png"] forState:UIControlStateHighlighted];
    [_collectionButton addTarget:self action:@selector(collectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_collectionButton];
    
    /******************    更多     ********************/
    _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectionButton setFrame:CGRectMake(MAINSCREEN.size.width-60, 5, 45, 39)];
    
    [_collectionButton setImage:[UIImage imageNamed:@"btn_more.png"] forState:UIControlStateNormal];
    [_collectionButton setImage:[UIImage imageNamed:@"btn_more_highlighted.png"] forState:UIControlStateHighlighted];
    [_collectionButton addTarget:self action:@selector(moreButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_collectionButton];
}

- (void)setIVC:(ImageListViewController *)iVC
{
    _iVC = iVC;
}

//- (void)setDVC:(DynamicalTableViewController *)dVC
//{
//    _dVC = dVC;
//}

- (void)setTipsVC:(TipsDetailsViewController *)tipsVC{
    
    _tipsVC = tipsVC;
}

- (void)setRVC:(ResultItemViewController *)rVC
{
    _rVC = rVC;
}

- (void)setSVC:(SpecialViewController *)sVC
{
    _sVC = sVC;
}




// 赋值
- (CGFloat)setCellWithCellInfo:(DynamicInfo *)dInfo isShowfocusButton:(BOOL)_show
{
    if (dInfo) {
        _dInfo = dInfo;
    }
    
    
    CGFloat m_hight = 60 + MAINSCREEN.size.width +25;   //顶部高度跟图片高度
    
    [self.headV sd_setBackgroundImageWithURL:[NSURL URLWithString:[Units headImageThumbnails:dInfo.portraitUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_default.png"]];
    
    //头像圆角
    [self.headV.layer setCornerRadius:CGRectGetHeight([self.headV bounds]) / 2];
    self.headV.layer.masksToBounds = YES;
    
    
    if (dInfo.userType == Acc_STBB) {
        //食探标识
        UIImageView *bageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge_st.png"]];
        [bageV setFrame:CGRectMake(35, 35, 15, 15)];
        [self.contentView addSubview:bageV];
    }

    
    //发布者昵称
    self.nameLabel.text = dInfo.nickname;
    //时间
    self.timeLabel.text = [TimeUtil getTimeStrStyle1:dInfo.createTime];
    
    //已关注的好友和自己不再显示关注按钮
    if (dInfo.hasFollowTheAuthor || [[AccountInfo sharedAccountInfo].userId isEqualToString:dInfo.userId] || !_show) {
        [_focusButton setHidden:YES];
    }
    
    if (dInfo.imgUrl) {
        [self configureView:dInfo.imgUrl];
    }
    else{
        [self.picImageV setImage:[UIImage imageNamed:@"default_image.png"]];
    }

    _starbBar.value = dInfo.score;
    if(dInfo.score == 0)
    {
        [_starbBar setFrame:CGRectMake(MAINSCREEN.size.width-170, 60+MAINSCREEN.size.width+10, 100, 20)];
        [_staeLabel setFrame:CGRectMake(MAINSCREEN.size.width-60, 60+MAINSCREEN.size.width+10, 50, 20)];
        _staeLabel.text = @"未评分";
    }
    else
        [_staeLabel setText:[NSString stringWithFormat:@"%.1f分", (CGFloat)dInfo.score]];
    
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

    /****************************************  图片描述    ***********************************************/
    if ([dInfo.imgDesc length] > 0) {
        //底部view距离图片的高度
        m_hight += [self calculateDesLabelheight:m_hight desLabel:dInfo.imgDesc];
    }
    
    /**************************************   赞过得用户列表   *******************************************/
    if(dInfo.praiseCount > 0)
    {
        UIImageView *praiseV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_likes.png"]];
        [praiseV setFrame:CGRectMake(OFFSET_X_RIGHT, m_hight+15, 12, 12)];
        [self.bgroundView addSubview:praiseV];
        
        
        //CLog(@"%02f", [self setPraise:dInfo.persInfo currentHeight:m_hight]);
        m_hight += [self setPraise:dInfo.persInfo currentHeight:m_hight];
    }
    
    /**************************************   评论列表   *******************************************/
    if (dInfo.commentCount > 0) {
        m_hight +=  [self setComments:dInfo.comInfo imageAuthor:dInfo.userId currentHeight:m_hight];
    }
    
    
    if (dInfo.hasPraise) {
        [_praiseButton setImage:[UIImage imageNamed:@"btn_like_highlighted.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_praiseButton setImage:[UIImage imageNamed:@"btn_like.png"] forState:UIControlStateNormal];
    }
    
    CLog(@"%02f", m_hight);
    [_bottomView setFrame:CGRectMake(0, m_hight+12, MAINSCREEN.size.width, 45)];

    [self.bgroundView setFrame:CGRectMake(0, 0, MAINSCREEN.size.width, m_hight+12+45)];
    
    
    return m_hight+12+45+5+10;
}


// 计算DesLabl的高度
- (CGFloat)calculateDesLabelheight:(CGFloat)height desLabel:(NSString *)text
{
    
    MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
    praisLabel.numberOfLines = 0;
    praisLabel.font = [UIFont systemFontOfSize:14.0f];
    praisLabel.delegate = self;
    praisLabel.textAlignment = NSTextAlignmentLeft;
    praisLabel.backgroundColor = [UIColor clearColor];
    praisLabel.isNeedAtAndPoundSign = YES;
    praisLabel.emojiText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    praisLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    praisLabel.customEmojiPlistName = @"expression";
    
    CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_RIGHT*2];
    praisLabel.frame = CGRectMake(OFFSET_X_RIGHT, height+15.0, MAINSCREEN.size.width - OFFSET_X_RIGHT*2, size.height);
    
    [self.bgroundView addSubview:praisLabel];
    
    
    if (size.height > 0.0) {
        return size.height + 15.0;
    }
    
    return 0.0;
}

//设置赞
- (CGFloat)setPraise:(NSArray *)cArray currentHeight:(CGFloat)mHeight
{
    
    //排序（以时间降序排列）
    NSSortDescriptor *sorter  = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sorter count:1];
    //排列后的数组（时间从小到大排列）
    NSMutableArray *sortArray = [[NSMutableArray alloc] initWithArray:[cArray sortedArrayUsingDescriptors:sortDescriptors]];
    //倒序
    sortArray = (NSMutableArray *)[[sortArray reverseObjectEnumerator] allObjects];
    
    MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
    praisLabel.numberOfLines = 0;
    praisLabel.font = [UIFont systemFontOfSize:14.0f];
    praisLabel.delegate = self;
    praisLabel.textAlignment = NSTextAlignmentLeft;
    praisLabel.backgroundColor = [UIColor clearColor];
    praisLabel.isNeedAtAndPoundSign = YES;

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    if ([sortArray count] > 9) {
        praisLabel.emojiText = [NSString stringWithFormat:@"共%lu人赞过", (unsigned long)sortArray.count];
        
        [dic setObject:PRAISE_MORE forKey:@"userID"];
        [praisLabel addLinkToTransitInformation:dic withRange:[praisLabel.emojiText rangeOfString:praisLabel.emojiText]];
    }
    else{
        NSMutableArray * nickArray = [[NSMutableArray alloc] init];
        
        for (PraiseInfo *pInfo in sortArray) {
            [nickArray addObject:pInfo.nickName];
        }
        praisLabel.emojiText = [nickArray componentsJoinedByString:@"，"];
        
        
        //用来存储拼接数据
        NSMutableString *prais =[[NSMutableString alloc] init];
        
        for (PraiseInfo *pInfo in sortArray) {
            NSRange range = NSMakeRange(prais.length, pInfo.nickName.length);
            [praisLabel addLinkToTransitInformation:dic withRange:range];
            
            //设置字典
            [dic setObject:pInfo.userId forKey:@"userID"];
            [praisLabel addLinkToTransitInformation:dic withRange:[praisLabel.emojiText rangeOfString:pInfo.nickName]];
            
            [prais appendFormat:@"%@，", pInfo.nickName];
        }
    }

    CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
    praisLabel.frame = CGRectMake(OFFSET_X_LEFT, mHeight+12, MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT, size.height);
    
    [self.bgroundView addSubview:praisLabel];
    
    
    if (size.height > 0.0) {
        return size.height + 9.0;
    }
    
    return 0.0;
}

//设置评论
- (CGFloat)setComments:(NSArray *)cArray imageAuthor:(NSString *)authorID
         currentHeight:(CGFloat)mHeight
{
    //排序（以时间降序排列）
    NSSortDescriptor *sorter  = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sorter count:1];
    
    //排列后的数组（时间从小到大排列）
    NSMutableArray *sortArray = [[NSMutableArray alloc] initWithArray:[cArray sortedArrayUsingDescriptors:sortDescriptors]];

    NSInteger i = 0;
    CGFloat tempHeight = 0.0;
    
    //查看更多评论
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    for(CommentInfo *cInfo in sortArray)
    {        
        MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
        praisLabel.numberOfLines = 0;
        praisLabel.font = [UIFont systemFontOfSize:14.0f];
        praisLabel.delegate = self;
        praisLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        praisLabel.customEmojiPlistName = @"expression";
        praisLabel.textAlignment = NSTextAlignmentLeft;
        praisLabel.backgroundColor = [UIColor clearColor];
        praisLabel.isNeedAtAndPoundSign = YES;
        
        NSString *tempS = @"";
        
        if (!cInfo.parentCommentId || [cInfo.commentedUserId isEqualToString:cInfo.commentUserId]) {
            tempS = [NSString stringWithFormat:@"%@: %@", cInfo.commentUserNickname, cInfo.content];
            
            praisLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            [dic setObject:cInfo.commentUserId forKey:@"userID"];
            [praisLabel addLinkToTransitInformation:dic withRange:[praisLabel.emojiText rangeOfString:cInfo.commentUserNickname]];
            
            CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
            
            praisLabel.frame = CGRectMake(OFFSET_X_RIGHT, mHeight+12+ tempHeight, MAINSCREEN.size.width - OFFSET_X_RIGHT  - OFFSET_X_RIGHT, size.height);
            
            [self.bgroundView addSubview:praisLabel];
            
            tempHeight += size.height+4;
        }
        else
        {
            MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
            praisLabel.numberOfLines = 0;
            praisLabel.font = [UIFont systemFontOfSize:14.0f];
            praisLabel.delegate = self;
            praisLabel.textAlignment = NSTextAlignmentLeft;
            praisLabel.backgroundColor = [UIColor clearColor];
            praisLabel.isNeedAtAndPoundSign = YES;
            praisLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
            praisLabel.customEmojiPlistName = @"expression";
            
            tempS = [NSString stringWithFormat:@"%@ 回复 %@: %@", cInfo.commentUserNickname, cInfo.commentedUserNickname, cInfo.content];
            
            praisLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            /********************************* 评论者 *************/
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:cInfo.commentUserId forKey:@"userID"];
            [praisLabel addLinkToTransitInformation:dic withRange:NSMakeRange(0, cInfo.commentUserNickname.length)];
            
            NSUInteger m_l = [[NSString stringWithFormat:@"%@ 回复 ", cInfo.commentUserNickname] length];
            /********************************* 被评论者 *************/
            [dic setObject:cInfo.commentedUserId forKey:@"userID"];
            [praisLabel addLinkToTransitInformation:dic withRange:NSMakeRange(m_l, cInfo.commentedUserNickname.length)];
            
            CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
            
            praisLabel.frame = CGRectMake(OFFSET_X_RIGHT, mHeight+12+ tempHeight, MAINSCREEN.size.width - OFFSET_X_RIGHT  - OFFSET_X_RIGHT, size.height);
            
            [self.bgroundView addSubview:praisLabel];
            
            tempHeight += size.height+4;
        }
        
        i++;
    }

    if(_dInfo.commentCount > 4)
    {
        MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
        praisLabel.numberOfLines = 0;
        praisLabel.font = [UIFont systemFontOfSize:14.0f];
        praisLabel.delegate = self;
        praisLabel.textAlignment = NSTextAlignmentLeft;
        praisLabel.backgroundColor = [UIColor clearColor];
        praisLabel.isNeedAtAndPoundSign = YES;
        
        NSString *tempS = [NSString stringWithFormat:@"查看全部 %ld 条评论", (long)_dInfo.commentCount];
        praisLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [dic setObject:COMMENTS_MORE forKey:@"userID"];
        [praisLabel addLinkToTransitInformation:dic withRange:[praisLabel.emojiText rangeOfString:praisLabel.emojiText]];
        
        CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
        
        praisLabel.frame = CGRectMake(OFFSET_X_RIGHT, mHeight+12+ tempHeight, MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT, size.height);
        
        [self.bgroundView addSubview:praisLabel];
        
        tempHeight += size.height;
    }
    
    if (tempHeight > 0.0) {
        return 12+ tempHeight;
    }
    
    return 0.0;
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

//绘制标签
- (void)drawBubbleView:(NSArray *)array
{
    NSInteger mTAG = 9000;
    
    for (TipInfo *tInfo in array) {
        
        CGPoint newPoint = [self fixedCoordinates:CGPointMake(tInfo.point_X, tInfo.point_Y)];
        
        BubbleView *bubbleV = [[BubbleView alloc] initWithFrame:CGRectMake(newPoint.x, newPoint.y, 0, 26) initWithInfo:tInfo];

        //校正坐标(出现越界情况)
        CGFloat b_w = bubbleV.frame.size.width;    //自身宽度
        CGFloat m_x = newPoint.x + b_w;            //所处位置
        
        if (m_x >= MAINSCREEN.size.width && !bubbleV.isLeft) {
            bubbleV = nil;
            bubbleV = [[BubbleView alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width - b_w, newPoint.y, 0, 26) initWithInfo:tInfo];
        }
        
        //设置标签TAG值
        bubbleV.tag = mTAG++;
        bubbleV.delegate = self;
        
        [self.picImageV addSubview:bubbleV];
        
        //填充到标签数组
        [_bubbleArray addObject:bubbleV];
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
- (void)focusButtonTapped:(id)sender
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
            
//            if (_dVC) {
//                [_dVC focusButtonTapped];
//            }
            
//            if (_iVC) {
//                [_iVC focusButtonTapped];
//            }
            
            
            if (_tipsVC) {
                [_tipsVC focusButtonTapped];
            }
            
            if (_rVC) {
                [_rVC focusButtonTapped];
            }
            
            if (_sVC) {
                [_sVC focusButtonTapped];
            }
            


        }
        else
        {
            CLog(@"%@", [result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}



//头像
- (void)headButtonTapped:(id)sender
{
    if (_tipsVC) {
        [_tipsVC imgaeHeadTapped:_dInfo.userId];
    }
    
    if (_rVC) {
        [_rVC imgaeHeadTapped:_dInfo.userId];
    }
    

    
    if (_sVC) {
        [_sVC imgaeHeadTapped:_dInfo.userId];
    }
    

}


//赞（喜欢）
- (void)praiseButtonTapped:(id)sender
{
    if (!_dInfo.hasPraise) {
        //赞
        [_praiseButton setImage:[UIImage imageNamed:@"btn_like_highlighted.png"] forState:UIControlStateNormal];
        [self getPraiseImage];
        
//        //赞成功 （动画并且改变）
//        if (_dVC) {
//            //填充数据模型
//            PraiseInfo *pInfo = [[PraiseInfo alloc] init];
//            pInfo.hasFollowTheAuthor = _dInfo.hasFollowTheAuthor;
//            pInfo.userId = [AccountInfo sharedAccountInfo].userId;
//            pInfo.nickName = [AccountInfo sharedAccountInfo].nickname;
//            pInfo.portraitUrl = [AccountInfo sharedAccountInfo].portraiturl;
//            pInfo.imgId = _dInfo.imgId;
//            pInfo.createTime = [Units getNowTime];
//            
//            [self reloadInputViews];
//            
//            [_dVC praiseButtonTapped:pInfo];
//        }
//        if (_iVC) {
//            //填充数据模型
//            PraiseInfo *pInfo = [[PraiseInfo alloc] init];
//            pInfo.hasFollowTheAuthor = _dInfo.hasFollowTheAuthor;
//            pInfo.userId = [AccountInfo sharedAccountInfo].userId;
//            pInfo.nickName = [AccountInfo sharedAccountInfo].nickname;
//            pInfo.portraitUrl = [AccountInfo sharedAccountInfo].portraiturl;
//            pInfo.imgId = _dInfo.imgId;
//            pInfo.createTime = [Units getNowTime];
//            
//            [self reloadInputViews];
//            
//            [_iVC praiseButtonTapped:pInfo];
//        }
        
//        if (_pVC) {
//            //填充数据模型
//            PraiseInfo *pInfo = [[PraiseInfo alloc] init];
//            pInfo.hasFollowTheAuthor = _dInfo.hasFollowTheAuthor;
//            pInfo.userId = [AccountInfo sharedAccountInfo].userId;
//            pInfo.nickName = [AccountInfo sharedAccountInfo].nickname;
//            pInfo.portraitUrl = [AccountInfo sharedAccountInfo].portraiturl;
//            pInfo.imgId = _dInfo.imgId;
//            pInfo.createTime = [Units getNowTime];
//            
//            [self reloadInputViews];
//            
//            [_pVC praiseButtonTapped:pInfo];
//        }
        
        
        if (_tipsVC) {
            //填充数据模型
            PraiseInfo *pInfo = [[PraiseInfo alloc] init];
            pInfo.hasFollowTheAuthor = _dInfo.hasFollowTheAuthor;
            pInfo.userId = [AccountInfo sharedAccountInfo].userId;
            pInfo.nickName = [AccountInfo sharedAccountInfo].nickname;
            pInfo.portraitUrl = [AccountInfo sharedAccountInfo].portraiturl;
            pInfo.imgId = _dInfo.imgId;
            pInfo.createTime = [Units getNowTime];
            
            [self reloadInputViews];
            
            [_tipsVC praiseButtonTapped:pInfo];
        }
        
        if (_sVC) {
            //填充数据模型
            PraiseInfo *pInfo = [[PraiseInfo alloc] init];
            pInfo.hasFollowTheAuthor = _dInfo.hasFollowTheAuthor;
            pInfo.userId = [AccountInfo sharedAccountInfo].userId;
            pInfo.nickName = [AccountInfo sharedAccountInfo].nickname;
            pInfo.portraitUrl = [AccountInfo sharedAccountInfo].portraiturl;
            pInfo.imgId = _dInfo.imgId;
            pInfo.createTime = [Units getNowTime];
            
            [self reloadInputViews];
            
            [_sVC praiseButtonTapped:pInfo];
        }
        
        
    }
    else{
        //取消赞
        [_praiseButton setImage:[UIImage imageNamed:@"btn_like.png"] forState:UIControlStateNormal];
        [self requestCancelPraise];
        
        
        PraiseInfo *pInfo = [[PraiseInfo alloc] init];
        pInfo.hasFollowTheAuthor = _dInfo.hasFollowTheAuthor;
        pInfo.userId = [AccountInfo sharedAccountInfo].userId;
        pInfo.nickName = [AccountInfo sharedAccountInfo].nickname;
        pInfo.portraitUrl = [AccountInfo sharedAccountInfo].portraiturl;
        pInfo.imgId = _dInfo.imgId;
        pInfo.createTime = [Units getNowTime];
        
        [self reloadInputViews];
//        
//        if(_pVC)
//        {
//            [_pVC cancelPraise:pInfo];
//        }
        
//        if (_iVC) {
//            [_iVC cancelPraise:pInfo];
//        }
        
//        if (_dVC) {
//            [_dVC cancelPraise:pInfo];
//        }
        
        if (_tipsVC) {
            [_tipsVC cancelPraise:pInfo];
        }
        
        if (_sVC) {
            [_sVC cancelPraise:pInfo];
        }
        
    }
}

//评论
- (void)commentsButtonTapped:(id)sender
{
    if (_tipsVC) {
        [_tipsVC commentsImage:_dInfo];
    }
    
    if (_rVC) {
        [_rVC commentsImage:_dInfo];
    }
    
//    if (_dVC) {
//        [_dVC commentsImage:_dInfo];
//    }
//    
//    if (_iVC) {
//        [_iVC commentsImage:_dInfo];
//    }
    
    if (_sVC){
        [_sVC commentsImage:_dInfo];
    }
    
//    if (_pVC){
//        [_pVC commentsImage:_dInfo];
//    }
}


//收藏
- (void)collectionButtonTapped:(id)sender
{
    if (_tipsVC) {
        [_tipsVC collectionTypeChoose:_dInfo];
    }
    
    if (_rVC) {
        [_rVC collectionTypeChoose:_dInfo];
    }
    
//    if (_dVC) {
//        [_dVC collectionTypeChoose:_dInfo];
//    }
    
//    if (_iVC) {
//        [_iVC collectionTypeChoose:_dInfo];
//    }
    
    if (_sVC){
        [_sVC collectionTypeChoose:_dInfo];
    }
//    
//    if (_pVC){
//        [_pVC collectionTypeChoose:_dInfo];
//    }
}


//更多
- (void)moreButtonTapped:(id)sender
{
    if (_tipsVC) {
        [_tipsVC moreButtonTapped:_dInfo];
    }
    
    if (_rVC) {
        [_rVC moreButtonTapped:_dInfo];
    }
    
//    if (_dVC) {
//        [_dVC moreButtonTapped:_dInfo];
//    }
    
//    if (_iVC) {
//        [_iVC moreButtonTapped:_dInfo];
//    }
    
    if (_sVC) {
        [_sVC moreButtonTapped:_dInfo];
    }
//    
//    if (_pVC) {
//        [_pVC moreButtonTapped:_dInfo];
//    }

}


//图片是否已经赞过
- (void)getPraiseImage
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dic setObject:_dInfo.imgId forKey:@"imgId"];
    
    [_mDao requestPraisePic:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {

            if (_rVC){
                [_rVC praiseButtonTapped];
            }
            
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
        
    }];
}



//取消赞
- (void)requestCancelPraise
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dic setObject:_dInfo.imgId forKey:@"imgId"];
    
    [_mDao requestCancelPraise:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {

            if (_rVC){
                [_rVC cancelPraise];
            }
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
        
    }];
    
}


#pragma mark - 标签点击事件响应
- (void)clickBubbleViewWithInfo:(NSInteger)mtag
{
    
    if (_dInfo.addressId) {
        _dInfo.sInfo.addressId = _dInfo.addressId;
    }
    
    //将城市赋值过去给ShopInfo
    if(_dInfo.city)
    {
        _dInfo.sInfo.city = _dInfo.city;
    }
    
    BubbleView *bv = (BubbleView *)[self.picImageV viewWithTag:mtag];
    if (_tipsVC) {
        [_tipsVC clickBubbleViewWithInfo:bv shopWithInfo:_dInfo.sInfo];
    }
    
    if (_rVC){
        [_rVC clickBubbleViewWithInfo:bv shopWithInfo:_dInfo.sInfo];
    }
    
//    if (_iVC) {
//        [_iVC clickBubbleViewWithInfo:bv shopWithInfo:_dInfo.sInfo];
//    }
    
//    
//    if (_dVC){
//        [_dVC clickBubbleViewWithInfo:bv shopWithInfo:_dInfo.sInfo];
//    }
    
    
    if (_sVC){
        [_sVC clickBubbleViewWithInfo:bv shopWithInfo:_dInfo.sInfo];
    }
//    
//    if (_pVC){
//        [_pVC clickBubbleViewWithInfo:bv shopWithInfo:_dInfo.sInfo];
//    }
}


#pragma mark - MLEmojiLabelDelegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"点击了某个自添加链接%@",url);

}


- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    NSLog(@"点击了某个自添加链接%@",addressComponents);
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    NSString *status = [components objectForKey:@"userID"];
    
    if ([status isEqualToString:COMMENTS_MORE]) {
        
//        if (_iVC) {
//            [_iVC loadCommentListView:_dInfo.imgId imageReleasedID:_dInfo.userId];
//        }
//
//        if (_dVC) {
//            [_dVC loadCommentListView:_dInfo.imgId imageReleasedID:_dInfo.userId];
//        }

        if (_tipsVC) {
            [_tipsVC loadCommentListView:_dInfo.imgId imageReleasedID:_dInfo.userId];
        }
        
        if (_rVC) {
            [_rVC loadCommentListView:_dInfo.imgId imageReleasedID:_dInfo.userId];
        }
        
        if (_sVC) {
            [_sVC loadCommentListView:_dInfo.imgId imageReleasedID:_dInfo.userId];
        }
//        
//        if (_pVC) {
//            [_pVC loadCommentListView:_dInfo.imgId imageReleasedID:_dInfo.userId];
//        }
        
    }
    else if ([status isEqualToString:PRAISE_MORE]) {
        //进入赞列表
        if (_tipsVC) {
            [_tipsVC imagePraisList:_dInfo.imgId];
        }
        
        //进入赞列表
//        if (_iVC) {
//            [_iVC imagePraisList:_dInfo.imgId];
//        }
        
        
//        if (_dVC) {
//            [_dVC imagePraisList:_dInfo.imgId];
//        }
        
        
        if (_rVC) {
            [_rVC imagePraisList:_dInfo.imgId];
        }
        
        if (_sVC) {
            [_sVC imagePraisList:_dInfo.imgId];
        }
        
//        if (_pVC) {
//            [_pVC imagePraisList:_dInfo.imgId];
//        }
    }
    else
    {
        //点击用户昵称
//        if (_iVC) {
//            [_iVC imgaeHeadTapped:status];
//        }
        
//        if (_dVC) {
//            [_dVC imgaeHeadTapped:status];
//        }
        
        
        if (_tipsVC) {
            [_tipsVC imgaeHeadTapped:status];
        }
        
        if (_rVC) {
            [_rVC imgaeHeadTapped:status];
        }
        
        if (_sVC) {
            [_sVC imgaeHeadTapped:status];
        }
        
//        if (_pVC) {
//            [_pVC imgaeHeadTapped:status];
//        }
    }
}

//下载图片
- (void)configureView:(NSString *)imageURL
{
    if (imageURL) {
        
        [_loadingView showLoading];
        [_loadingView setFrame:CGRectMake(MAINSCREEN.size.width/2, MAINSCREEN.size.width/2, MAINSCREEN.size.width, MAINSCREEN.size.width)];
        [self.picImageV addSubview:_loadingView];
        
        
        
        dispatch_after(0.2, dispatch_get_global_queue(0, 0), ^{
            __block ImageLoadingView *loadingView = _loadingView;
            [self.picImageV sd_setImageWithURL:[NSURL URLWithString:imageURL]
                              placeholderImage:[UIImage imageNamed:@"default_image.png"]
                                       options:SDWebImageDelayPlaceholder
                                      progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                          
                                          CLog(@"%ld, %ld", (long)receivedSize, (long)expectedSize);
                                          
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

//精选专用
- (void)setQuality
{
    self.timeLabel.text = @"精选";
}

@end
