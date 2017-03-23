//
//  DraftBoxViewController.m
//  Shitan
//
//  Created by 刘敏 on 15/1/20.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "DraftBoxViewController.h"
#import "DraftModel.h"
#import "DraftTableViewCell.h"
#import "ImagesReleasedViewController.h"
#import "ImageDAO.h"
#import "PublishImage.h"

@interface DraftBoxViewController ()

@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) ImageDAO *dao;

@end

@implementation DraftBoxViewController

- (void)initDao
{
    if (!_dao) {
        self.dao = [[ImageDAO alloc] init];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateDraftBox];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"草稿箱"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"草稿箱"];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDao];
    
    // 注册通知(更新草稿箱)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDraftBox) name:@"UPDATEDRAFTBOX" object:nil];
    
    [self setNavBarTitle:@"草稿箱"];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"编辑" target:self action:@selector(editorButtonTapped:)]];
    
    //读取数据
    [self readPlist];
    
    [self setExtraCellLineHidden:_tableView];
    
    //已经打开草稿箱
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISOPENDRAFT"];
}

//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//增加提示语句
- (void)addPromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (!titLabel) {
        titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, MAINSCREEN.size.width, 30)];
        titLabel.textAlignment = NSTextAlignmentCenter;
        titLabel.tag = 0x128;
    }
    
    titLabel.text = @"无数据";
    [titLabel setFont:[UIFont systemFontOfSize:18.0]];
    [titLabel setTextColor:[UIColor lightGrayColor]];
    [self.tableView addSubview:titLabel];
}


//删除提示语句
- (void)removePromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (titLabel) {
        [titLabel removeFromSuperview];
    }
}


- (void)readPlist
{
    NSString *path = NSTemporaryDirectory();
    NSString *plistPath = [NSString stringWithFormat:@"%@Draft",path];
    //读取
    NSString *filename = [plistPath stringByAppendingPathComponent:@"draftData.plist"];   //获取路径
    
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filename];
    
    _tableArray = [[NSMutableArray alloc] initWithArray:array];
    
    if([_tableArray count] > 0)
    {
        [self removePromptView];
    }
    else{
        [self addPromptView];
    }
}


//编辑按钮
- (void)editorButtonTapped:(id)sender
{
     [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing)
    {
        [self.navbar setRightBtnTitle:@"完成"];
    }
    else
    {
        [self.navbar setRightBtnTitle:@"编辑"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DraftTableViewCell *cell = [DraftModel findCellWithTableView:tableView];
    
    NSDictionary *dic = [_tableArray objectAtIndex:indexPath.row];
    
    if (dic) {
        [cell initWithParsData:dic];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"CameraStoryboard" bundle:nil];
    //跳转到发布页面
    ImagesReleasedViewController *pVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"ImagesReleasedViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pVC];
    pVC.isDraft = YES;
    pVC.cacheDict = [self.tableArray objectAtIndex:indexPath.row];
    pVC.mRow = indexPath.row;

    [self presentViewController:nav animated:YES completion:nil];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{    
    return UITableViewCellEditingStyleDelete;
}


/*删除用到的函数*/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSDictionary *cacheDict = [self.tableArray objectAtIndex:indexPath.row];
        
        if ([cacheDict objectForKey:@"imgUrl"]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
            [dic setObject:[cacheDict objectForKey:@"imgUrl"] forKey:@"imgUrl"];
            
            //删除数组里的数据
            [self.tableArray removeObjectAtIndex:[indexPath row]];
            //删除对应数据的cell
            [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [[PublishImage sharedPublishImage] deleteCacheImage:indexPath.row];
        }
        else{
            //删除数组里的数据
            [self.tableArray removeObjectAtIndex:[indexPath row]];
            //删除对应数据的cell
            [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [[PublishImage sharedPublishImage] deleteCacheImage:indexPath.row];
        }
    }
}


//更新草稿箱
- (void)updateDraftBox
{
    //读取数据
    [self readPlist];
    
    [_tableView reloadData];
}


//删除阿里云服务器上的图片
- (void)deleteOssImage:(NSInteger)mRow
{
    
}


@end
