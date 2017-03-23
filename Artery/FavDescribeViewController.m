//
//  FavDescribeViewController.m
//  Shitan
//
//  Created by 刘敏 on 14/12/16.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FavDescribeViewController.h"
#import "CollectionDAO.h"


@interface FavDescribeViewController ()

@property (strong, nonatomic) CollectionDAO *dao;

@property (weak, readwrite, nonatomic) IBOutlet UIScrollView *scrollew;

@end

@implementation FavDescribeViewController


- (void)initDAO
{
    if (!_dao) {
        self.dao = [[CollectionDAO alloc] init];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"收藏夹详情"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"收藏夹详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollew.backgroundColor = BACKGROUND_COLOR;
    
    [self setNavBarTitle:@"编辑简介"];
    
    [ResetFrame resetScrollView:self.scrollew contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:0];
    
    //保存按钮
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"保存" target:self action:@selector(saveButtonTapped:)]];
    
    [_textView becomeFirstResponder];
    
    if(_favInfo.favoriteDesc)
    {
        _textView.text = _favInfo.favoriteDesc;
    }
    
    [self initDAO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonTapped:(id)sender{
    
    if ([_favInfo.favoriteDesc isEqualToString:self.textView.text]) {
        CLog(@"未做修改");
        MET_MIDDLE(@"收藏夹简介未做修改，无需保存。");
        return;
    }
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dict setObject:self.favInfo.title forKey:@"title"];
    [dict setObject:self.textView.text forKey:@"favoriteDesc"];
    
    [dict setObject:self.favInfo.favoriteId forKey:@"favoriteId"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_dao editFavorite:requestDict
       completionBlock:^(NSDictionary *result) {
           
           if ([[result objectForKey:@"code"] integerValue] == 200)
           {
               if (_delegate && [_delegate respondsToSelector:@selector(updateFavDescribe:)]) {
                   [_delegate updateFavDescribe:self.textView.text];
               }
               //返回
               [self.navigationController popViewControllerAnimated:YES];
           }
           else
           {
               MET_MIDDLE([result objectForKey:@"msg"]);
           }
           
           
       }
        setFailedBlock:^(NSDictionary *result) {
            
        }];
    
}

@end
