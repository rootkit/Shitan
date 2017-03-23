//
//  ResultItemViewController.m
//  Shitan
//
//  Created by RichardLiu on 15/4/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ResultItemViewController.h"
#import "TipsConTableViewCell.h"
#import "TipsConModel.h"
#import "ShopMapViewController.h"
#import "QueryDAO.h"
#import "DynamicTableViewCell.h"
#import "DynamicCellModel.h"
#import "MLEmojiLabel.h"

#import "MenuTableViewCell.h"
#import "MenuCellModel.h"
#import "ResultImagesModel.h"
#import "ResultsImageTableViewCell.h"

#import "UserListViewController.h"
#import "ProfileTableViewController.h"
#import "HimselfViewController.h"
#import "CommentListViewController.h"
#import "CollectionTypeViewController.h"

#import "SGActionView.h"
#import "ShareModel.h"
#import "ImageDAO.h"

#define  OFFSET_X_LEFT      30      //评论或者赞（文字距离左侧的距离）
#define  OFFSET_X_RIGHT     12

@interface ResultItemViewController ()

@property (nonatomic, strong) QueryDAO *dao;
@property (nonatomic, strong) ImageDAO *mDao;

@property (nonatomic, strong) NSArray *dArray;    //单品数据（动态模型）

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isLeft;

//分享
@property (nonatomic, strong) NSArray *openArray;
@property (nonatomic, strong) NSArray *openImageArray;


@end

@implementation ResultItemViewController

- (void)initDao
{
    if (!_dao) {
        self.dao = [[QueryDAO alloc] init];
    }
    
    if (!self.mDao) {
        self.mDao = [[ImageDAO alloc] init];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"单品图片列表"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"单品图片列表"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isFirst = NO;
    _isLeft = YES;
    if (_sInfo.addressName && _sInfo.branchName.length > 1) {
        [self setNavBarTitle:[NSString stringWithFormat:@"%@（%@）", _sInfo.addressName, _sInfo.branchName]];
    }
    else{
        [self setNavBarTitle:_sInfo.addressName];
    }
    
    
    
    _tableView.backgroundColor = BACKGROUND_COLOR;

    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self initDao];
    
    //获取店铺中该单品的图片
    [self requestAddressTagNameTagImgs];
}


//某个店铺的某道菜
- (void)requestAddressTagNameTagImgs
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:4];
    if (_sInfo.addressId) {
        [dic setObject:_sInfo.addressId forKey:@"addressId"];
    }
    
    [dic setObject:[NSNumber numberWithInteger:20] forKey:@"size"];
    [dic setObject:_itemInfo.nameId forKey:@"nameId"];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKeyedSubscript:@"userId"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_dao QueryAddressTagNameTagImgs:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            if ([[result objectForKeyNotNull:@"obj"] count] > 0) {
                self.dArray = [self parsItemInfo:[result objectForKeyNotNull:@"obj"]];
                [_tableView reloadData];
            }
            
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
    
    
}


//解析单品图片
- (NSArray *)parsItemInfo:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in array) {
        DynamicInfo *dInfo = [[DynamicInfo alloc] initWithParsData:item];
        [tempArray addObject:dInfo];
    }
    
    return tempArray;
}



//店铺中的其他菜
- (void)requestListOther
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:4];
    if (_sInfo.addressId) {
        [dic setObject:_sInfo.addressId forKey:@"addressId"];
    }
    
    [dic setObject:_itemInfo.nameId forKey:@"excludedNameId"];
    
    [dic setObject:[NSNumber numberWithInteger:1] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:20] forKey:@"size"];
    
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_dao QueryListOther:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            if ([[result objectForKeyNotNull:@"obj"] count] > 0) {
                self.imageArray = [self parsItemImageInfo:[result objectForKeyNotNull:@"obj"]];
                [_tableView reloadData];
            }
            
        }
        
        _isFirst = YES;
        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}


//解析单品图片
- (NSArray *)parsItemImageInfo:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in array) {
        ItemInfo *tInfo = [[ItemInfo alloc] initWithParsData:item];
        [tempArray addObject:tInfo];
    }
    
    return tempArray;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        //有均价
        if ([_sInfo.avgPrice floatValue] > 0.1) {
            return 3;
        }
        
        return 2;
    }
    if (section == 1) {

        return 1;
    }
    else
    {
        if (_isLeft) {
            return [_dArray count];
        }
        else{
            return 1;
        }
    }
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    else if(indexPath.section == 1){
        return 56;
    }
    else if(indexPath.section == 2){
        
        if (_isLeft) {
            if ([self.dArray count] > 0) {
                
                return [self setCellWithCellInfo:[self.dArray objectAtIndex:indexPath.row]];
            }
            
            return 0;
        }
        else{
            //计算cell的高度
            NSUInteger mx = _imageArray.count/2;
            NSUInteger my = _imageArray.count%2;
            
            //单个图片宽度
            CGFloat singleW = (MAINSCREEN.size.width -16*3)/2;
            //总高度
            CGFloat s_high = (singleW+16) *(mx + my) + 16;
            //顶部高度55
            return s_high;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TipsConTableViewCell *tipCell = [TipsConModel findCellWithTableView:tableView];
        [tipCell setCellWithCellInfo:_sInfo setRow:indexPath.row];
        tipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tipCell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        if (indexPath.row == 2) {
            tipCell.accessoryType = UITableViewCellAccessoryNone;
            tipCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return tipCell;
    }
    else if(indexPath.section == 1)
    {
        MenuTableViewCell *mCell = [MenuCellModel findCellWithTableView:tableView];
        [mCell setCellWithCellName:_itemInfo.name setLeftBtn:_isLeft];
        mCell.controller = self;
        return mCell;
    }
    else if (indexPath.section == 2){
        if (_isLeft) {
            DynamicTableViewCell *cell = [DynamicCellModel findCellWithTableView:tableView];
            cell.rVC = self;
            cell.tipsVC = nil;
            cell.iVC = nil;
            cell.sVC = nil;
            
            if ([_dArray count] > 0)
            {
                DynamicInfo *dInfo = [_dArray objectAtIndex:indexPath.row];
                if (dInfo) {
                    [cell setCellWithCellInfo:dInfo isShowfocusButton:NO];
                }
            }
            return cell;
        }
        else{
            ResultsImageTableViewCell *imageCell = [ResultImagesModel findCellWithTableView:tableView];
            imageCell.itemController = self;
            imageCell.controller = nil;
            
            [imageCell setCellWithCellInfo:_imageArray isHideHead:YES];
            return imageCell;
        }

    }
    return nil;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
            ShopMapViewController *tVC = [board instantiateViewControllerWithIdentifier:@"ShopMapViewController"];
            tVC.sInfo = _sInfo;
            
            [self.navigationController pushViewController:tVC animated:YES];
        }
        else if(indexPath.row == 1)
        {
            //拨打电话
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",_sInfo.phone];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
    }
}


#pragma mark - 计算动态行高
 /******************************************计算高度 *****************************************/
// 赋值
- (CGFloat)setCellWithCellInfo:(DynamicInfo *)d_Info
{
    CGFloat m_hight = 60 + MAINSCREEN.size.width;   //顶部高度跟图片高度
    
    /****************************************  图片描述    ***********************************************/
    if ([d_Info.imgDesc length] > 0) {
        //底部view距离图片的高度
        CLog(@"%02f", [self calculateDesLabelheight:m_hight desLabel:d_Info.imgDesc]);
        m_hight += [self calculateDesLabelheight:m_hight desLabel:d_Info.imgDesc];
    }
    
    /**************************************   赞过得用户列表   *******************************************/
    if(d_Info.praiseCount > 0)
    {
        CLog(@"%02f", [self setPraise:d_Info.persInfo currentHeight:m_hight]);
        m_hight += [self setPraise:d_Info.persInfo currentHeight:m_hight];
    }
    
    /**************************************   评论列表   *******************************************/
    if (d_Info.commentCount > 0) {
        
        CLog(@"%02f", [self setComments:d_Info.comInfo imageAuthor:d_Info.userId currentHeight:m_hight commentsNum:d_Info.commentCount]);
        m_hight +=  [self setComments:d_Info.comInfo imageAuthor:d_Info.userId currentHeight:m_hight commentsNum:d_Info.commentCount];
    }
    
    return m_hight+12+45+5+15 +20;
}

// 计算DesLabl的高度
- (CGFloat)calculateDesLabelheight:(CGFloat)height desLabel:(NSString *)text
{
    
    MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
    praisLabel.numberOfLines = 0;
    praisLabel.font = [UIFont systemFontOfSize:14.0f];
    praisLabel.textAlignment = NSTextAlignmentLeft;
    praisLabel.emojiText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    praisLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    praisLabel.customEmojiPlistName = @"expression";
    
    CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_RIGHT*2];
    
    if (size.height > 0.0) {
        return size.height + 15.0;
    }
    
    return 0.0;
}

//设置赞
- (CGFloat)setPraise:(NSArray *)cArray currentHeight:(CGFloat)mHeight
{
    MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
    praisLabel.numberOfLines = 0;
    praisLabel.font = [UIFont systemFontOfSize:14.0f];
    praisLabel.textAlignment = NSTextAlignmentLeft;
    
    //排序（以时间降序排列）
    NSSortDescriptor *sorter  = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sorter count:1];
    //排列后的数组（时间从小到大排列）
    NSMutableArray *sortArray = [[NSMutableArray alloc] initWithArray:[cArray sortedArrayUsingDescriptors:sortDescriptors]];
    //倒序
    sortArray = (NSMutableArray *)[[sortArray reverseObjectEnumerator] allObjects];
    
    if ([sortArray count] > 9) {
        praisLabel.emojiText = [NSString stringWithFormat:@"共%lu人赞过", (unsigned long)sortArray.count];
    }
    else{
        NSMutableArray * nickArray = [[NSMutableArray alloc] init];
        for (PraiseInfo *pInfo in cArray) {
            [nickArray addObject:pInfo.nickName];
        }
        praisLabel.emojiText = [nickArray componentsJoinedByString:@"，"];
    }
    
    CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
    
    if (size.height > 0.0) {
        return size.height + 12.0;
    }
    
    return 0.0;
}

//设置评论
- (CGFloat)setComments:(NSArray *)cArray
           imageAuthor:(NSString *)authorID
         currentHeight:(CGFloat)mHeight
           commentsNum:(NSUInteger)mCount
{
    NSInteger i = 0;
    CGFloat tempHeight = 0.0;
    
    //查看更多评论
    for(CommentInfo *cInfo in cArray)
    {
        MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
        praisLabel.numberOfLines = 0;
        praisLabel.font = [UIFont systemFontOfSize:14.0f];
        praisLabel.textAlignment = NSTextAlignmentLeft;
        praisLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        praisLabel.customEmojiPlistName = @"expression";
        
        NSString *tempS = @"";
        
        if (!cInfo.parentCommentId || [cInfo.commentedUserId isEqualToString:cInfo.commentUserId]) {
            tempS = [NSString stringWithFormat:@"%@: %@", cInfo.commentUserNickname, cInfo.content];
            
            praisLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
            
            tempHeight += size.height+4;
        }
        else
        {
            MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
            praisLabel.numberOfLines = 0;
            praisLabel.font = [UIFont systemFontOfSize:14.0f];
            praisLabel.textAlignment = NSTextAlignmentLeft;
            praisLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
            praisLabel.customEmojiPlistName = @"expression";
            
            tempS = [NSString stringWithFormat:@"%@ 回复 %@: %@", cInfo.commentUserNickname, cInfo.commentedUserNickname, cInfo.content];
            
            praisLabel.emojiText = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
            
            tempHeight += size.height+4;
        }
        
        CLog(@"%@", tempS);
        i++;
    }
    
    if(mCount > 4)
    {
        MLEmojiLabel *praisLabel = [[MLEmojiLabel alloc] init];
        praisLabel.numberOfLines = 0;
        praisLabel.font = [UIFont systemFontOfSize:14.0f];
        praisLabel.textAlignment = NSTextAlignmentLeft;
        
        praisLabel.emojiText = [NSString stringWithFormat:@"查看全部 %ld 条评论", (long)mCount];
        
        CGSize size = [praisLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - OFFSET_X_LEFT  - OFFSET_X_RIGHT];
        
        tempHeight += size.height;
    }

    if (tempHeight > 0.0) {
        return 15+ tempHeight;
    }
    
    return 0.0;
}



- (void)leftButton:(BOOL)mLeft
{
    _isLeft = mLeft;
    if(!_isFirst)
    {
        [self requestListOther];
    }
    else{
        [_tableView reloadData];
    }
}

//点击
- (void)imgaeHeadTapped:(NSString *)userID
{
    //自己就跳转到
    if ([userID isEqualToString:[AccountInfo sharedAccountInfo].userId]) {
        UIStoryboard *MineStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
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



//标签点击
- (void)clickBubbleViewWithInfo:(BubbleView *)bubleV shopWithInfo:(ShopInfo *)sInfo
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    TipsDetailsViewController *tVC = [board instantiateViewControllerWithIdentifier:@"TipsDetailsViewController"];
    tVC.bubbleV = bubleV;
    tVC.shopInfo = sInfo;
    
    NSLog(@"%@~~~~~~~~~~",sInfo.addressName);
    
//    ResultItemViewController *rVC =  (ResultItemViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"DynamicStoryboard" class:[ResultItemViewController class]];
//    
//    rVC.bubbleV = bubleV;
//    //rVC
    
    
    
    if (bubleV.tipType == Tip_Location) {
        tVC.isShowPlace = YES;
    }
    
    
    tVC.m_Type = FistTypeTips;
    
    
    tVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tVC animated:YES];
}


//关注
- (void)focusButtonTapped
{
//    self.isMore = NO;
    //    [self requestImagesList:_controller.cityN];
}

//喜欢(赞)
- (void)praiseButtonTapped
{
    [self requestAddressTagNameTagImgs];
}


//取消(赞)
- (void)cancelPraise
{
    [self requestAddressTagNameTagImgs];
}


//评论图片
- (void)commentsImage:(DynamicInfo *)dInfo
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    CommentListViewController *dVC = [board instantiateViewControllerWithIdentifier:@"CommentListViewController"];
    dVC.hidesBottomBarWhenPushed = YES;
    dVC.imageID = dInfo.imgId;
    dVC.userID = dInfo.userId;
    dVC.isPopKeyboard = YES;
    
    //入口来源
    dVC.mType = OtherType;
    
    [self.navigationController pushViewController:dVC animated:YES];
}

//收藏
- (void)collectionTypeChoose:(DynamicInfo *)dInfo
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    
    CollectionTypeViewController *coVC = [board instantiateViewControllerWithIdentifier:@"CollectionTypeViewController"];
    
    coVC.imageId = dInfo.imgId;
    coVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:coVC animated:NO];
}


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
    
    
    
    if ([_mInfo.userId isEqualToString:[AccountInfo sharedAccountInfo].userId])
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
    
    
    _openArray = tA;
    _openImageArray = tB;
}


//更多
- (void)moreButtonTapped:(DynamicInfo *)dInfo
{
    _mInfo = dInfo;
    
    [self summarizeShareData];

    
    [SGActionView sharedActionView].style = SGActionViewStyleLight;
    [SGActionView showGridMenuWithTitle:nil
                             itemTitles:_openArray
                                 images:_openImageArray
                         selectedHandle:^(NSInteger index) {
                             [self didClickOnImageIndex:index];
                         }];
    
}

- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    if (imageIndex == 0)
    {
        return;
    }
    
    
    NSString *description = @"美食推荐";
    
    NSArray *tagsArray = _mInfo.tags;
    
    if (_mInfo.tags != nil) {
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
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=QQ&uid=%@",_mInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:_mInfo.imgUrl]]];
        
        [[ShareModel getInstance] qqFriendsShareMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"QQ空间"]) {
        //QQ空间
        //分享跳转URL
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=Qzone&uid=%@",_mInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:_mInfo.imgUrl]]];
        
        [[ShareModel getInstance] qqZoneShareMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"微信好友"]) {
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=Weixin&uid=%@",_mInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:_mInfo.imgUrl]]];
        
        [[ShareModel getInstance] wechatFriendsMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"微信朋友圈"]) {
        NSString *url = [URL_Domain stringByAppendingString:[NSString stringWithFormat:@"/photo/details/?imgId=%@&strform=Weixin&uid=%@",_mInfo.imgId,[AccountInfo sharedAccountInfo].userId]];
        //图片DATA
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Units foodImage200Thumbnails:_mInfo.imgUrl]]];
        
        [[ShareModel getInstance] wechatCircleMessageWithUrl:url thumbnail:imageData describe:description title:nil];
    }
    
    if ([name isEqualToString:@"删除"]) {
        //删除图片
        [self deleteImage];
    }
    
    if ([name isEqualToString:@"举报"]) {
        //举报
        [self reportImage];
    }
    
    if ([name isEqualToString:@"隐藏"]) {
        //隐藏图片
        [self hideImage];
    }

}


//隐藏图片
- (void)hideImage
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:_mInfo.imgId forKey:@"imgId"];
    [dic setObject:_mInfo.userId forKey:@"userId"];
    
    [_mDao requestHideImage:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            //获取店铺中该单品的图片
            [self requestAddressTagNameTagImgs];
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
    [dic setObject:_mInfo.imgId forKey:@"imgId"];
    [dic setObject:_mInfo.userId forKey:@"userId"];
    
    [_mDao requestDeleteImage:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200 ) {
            //刷新
            [self requestAddressTagNameTagImgs];
            
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
    [dic setObject:_mInfo.imgId forKey:@"imgId"];
    [dic setObject:_mInfo.userId forKey:@"userId"];
    
    [_mDao requestReportPic:dic completionBlock:^(NSDictionary *result) {
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

//评论列表
- (void)loadCommentListView:(NSString *)imageID imageReleasedID:(NSString *)userID;
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    CommentListViewController *dVC = [board instantiateViewControllerWithIdentifier:@"CommentListViewController"];
    dVC.hidesBottomBarWhenPushed = YES;
    dVC.imageID = imageID;
    dVC.userID = userID;
    
    //入口来源
    dVC.mType = OtherType;
    
    [self.navigationController pushViewController:dVC animated:YES];
}


//解析数据
- (NSArray *)parisDataWithArray:(NSArray *)array
{
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSDictionary *item in array) {
        DynamicInfo *dInfo = [[DynamicInfo alloc] initWithParsData:item];
        [tempA addObject:dInfo];
    }
    
    return tempA;
}



//图片赞列表
- (void)imagePraisList:(NSString *)imageId
{
    UIStoryboard *mineStroyboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    UserListViewController *userListVC = [mineStroyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];
    
    userListVC.respondentUserId = [AccountInfo sharedAccountInfo].userId;
    userListVC.hidesBottomBarWhenPushed = YES;
    userListVC.userListType = PraiseList;
    userListVC.imageId = imageId;
    
    [self.navigationController pushViewController:userListVC animated:YES];
}

- (void)imageBtnTapped:(ItemInfo *)tInfo
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"DynamicStoryboard" bundle:nil];
    ResultItemViewController *dVC = [board instantiateViewControllerWithIdentifier:@"ResultItemViewController"];
    dVC.itemInfo = tInfo;
    dVC.sInfo = _sInfo;
    [self.navigationController pushViewController:dVC animated:YES];
}



@end
