//
//  PhotoViewController.m
//  Artery
//
//  Created by RichardLiu on 15/4/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "PhotoViewController.h"
#import "STImageEditorViewController.h"
#import "DMCameraViewController.h"

@interface PhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@end

@implementation PhotoViewController



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"相册"];
    //隐藏navigationController
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"相册"];
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((MAINSCREEN.size.width - 6)/4, (MAINSCREEN.size.width - 6)/4);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用

    _cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height-24) collectionViewLayout:layout];
    [_cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_cv setUserInteractionEnabled:YES];
    [_cv setDataSource:self];
    [_cv setDelegate:self];
    [_cv setBackgroundColor:[UIColor clearColor]];


    [self.view addSubview:_cv];
    
    [self initTableData];
}


- (IBAction)cancelButtonTapped:(id)sender
{
    theAppDelegate.PODict = nil;
    theAppDelegate.isPO = NO;
    
    [self dismissViewControllerAnimated:YES completion:^{
        //显示
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }];
}

- (IBAction)cameraButtonTapped:(id)sender
{
    UIStoryboard *cameraStoryboard = [UIStoryboard storyboardWithName:@"CameraStoryboard" bundle:nil];
    DMCameraViewController * pVC = [cameraStoryboard instantiateViewControllerWithIdentifier:@"DMCameraViewController"];
    [self.navigationController pushViewController:pVC animated:YES];
}


- (void)initTableData
{
    _imageArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    NSString *type = [result valueForProperty:ALAssetPropertyType];
                    if ([type isEqualToString:@"ALAssetTypePhoto"]) {
                        [_imageArray addObject:result];
                    }
                    [_cv reloadData];
                    
                    if (_imageArray.count > 0) {
                        //定位到最新的图片
                        NSIndexPath *currentIndexPatht = [NSIndexPath indexPathForItem:_imageArray.count-1 inSection:0];
                        [_cv scrollToItemAtIndexPath:currentIndexPatht atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
                    }

                }
            }];
        }
    }failureBlock:^(NSError *error)
    {
        CLog(@"Group not found!\n");
    }];


}



#pragma mark collectionView
//设定全局的行间距，如果想要设定指定区内Cell的最小行距，可以使用下面方法
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0f;
}

//设定全局的Cell间距，如果想要设定指定区内Cell的最小间距，可以使用下面方法：
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_imageArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (MAINSCREEN.size.width - 6)/4, (MAINSCREEN.size.width - 6)/4)];
    iv.image = [UIImage imageWithCGImage:((ALAsset *)[_imageArray objectAtIndex:indexPath.row]).thumbnail];
    
    [cell.contentView addSubview:iv];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //从相册中读取图片到图片编辑界面
    STImageEditorViewController *sv = CREATCONTROLLER(STImageEditorViewController);
    
    ALAsset *asset = (ALAsset *)[_imageArray objectAtIndex:indexPath.row];
    ALAssetRepresentation* representation = [asset defaultRepresentation];
    
    //旋转方向
    UIImage *image = [UIImage
                    imageWithCGImage:[representation fullResolutionImage]
                    scale:[representation scale]
                    orientation:UIImageOrientationUp];
    
    sv.cacheImage = image;
    CLog(@"%02f, %02f", image.size.width, image.size.height);
    
    [self.navigationController pushViewController:sv animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
