//
//  CommentListViewController.m
//  Shitan
//
//  Created by 刘敏 on 15/2/2.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CommentListViewController.h"
#import "ProfileTableViewController.h"
#import "HimselfViewController.h"
#import "CommentDAO.h"
#import "CommentCell.h"
#import "CommentModle.h"
#import "HPGrowingTextView.h"
#import "MJRefresh.h"
#import "EmojiConvertor.h"


@interface CommentListViewController ()<HPGrowingTextViewDelegate, UITableViewDataSource, UITableViewDelegate, ZBMessageManagerFaceViewDelegate, ZBFaceViewDelegate>
{
    
    NSMutableDictionary *tempDict;  //存储临时信息
    
    BOOL   isSend;                  //是否在发送中
}

@property (nonatomic, strong) CommentDAO *dao;

@property (nonatomic, assign) NSInteger allComment;             //评论总条数
@property (nonatomic, assign) NSInteger mPage;                  //页数
@property (nonatomic, strong) HPGrowingTextView *textView;
@property (nonatomic, strong) EmojiConvertor *emojiCon;
@property (nonatomic, assign) BOOL isMore;                      //是否获取更多

@end

@implementation CommentListViewController

- (void)initDao
{
    if (!_dao) {
        self.dao = [[CommentDAO alloc] init];
    }
    
    tempDict = [[NSMutableDictionary alloc] init];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [MobClick beginLogPageView:@"评论"];
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePasteAction:)
                                                 name:HPGrowingTextViewPastedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"评论"];
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HPGrowingTextViewPastedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self getCommentList:_mPage];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSend = YES;

    [self setNavBarTitle:@"评论"];
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self  initDao];
    
    [self setExtraCellLineHidden:self.tableView];

    
    //评论数组
    _commentArray = [[NSMutableArray alloc] init];
    
    //表情转码
    self.emojiCon = [[EmojiConvertor alloc] init];
    
    //初始页数
    _mPage = 1;
    [self getCommentList:_mPage];

    [self initUI];
    
    //弹出键盘
    if (_isPopKeyboard) {
        [self.textView.internalTextView becomeFirstResponder];
    }
    
    [self setupRefresh];
}

- (void)initUI
{
    CGFloat height = isIOS8 ? 44.0f:64.0f;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height-height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
    [self.view addSubview:self.tableView];
    
    [self setExtraCellLineHidden:self.tableView];
    
    [self initInputBox];
}



- (void)initInputBox
{
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    
    UIImageView *lineV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_line"]];
    [lineV setFrame:CGRectMake(0, 0, MAINSCREEN.size.width, 1)];
    [self.containerView addSubview:lineV];
    
    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(50, 6, MAINSCREEN.size.width-120, 24)];
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.textView.minNumberOfLines = 1;
    self.textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    self.textView.returnKeyType = UIReturnKeySend; //just as an example
    self.textView.font = [UIFont systemFontOfSize:14.0f];
    self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.placeholder = @"发表评论";
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.masksToBounds = YES;
    
    [self.containerView addSubview:self.textView];
    
    _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_faceButton setFrame:CGRectMake(8, 6, 32, 32)];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"send_face"] forState:UIControlStateNormal];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"send_keyboard"] forState:UIControlStateSelected];
    [_faceButton addTarget:self action:@selector(faceBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:_faceButton];
    
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(MAINSCREEN.size.width-60, 8, 54, 29)];
    
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:_sendButton];
    
    _sendButton.layer.cornerRadius = 4;
    _sendButton.layer.masksToBounds = YES;
    [_sendButton setBackgroundImage:@"btn38_red.png" setSelectedBackgroundImage:@"btn38_grey.png"];
    
    UIColor *borderColor = [UIColor colorWithRed:0.9176 green:0.9176 blue:0.9176 alpha:1];
    self.containerView.layer.borderColor = [borderColor CGColor];
    self.textView.layer.borderColor = [borderColor CGColor];
    
}

//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (void)sendBtnTapped:(id)sender{
    
    if (self.textView.text.length == 0) {
        MET_MIDDLE(@"评论不能为空");
        return;
    }
    
    if (tempDict.count > 0) {
        if (isSend ) {
            [self sendMessage:tempDict];
            isSend = NO;
        }
    }
    else{
        //评论者ID
        [tempDict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"commentUserId"];
        
        //TODO:被评论者ID（有可能是回复评论）
        [tempDict setObject:_userID forKey:@"commentedUserId"];
        
        if (isSend ) {
            [self sendMessage:tempDict];
            isSend = NO;
        }
    }
}



- (void)faceBtnTapped:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        CLog(@"表情");
        
        [_textView.internalTextView resignFirstResponder];
        [self showFaceView];
    }
    else{
        //显示键盘，隐藏表情
        [self hideFaceView];
        [_textView.internalTextView becomeFirstResponder];
        
    }
}

#pragma mark -ZBMessageManagerFaceViewDelegate
//点击表情
- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele{
    
    if(dele)
    {
        //删除末尾[xx]字符
        NSUInteger flength = faceStr.length;
        NSUInteger allLength = _textView.text.length;
        
        if (faceStr) {
            if ([_textView.text hasSuffix:faceStr]) {
                //删除表情
                _textView.text = [_textView.text substringWithRange:NSMakeRange(0, allLength- flength)];
                [self.faceView.eArray removeLastObject];
            }
            else{
                if ([_textView.text length] > 0) {
                    _textView.text = [_textView.text substringWithRange:NSMakeRange(0, allLength - 1)];
                }
            }
        }
        else
        {
            CLog(@"删除普通字符");
            if ([_textView.text length] > 0) {
                _textView.text = [_textView.text substringWithRange:NSMakeRange(0, allLength - 1)];
            }
            
        }

    }
    else
        _textView.text = [_textView.text stringByAppendingString:faceStr];
        
}


//获取评论列表
- (void)getCommentList:(NSInteger)page
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    //图片ID
    [dic setObject:_imageID forKey:@"imgId"];
    //页数
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    //每页的条数（默认20条）
    [dic setObject:[NSNumber numberWithInteger:20] forKey:@"size"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_dao getCommentsPlist:requestDict
           completionBlock:^(NSDictionary *result)
     {
         if ([[result objectForKey:@"code"] integerValue] == 200 ) {
             
             if ([result objectForKey:@"obj"]) {
                 NSDictionary *dic = [result objectForKey:@"obj"];
                 _allComment = [[dic objectForKey:@"count"] integerValue];

                 NSArray *temp = [dic objectForKey:@"comments"];
                 
                 if (page == 1) {
                     [_commentArray removeAllObjects];
                 }
                 
                 [_commentArray addObjectsFromArray:temp];
                 [_tableView reloadData];
                 
                _mPage ++;
                 
                 
                 if (page == 1) {
                     if (_commentArray.count > 0) {
//                         NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:_commentArray.count-1 inSection:0];
//                         [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
//                                                 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                     }
                     
                 }
                 
             }
         }
         else
         {
             MET_MIDDLE([result objectForKey:@"msg"]);
         }
         
     }
            setFailedBlock:^(NSDictionary *result)
     {
         
     }];
    
    [self.tableView.header endRefreshing];
}




#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentInfo *comInfo = [[CommentInfo alloc] initWithParsData:[_commentArray objectAtIndex:(_commentArray.count -indexPath.row)-1]];
    CommentCell *cell = [CommentModle findCellWithTableView:tableView];
    
    return [cell setCellWithCellInfo:comInfo cellWithRow:indexPath.row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [CommentModle findCellWithTableView:tableView];
    cell.controller = self;
    
    //解析成数据模型
    CommentInfo *comInfo = [[CommentInfo alloc] initWithParsData:[_commentArray objectAtIndex:(_commentArray.count -indexPath.row)-1]];
    [cell setCellWithCellInfo:comInfo cellWithRow:indexPath.row];
    
    return cell;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //解析成数据模型
    CommentInfo *comInfo = [[CommentInfo alloc] initWithParsData:[_commentArray objectAtIndex:(_commentArray.count -indexPath.row)-1]];
    
    NSMutableDictionary *components = [[NSMutableDictionary alloc] initWithCapacity:2];
    [components setObject:comInfo.commentUserId forKey:@"commentedUserId"];
    [components setObject:comInfo.commentUserNickname forKey:@"commentedUserNickname"];
    
    [self postCommentWithInfo:components commentID:comInfo.commentId];
}


// 发布者头像点击
- (void)jumpToUserInfo:(NSString *)userID isComments:(BOOL)isComments
{
    //图片发布者
    if (!isComments) {
        if ([userID isEqualToString:[AccountInfo sharedAccountInfo].userId]) {
            ProfileTableViewController *hVC = [[ProfileTableViewController alloc] init];
            hVC.isFromTabbar = NO;
            hVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hVC animated:YES];
        }
        else{
            
            UIStoryboard *MineStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
            HimselfViewController *hVC = [MineStoryboard instantiateViewControllerWithIdentifier:@"HimselfViewController"];
            hVC.respondentUserId = userID;
            hVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hVC animated:YES];
        }
    }
    else{
        //图片评论者
        if ([userID isEqualToString:[AccountInfo sharedAccountInfo].userId]) {
            ProfileTableViewController *hVC = [[ProfileTableViewController alloc] init];
            hVC.isFromTabbar = NO;
            hVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hVC animated:YES];
        }
        else{
            
            UIStoryboard *MineStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
            HimselfViewController *hVC = [MineStoryboard instantiateViewControllerWithIdentifier:@"HimselfViewController"];
            hVC.respondentUserId = userID;
            hVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hVC animated:YES];
        }
    }
}

#pragma mark 执行通知
- (void) keyboardWillShow:(NSNotification*)note
{
    [self hideFaceView];
    _faceButton.selected = NO;
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    
    CGRect containerFrame = _containerView.frame;

    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _containerView.frame = containerFrame;
    CLog(@"%02f, %02f", containerFrame.origin.y, self.tableView.frame.origin.y);
    
    
    
    self.tableView.frame = CGRectMake(0.0f, self.tableView.frame.origin.y, MAINSCREEN.size.width, containerFrame.origin.y);
    
    
    // commit animations
    [UIView commitAnimations];
    
    
    if([self.commentArray count] > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.commentArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


- (void) keyboardWillHide:(NSNotification*)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _containerView.frame = containerFrame;
    CLog(@"输入框高度： %02f", self.containerView.frame.size.height);
    CGFloat height = isIOS8 ? 44.0f:64.0f;
    self.tableView.frame = CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height-height);
    // commit animations
    [UIView commitAnimations];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textView.internalTextView resignFirstResponder];
    
    [self hideFaceView];
    [self clearData];
}


- (void)handlePasteAction:(NSNotification *)notification {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    if (pboard.image) {
        
    }else if (pboard.string && pboard.string.length){
        NSString *currentStr = self.textView.text;
        if (currentStr && currentStr.length) {
            self.textView.text = [currentStr stringByAppendingString:pboard.string];
        }else{
            self.textView.text = pboard.string;
        }
    }
}

//回复评论
- (void)postCommentWithInfo:(NSDictionary *)dict commentID:(NSString *)commentId
{
    if ([[dict objectForKey:@"commentedUserId"] isEqualToString:[AccountInfo sharedAccountInfo].userId]) {
        MET_MIDDLE(@"不能评论自己");
        return;
    }
    
    //评论者ID(当前登录用户)
    [tempDict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"commentUserId"];
    
    //TODO:被评论者ID（发表这条评论的人）
    [tempDict setObject:[dict objectForKey:@"commentedUserId"] forKey:@"commentedUserId"];
    
    
    //parentCommentId(父评论ID)
    [tempDict setObject:commentId forKey:@"parentCommentId"];
    
    [tempDict setObject:[dict objectForKey:@"commentedUserNickname"] forKey:@"commentedUserNickname"];
    
    //弹出键盘
    [_textView.internalTextView becomeFirstResponder];
    self.textView.placeholder = [NSString stringWithFormat:@"回复 %@", [dict objectForKey:@"commentedUserNickname"]];
    
    //重绘
    [self.textView.internalTextView setNeedsDisplay];
}



- (void)sendMessage:(NSDictionary *)dic{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];

    //只能删除首尾的空格和回车
    NSString *res = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //评论内容
    [dict setObject:[self.emojiCon convertEmojiUnicodeToSoftbank:res] forKey:@"content"];
    
    //图片ID
    [dict setObject:_imageID forKey:@"imgId"];
    
    [dict addEntriesFromDictionary:dic];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    //发送评论
    [_dao publishedCommentsWith:requestDict
                completionBlock:^(NSDictionary *result) {
                    if ([[result objectForKey:@"code"] integerValue] == 200 ) {
                        
                        _mPage = 1;
                        [self getCommentList:_mPage];
                        [self.textView.internalTextView resignFirstResponder];
                        [self hideFaceView];
                        
                        //清除数据
                        [self clearData];
                        
                        {
                           //封装评论数据
                            CommentInfo *cInfo = [[CommentInfo alloc] init];
                            
                            cInfo.parentCommentId = [tempDict objectForKeyNotNull:@"parentCommentId"];
                            cInfo.commentUserId = [AccountInfo sharedAccountInfo].userId;
                            cInfo.commentUserNickname  = [AccountInfo sharedAccountInfo].nickname;
                            cInfo.commentUserPortraitUrl = [AccountInfo sharedAccountInfo].portraiturl;
                            cInfo.commentedUserId = [tempDict objectForKeyNotNull:@"commentedUserId"];
                            cInfo.commentedUserNickname = [tempDict objectForKeyNotNull:@"commentedUserNickname"];
                            cInfo.content = self.textView.text;
                            cInfo.imgId = _imageID;
                            cInfo.createTime = [Units getNowTime];
                            
                            [self updateCommentsWithDynamic:cInfo];
                            
                        }
                        
                        //发送评论：
                        self.textView.text = @"";
                        [tempDict removeAllObjects];
                    }
                    else
                    {
                        MET_MIDDLE([result objectForKey:@"msg"]);
                    }
                    
                    isSend = YES;
                }
                 setFailedBlock:^(NSDictionary *result) {
                     isSend = YES;
                 }];
    
}


//清除数据
- (void)clearData
{
    if ([self.textView.text length] == 0) {
        
        self.textView.placeholder = @"发表评论";
        //重绘
        [self.textView.internalTextView setNeedsDisplay];
        [tempDict removeAllObjects];
    }
}



- (void)updateCommentsWithDynamic:(CommentInfo *)cInfo
{
    
    cInfo.mRow = _mRow;
    
    if (_mType == QualityType) {
        //精选
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QUALITY_COMMENTS_UPDATE" object:cInfo];
    }
    else if(_mType == FocusDYType)
    {
        //关注
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ST_COMMENTS_UPDATE" object:cInfo];
    }
    else if(_mType == CityDYType)
    {
        //最新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEW_COMMENTS_UPDATE" object:cInfo];
    }
    else if(_mType == SpecialType)
    {
        //专题活动
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SPECIAL_COMMENTS_UPDATE" object:cInfo];
    }
}


//创建表情view
- (void)shareFaceView{

    self.faceView = [[ZBMessageManagerFaceView alloc] initWithFrame:
                     CGRectMake(0.0f,CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 216)];//216-->196
    self.faceView.delegate = self;
    [self.view addSubview:self.faceView];

}

//显示表情
- (void)showFaceView
{
    if (!self.faceView)
    {
        [self shareFaceView];
    }
    
    CGRect expressionFrame = self.faceView.frame;
    
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (expressionFrame.size.height + containerFrame.size.height);
    
    expressionFrame.origin.y = self.view.bounds.size.height - expressionFrame.size.height;
    
    //animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //set views with new info
    self.containerView.frame = containerFrame;
    self.faceView.frame = expressionFrame;
    
    self.tableView.frame = CGRectMake(0.0f, self.tableView.frame.origin.y, MAINSCREEN.size.width, containerFrame.origin.y);
    
    //commit animations
    [UIView commitAnimations];
    
    if([self.commentArray count] > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.commentArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


//隐藏
- (void)hideFaceView
{
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    CGRect expressionFrame = self.faceView.frame;
    expressionFrame.origin.y = self.view.bounds.size.height;
    
    //animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    
    //set view with new info
    self.containerView.frame = containerFrame;
    self.faceView.frame = expressionFrame;
    CGFloat height = isIOS8 ? 44.0f:64.0f;
    self.tableView.frame = CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height-height);
    
    //commit animations
    [UIView commitAnimations];
}


#pragma mark - HPGrowingTextView delegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    CLog(@"%@", growingTextView.text);
    float diff = (growingTextView.frame.size.height - height);
    
    // 改变输入框的高度
    CGRect r = self.containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.containerView.frame = r;
    CLog(@"输入框高度： %02f", self.containerView.frame.size.height);
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height += diff;
    self.tableView.frame = tableFrame;
    
    if (self.commentArray.count>0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.commentArray.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

    CLog(@"输入框高度： %02f", self.containerView.frame.size.height);
}


- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView{
    
    CLog(@"Begin TextView:%@", growingTextView.text);
    
    //显示
    return YES;
}



- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //发送按钮事件
    if ([text isEqualToString:@"\n"] && [[growingTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        [self sendBtnTapped:nil];
        return NO;
    }
    
    NSInteger textLength = self.textView.text.length;
    NSInteger replaceLength = text.length;
    
    if ( (textLength + replaceLength) >= 251)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"内容最多为250" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        return NO;
    }
    
    if (replaceLength == 0 && textLength > 0) {
        
        //删除字符肯定是安全的(表情整个删除)
        if ([self.faceView.eArray count] > 0) {
            NSString *faceN = [self.faceView.eArray objectAtIndex:self.faceView.eArray.count-1];
            if ([_textView.text hasSuffix:faceN]) {
                //删除表情
                _textView.text = [_textView.text substringWithRange:NSMakeRange(0, _textView.text.length- faceN.length+1)];
                [self.faceView.eArray removeLastObject];
            }
        }
        
        return YES;
    }
    
    return YES;
}


@end
