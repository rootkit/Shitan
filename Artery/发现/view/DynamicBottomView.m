//
//  DynamicBottomView.m
//  Shitan
//
//  Created by Avalon on 15/5/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "DynamicBottomView.h"
#import "DynamicModelFrame.h"
#import "MLEmojiLabel.h"


#define PRAISE_MORE   @"PRAISE_MORE"        //赞多于x人
#define COMMENTS_MORE   @"COMMENTS_MORE"    //更多评论


@interface DynamicBottomView () <MLEmojiLabelDelegate,TTTAttributedLabelDelegate>

//点赞图片
@property (nonatomic, weak) UIImageView *praiseImageView;

//评论图片
@property (nonatomic, weak) UIImageView *commentImageView;

//点赞内容
@property (nonatomic, weak) UIView * praiseLabelView;

//评论内容
@property (nonatomic, weak) UIView *commentLabelView;

@end


@implementation DynamicBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpChildView];
    }
    return self;
}

- (void)setLineNO:(NSUInteger)lineNO
{
    _lineNO = lineNO;
}

- (void)setUpChildView{
    
    UIImageView *praiseImageView = [[UIImageView alloc]init];
    self.praiseImageView = praiseImageView;
    [self addSubview:self.praiseImageView];
    
//    UIImageView *commentImageView = [[UIImageView alloc] init];
//    self.commentImageView = commentImageView;
//    [self addSubview:self.commentImageView];
    
    UIView *praiseLabelView = [[UIView alloc] init];
    self.praiseLabelView = praiseLabelView;
    [self addSubview:self.praiseLabelView];
    
    UIView *commentLabelView = [[UIView alloc] init];
    self.commentLabelView = commentLabelView;
    [self addSubview:self.commentLabelView];
    
}

- (void)setDynamicModelFrame:(DynamicModelFrame *)dynamicModelFrame{
    
    _dynamicModelFrame = dynamicModelFrame;

//避免重用问题
    //赞
    if (self.dynamicModelFrame.dInfo.praiseCount) {
        _praiseImageView.frame = self.dynamicModelFrame.praiseVFrame;
        _praiseImageView.image = [UIImage imageNamed:@"icon_likes.png"];
        _praiseLabelView.frame = self.dynamicModelFrame.praiseLabelFrame;
    }
    else{
        _praiseImageView.frame = CGRectZero;
        _praiseLabelView.frame = CGRectZero;
    }
    //评论
    if (self.dynamicModelFrame.dInfo.commentCount) {
        _commentLabelView.frame = self.dynamicModelFrame.commentLabelFrame;
    }
    else {
        _commentLabelView.frame = CGRectZero;
    }
    [self setPraise:self.dynamicModelFrame.dInfo.persInfo];
    [self setComments:self.dynamicModelFrame.dInfo.comInfo imageAuthor:self.dynamicModelFrame.dInfo.userId];
}

#pragma mark - 评论列表
- (void)setComments:(NSArray *)cArray imageAuthor:(NSString *)authorID{
    
    for (MLEmojiLabel *commentLabel in self.commentLabelView.subviews) {
        [commentLabel removeFromSuperview];
    }
    
    
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
        MLEmojiLabel *commentLabel = [[MLEmojiLabel alloc] init];
        commentLabel.numberOfLines = 0;
        commentLabel.font = [UIFont systemFontOfSize:FontSize];
        commentLabel.delegate = self;
        commentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        commentLabel.customEmojiPlistName = @"expression";
        commentLabel.textAlignment = NSTextAlignmentLeft;
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.isNeedAtAndPoundSign = YES;
        
        NSString *tempS = @"";
        
        if (!cInfo.parentCommentId || [cInfo.commentedUserId isEqualToString:cInfo.commentUserId]) {
            tempS = [NSString stringWithFormat:@"%@: %@", cInfo.commentUserNickname, cInfo.content];
            
            commentLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            [dic setObject:cInfo.commentUserId forKey:@"userID"];
            [commentLabel addLinkToTransitInformation:dic withRange:[commentLabel.emojiText rangeOfString:cInfo.commentUserNickname]];
            
            CGSize size = [commentLabel preferredSizeWithMaxWidth:self.commentLabelView.frame.size.width];
            
            commentLabel.frame = CGRectMake(0, tempHeight, self.commentLabelView.frame.size.width, size.height);
            
            [self.commentLabelView addSubview:commentLabel];
            tempHeight += size.height+4;
        }
        else
        {
            MLEmojiLabel *commentLabel = [[MLEmojiLabel alloc] init];
            commentLabel.numberOfLines = 0;
            commentLabel.font = [UIFont systemFontOfSize:FontSize];
            commentLabel.delegate = self;
            commentLabel.textAlignment = NSTextAlignmentLeft;
            commentLabel.backgroundColor = [UIColor clearColor];
            commentLabel.isNeedAtAndPoundSign = YES;
            commentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
            commentLabel.customEmojiPlistName = @"expression";
            
            tempS = [NSString stringWithFormat:@"%@ 回复 %@: %@", cInfo.commentUserNickname, cInfo.commentedUserNickname, cInfo.content];
            
            commentLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            /********************************* 评论者 *************/
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:cInfo.commentUserId forKey:@"userID"];
            [commentLabel addLinkToTransitInformation:dic withRange:NSMakeRange(0, cInfo.commentUserNickname.length)];
            
            NSUInteger m_l = [[NSString stringWithFormat:@"%@ 回复 ", cInfo.commentUserNickname] length];
            /********************************* 被评论者 *************/
            [dic setObject:cInfo.commentedUserId forKey:@"userID"];
            [commentLabel addLinkToTransitInformation:dic withRange:NSMakeRange(m_l, cInfo.commentedUserNickname.length)];
            
            CGSize size = [commentLabel preferredSizeWithMaxWidth:self.commentLabelView.frame.size.width];
            
            commentLabel.frame = CGRectMake(0,  tempHeight, self.commentLabelView.frame.size.width, size.height);
            
            [self.commentLabelView addSubview:commentLabel];
            
            tempHeight += size.height+4;
        }
        
        i++;
    }
    
    if(self.dynamicModelFrame.dInfo.commentCount > 4)
    {
        MLEmojiLabel *commentLabel = [[MLEmojiLabel alloc] init];
        commentLabel.numberOfLines = 0;
        commentLabel.font = [UIFont systemFontOfSize:FontSize];
        commentLabel.delegate = self;
        commentLabel.textAlignment = NSTextAlignmentLeft;
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.isNeedAtAndPoundSign = YES;
        
        NSString *tempS = [NSString stringWithFormat:@"查看全部 %ld 条评论", (long)self.dynamicModelFrame.dInfo.commentCount];
        commentLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [dic setObject:COMMENTS_MORE forKey:@"userID"];
        [commentLabel addLinkToTransitInformation:dic withRange:[commentLabel.emojiText rangeOfString:commentLabel.emojiText]];
        
        CGSize size = [commentLabel preferredSizeWithMaxWidth:self.commentLabelView.frame.size.width];
        
        commentLabel.frame = CGRectMake(0, tempHeight, self.commentLabelView.frame.size.width, size.height);
        
        [self.commentLabelView addSubview:commentLabel];
        
        tempHeight += size.height;
    }
    
}

#pragma mark - 设置赞列表
- (void)setPraise:(NSArray *)cArray
{
    
    for (MLEmojiLabel *praiseLabel in self.praiseLabelView.subviews) {
        [praiseLabel removeFromSuperview];
    }
    
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

    CGSize size = [praisLabel preferredSizeWithMaxWidth:self.praiseLabelView.frame.size.width];
    praisLabel.frame = CGRectMake(0, 0, self.praiseLabelView.frame.size.width, size.height);

    [self.praiseLabelView addSubview:praisLabel];
    
}


#pragma mark - MLEmojiDelegate

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
    if (!theAppDelegate.isLogin) {
        STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
        STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
        nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        nc.view.layer.shadowOpacity = 0.2;
        
        [theAppDelegate.mainVC presentViewController:nc animated:YES completion:nil];
        
        return;
    }

    
    NSString *status = [components objectForKey:@"userID"];
    
    if ([status isEqualToString:COMMENTS_MORE]) {
        //进入评论列表
        if ([self.delegate respondsToSelector:@selector(dynamicBottomView:WithUserId:ImageId:cellWithRow:)]) {
            [self.delegate dynamicBottomView:self WithUserId:self.dynamicModelFrame.dInfo.userId ImageId:self.dynamicModelFrame.dInfo.imgId cellWithRow:self.lineNO];
        }
    }
    else if ([status isEqualToString:PRAISE_MORE]) {
        //进入赞列表
        if ([self.delegate respondsToSelector:@selector(dynamicBottomView:WithImageId:)]) {
            [self.delegate dynamicBottomView:self WithImageId:self.dynamicModelFrame.dInfo.imgId];
        }
    }
    else{
        //点击用户昵称
        if ([self.delegate respondsToSelector:@selector(dynamicBottomView:WithUserId:)]) {
            [self.delegate dynamicBottomView:self WithUserId:status];
        }
    }
}

@end
