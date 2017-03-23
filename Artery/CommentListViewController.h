//
//  CommentListViewController.h
//  Shitan
//
//  Created by 刘敏 on 15/2/2.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "CommentInfo.h"
#import "ZBMessageManagerFaceView.h"

@interface CommentListViewController : STChildViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, strong) NSString *imageID;       //图片ID
@property (nonatomic, strong) NSString *userID;        //图片发布者ID


@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, assign) BOOL isPopKeyboard;       //是否弹出键盘

@property (nonatomic, assign) STCommntEntranceType mType;  //入口来源

@property (nonatomic, strong) ZBMessageManagerFaceView *faceView;
@property (nonatomic, assign) NSUInteger mRow;


//发布者头像点击（是否是评论者的头像）
- (void)jumpToUserInfo:(NSString *)userID isComments:(BOOL)isComments;

- (void)postCommentWithInfo:(NSDictionary *)dict commentID:(NSString *)commentId;

@end
