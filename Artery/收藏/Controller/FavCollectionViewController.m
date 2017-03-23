//
//  FavCollectionViewController.m
//  Shitan
//
//  Created by Avalon on 15/4/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "FavCollectionViewController.h"
#import "NewFavCollectionCell.h"
#import "FavCollectionCell.h"
#import "FavDescribeViewController.h"
#import "FavoriteCreateViewController.h"
#import "FavInfo.h"
#import "FavoriteDetailViewController.h"

#import "CollectionDAO.h"


@interface FavCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) CollectionDAO *favoriteDao;

@property (nonatomic, strong) NSArray *favArray;

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation FavCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height - 84) collectionViewLayout:layout];

    self.collectionView = collectionView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //注册收藏Cell
    [self.collectionView registerClass:[FavCollectionCell class] forCellWithReuseIdentifier:@"FavCollectionCell"];
    
    //注册新建收藏Cell
    [self.collectionView registerClass:[NewFavCollectionCell class] forCellWithReuseIdentifier:@"NewFavCollectionCell"];

    
    [self.view addSubview:self.collectionView];
    
    //获取用户信息
    [self initDao];
    
    [self getFavoriteList];
}

//
- (void)initDao{
    
    if (!self.favoriteDao) {
        self.favoriteDao = [[CollectionDAO alloc]init];
    }
}


//获取用户收藏夹列表
- (void)getFavoriteList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [_favoriteDao userFavorite2:dict completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200)
        {
            if ([result objectForKey:@"obj"]) {
                _favArray = [result objectForKey:@"obj"];
                
                [self.collectionView reloadData];
            }
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
    
}

#pragma mark - collectionView data source
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_favArray count] + 1;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat m_unit = (MAINSCREEN.size.width-36)/2;
    CGFloat m_Width = m_unit  + (m_unit - 16)/3.0 + 36;
    
    return CGSizeMake(m_unit, m_Width);
}

//设定全局的行间距，如果想要设定指定区内Cell的最小行距，可以使用下面方法
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.0f;
}

//设定全局的Cell间距，如果想要设定指定区内Cell的最小间距，可以使用下面方法：
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 12, 20, 12);
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *newFavCollectionCellIdentifier = @"NewFavCollectionCell";
        NewFavCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:newFavCollectionCellIdentifier forIndexPath:indexPath];        
        return cell;
    }
    else
    {
        static NSString *favoriteCellIdentifier = @"FavCollectionCell";
        
        FavCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:favoriteCellIdentifier forIndexPath:indexPath];
        
        FavInfo *fInfo = [[FavInfo alloc] initWithParsData:[_favArray objectAtIndex:indexPath.row - 1]];
        [cell initWithParsData:fInfo];
        
        return cell;
    }
    
    return nil;
}


#pragma mark - collectionView delegete
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0)
    {
        //创建收藏夹
        FavoriteCreateViewController *favoriteCreateVC = (FavoriteCreateViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MineStoryboard" class:[FavoriteCreateViewController class]];
        favoriteCreateVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:favoriteCreateVC animated:YES];
    }
    else
    {
        FavInfo *dict = [[FavInfo alloc] initWithParsData:[_favArray objectAtIndex:indexPath.row -1]];
        FavoriteDetailViewController *favoriteDetailVC = (FavoriteDetailViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MineStoryboard" class:[FavoriteDetailViewController class]];
        favoriteDetailVC.hidesBottomBarWhenPushed = YES;
        favoriteDetailVC.fInfo = dict;
        favoriteDetailVC.isMyself = YES;
        
        [self.navigationController pushViewController:favoriteDetailVC animated:YES];
    }
}

@end
