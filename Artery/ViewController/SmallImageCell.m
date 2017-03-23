//
//  SmallImageCell.m
//  Shitan
//
//  Created by Richard Liu on 15/5/5.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "SmallImageCell.h"
#import "WZShopCell.h"

static NSString *const ID = @"shop";

#define OFFSET_X_RIGHT_N 10.0f

@interface SmallImageCell ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *tableArray;

@end

@implementation SmallImageCell

- (void)awakeFromNib {
    // Initialization code
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //单个图片宽度
    NSUInteger singleW = (MAINSCREEN.size.width - OFFSET_X_RIGHT_N*4)/3;
    
    layout.itemSize = CGSizeMake(singleW, singleW);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
    
    //创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height) collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollEnabled = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:@"WZShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
}

- (void)setSmallImageCellWithCellInfo:(NSArray *)array
{
    _tableArray = array;
    [_collectionView reloadData];
    
    //计算高度
    NSUInteger mx = array.count/3;  //商
    NSUInteger my = array.count%3;  //余数

    if(my != 0)
    {
        mx++;
    }
    
    CLog(@"%f", MAINSCREEN.size.width);
    //单个图片宽度
    NSUInteger singleW = (MAINSCREEN.size.width - OFFSET_X_RIGHT_N*4)/3  + OFFSET_X_RIGHT_N;
    [self.collectionView setFrame:CGRectMake(0, 0, MAINSCREEN.size.width, singleW*mx + OFFSET_X_RIGHT_N)];
    
}

#pragma mark - <UICollectionDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _tableArray.count;
    
}

#pragma mark collectionView
//设定全局的行间距，如果想要设定指定区内Cell的最小行距，可以使用下面方法
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

//设定全局的Cell间距，如果想要设定指定区内Cell的最小间距，可以使用下面方法：
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(OFFSET_X_RIGHT_N, OFFSET_X_RIGHT_N, OFFSET_X_RIGHT_N, OFFSET_X_RIGHT_N);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WZShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.shop = _tableArray[indexPath.row];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DynamicInfo *shop = _tableArray[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(smallImageCellSelectItem:)]) {
        [_delegate smallImageCellSelectItem:shop];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
