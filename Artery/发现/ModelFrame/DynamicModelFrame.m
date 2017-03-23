//
//  DynamicModelFrame.m
//  Shitan
//
//  Created by Richard Liu on 15/4/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "DynamicModelFrame.h"
#import "DynamicInfo.h"
#import "MLEmojiLabel.h"

#define kMarginH 10
#define kMarginV 10

#define kHeadVHeight 40
#define kHeadVWidth kHeadVHeight

#define kTOPHeight 60

#define kHeadVX 10
#define kHeadVY 10

#define kNameWidth 175
#define kNameHeight 20

#define kTimeWidth 90
#define kTimeHeight 10

#define kStarBarX (MAINSCREEN.size.width - 170)
#define kStarLabelX (MAINSCREEN.size.width - 50)

#define kToolBarWidth 45
#define kToolBarHeight 39
#define kToolMargin 25

#define kFocusWidth 50
#define kFocusHeight 23

#define OFFSET_X_RIGHT 12
#define OFFSET_X_LEFT 30

#define kBottomViewWidth 12
#define kBottomViewHeight 12
#define kBottomMargin 15    

#define kMemberViewWidth  kBottomMargin



#define PRAISE_MORE   @"PRAISE_MORE"        //赞多于x人
#define COMMENTS_MORE   @"COMMENTS_MORE"    //更多评论

@interface DynamicModelFrame ()<TTTAttributedLabelDelegate, MLEmojiLabelDelegate>

@end


@implementation DynamicModelFrame

- (void)setDInfo:(DynamicInfo *)dInfo{
    
    _dInfo = dInfo;
    
    [self setUpAllFrame];
    
}

- (void)setUpAllFrame{
    
    [self setUpHeadFrame];
    
    
    [self setUpContentFrame];
    
    
    [self setUpBottomViewFrame];
    
    
    [self setUpToolsFrame];
    
}

- (void)setUpHeadFrame{
    
    _headVFrame =  CGRectMake(kHeadVX , kHeadVY, kHeadVWidth , kHeadVHeight);
    
    CGFloat nameX = kMarginH * 2 + _headVFrame.size.width;
    CGFloat nameY = _headVFrame.origin.y;
    CGFloat nameW = kNameWidth;
    CGFloat nameH = kNameHeight;
    _nameLabelFrame =  CGRectMake(nameX , nameY, nameW , nameH);

    CGFloat timeX = _nameLabelFrame.origin.x;
    CGFloat timeY = _nameLabelFrame.origin.y + _nameLabelFrame.size.height + kMarginH-2;
    CGFloat timeW = kTimeWidth;
    CGFloat timeH = kTimeHeight;
    _timeLabelFrame =  CGRectMake(timeX, timeY, timeW , timeH);
    
    _focusButtonFrame = CGRectMake(MAINSCREEN.size.width - kMarginH * 6, kMarginV * 2, kFocusWidth, kFocusHeight);
    
    _headViewFrame = CGRectMake(0, 0, MAINSCREEN.size.width, kTOPHeight);
    
    _memberFrame = CGRectMake(OFFSET_X_LEFT+5, OFFSET_X_LEFT+5, kMemberViewWidth, kMemberViewWidth);
    
}

- (void)setUpContentFrame{
    
    _imageViewFrame =  CGRectMake(0, 0 , MAINSCREEN.size.width, MAINSCREEN.size.width);

    //星星
    _starBarFrame = CGRectMake(kStarBarX, CGRectGetMaxY(_imageViewFrame) + kMarginV, 100, 20);
    _starLabelFrame = CGRectMake(kStarLabelX, _starBarFrame.origin.y, 50, 20);
    
    if (self.dInfo.imgDesc.length > 0) {
        MLEmojiLabel *desLabel = [[MLEmojiLabel alloc]init];
        _desLabel = desLabel;
        _desLabel.emojiText = self.dInfo.imgDesc;
        CGSize textsize = [_desLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - kDesLabelMargin * 2];
        _desLabelFrame = CGRectMake(kDesLabelMargin, CGRectGetMaxY(_starBarFrame) + kMarginV , textsize.width , textsize.height);
    }
    
    _contenViewFrame = CGRectMake(0, CGRectGetMaxY(_headViewFrame), MAINSCREEN.size.width, _imageViewFrame.size.height + _desLabelFrame.size.height + _starBarFrame.size.height + kMarginV * ( self.dInfo.imgDesc.length > 0) + kMarginV);

}


- (void)setUpBottomViewFrame{
    
    //计算bottom的
    BOOL hasPraiseCount = NO;
    
    if(_dInfo.praiseCount > 0)
    {
        _praiseVFrame = CGRectMake(OFFSET_X_RIGHT, 3, kBottomViewWidth, kBottomViewHeight);
        hasPraiseCount = YES;
        
        CGFloat height = [self setPraise:self.dInfo.persInfo currentHeight:_praiseLabelFrame.origin.y];
        _praiseLabelFrame = CGRectMake(OFFSET_X_LEFT,0 , MAINSCREEN.size.width - OFFSET_X_LEFT - OFFSET_X_RIGHT, height);

    }
    
    if (_dInfo.commentCount > 0) {
        
        CGFloat height = [self setComments:self.dInfo.comInfo imageAuthor:self.dInfo.userId currentHeight:self.praiseLabelFrame.size.height + kBottomMargin];
        _commentLabelFrame = CGRectMake(OFFSET_X_RIGHT,self.praiseLabelFrame.size.height + 5 , MAINSCREEN.size.width - OFFSET_X_RIGHT - OFFSET_X_RIGHT, height);

    }
    _bottomViewFrame = CGRectMake(0, CGRectGetMaxY(_contenViewFrame) + kBottomMargin, MAINSCREEN.size.width, _praiseLabelFrame.size.height + _commentLabelFrame.size.height + 5 * ( self.dInfo.commentCount > 0));
    
}

- (void)setUpToolsFrame{
    
    _praiseButtonFrame =  CGRectMake( 0,  5, kToolBarWidth , kToolBarHeight);
    
    _commentButtonFrame =  CGRectMake(CGRectGetMaxX(_praiseButtonFrame) + kToolMargin,  5, kToolBarWidth , kToolBarHeight);
    
    _collectionButtonFrame =  CGRectMake(CGRectGetMaxX(_commentButtonFrame) + kToolMargin ,  5, kToolBarWidth , kToolBarHeight);
    
    _moreButtonFrame =  CGRectMake(MAINSCREEN.size.width - kMarginH * 6,  5, kToolBarWidth , kToolBarHeight);
    
    _lineViewFrame = CGRectMake(0, 43, MAINSCREEN.size.width, 17);
    
    _toolsFrame = CGRectMake(0, CGRectGetMaxY(_contenViewFrame) + kBottomMargin + _bottomViewFrame.size.height + (_bottomViewFrame.size.height != 0) * kBottomMargin, MAINSCREEN.size.width, 60);
    
    _rowHeight = CGRectGetMaxY(_toolsFrame);

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
    praisLabel.frame = CGRectMake(OFFSET_X_LEFT, mHeight, MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT, size.height);
    
    return size.height;
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
            
            CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_RIGHT  - OFFSET_X_RIGHT];
            
            praisLabel.frame = CGRectMake(OFFSET_X_RIGHT, mHeight+ tempHeight, MAINSCREEN.size.width - OFFSET_X_RIGHT  - OFFSET_X_RIGHT, size.height);
            
            //[self.bgroundView addSubview:praisLabel];
            
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
            
            CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_RIGHT  - OFFSET_X_RIGHT];
            
            praisLabel.frame = CGRectMake(OFFSET_X_RIGHT, mHeight+ tempHeight, MAINSCREEN.size.width - OFFSET_X_RIGHT  - OFFSET_X_RIGHT, size.height);
            
            //[self.bgroundView addSubview:praisLabel];
            
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
        
        CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_RIGHT  - OFFSET_X_RIGHT];
        
        praisLabel.frame = CGRectMake(OFFSET_X_RIGHT, mHeight+ tempHeight, MAINSCREEN.size.width - OFFSET_X_RIGHT  - OFFSET_X_RIGHT, size.height);
        
        tempHeight += size.height;
    }
    
    return tempHeight;
}

@end
