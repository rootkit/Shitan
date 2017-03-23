//
//  DynamicModelFrame.h
//  Shitan
//
//  Created by Richard Liu on 15/4/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLEmojiLabel.h"
#import "DynamicInfo.h"

@interface DynamicModelFrame : NSObject

@property (nonatomic, strong) DynamicInfo *dInfo;

@property (nonatomic, assign) CGRect headViewFrame;         //头部View
@property (nonatomic, assign) CGRect headVFrame;            //头像
@property (nonatomic, assign) CGRect memberFrame;           //大V标示
@property (nonatomic, assign) CGRect nameLabelFrame;        //用户昵称
@property (nonatomic, assign) CGRect timeLabelFrame;        //时间
@property (nonatomic, assign) CGRect focusButtonFrame;      //关注

@property (nonatomic, assign) CGRect contenViewFrame;
@property (nonatomic, assign) CGRect imageViewFrame;
@property (nonatomic, assign) CGRect starBarFrame;
@property (nonatomic, assign) CGRect starLabelFrame;
@property (nonatomic, assign) CGRect desLabelFrame;

@property (nonatomic, assign) CGRect bottomViewFrame;
@property (nonatomic, assign) CGRect praiseVFrame;
@property (nonatomic, assign) CGRect commentVFrame;
@property (nonatomic, assign) CGRect praiseLabelFrame;
@property (nonatomic, assign) CGRect commentLabelFrame;
@property (nonatomic, assign) CGRect lineViewFrame;

@property (nonatomic, strong) MLEmojiLabel *desLabel;

@property (nonatomic, assign) CGRect toolsFrame;
@property (nonatomic, assign) CGRect praiseButtonFrame;
@property (nonatomic, assign) CGRect commentButtonFrame;
@property (nonatomic, assign) CGRect collectionButtonFrame;

@property (nonatomic, assign) CGRect moreButtonFrame;

@property (nonatomic, assign) CGFloat rowHeight;    //cell高度

@end
