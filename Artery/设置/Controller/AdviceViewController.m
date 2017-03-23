//
//  AdviceViewController.m
//  Shitan
//
//  Created by 刘敏 on 15/1/20.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "AdviceViewController.h"
#import "AccountDAO.h"

@interface AdviceViewController ()

@property (nonatomic, strong) AccountDAO *dao;


@end

@implementation AdviceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"意见建议"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"意见建议"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isNote) {
        [self setNavBarTitle:@"添加备注"];
        [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"确定" target:self action:@selector(doneButtonTapped:)]];
    }
    else
    {
        [self setNavBarTitle:@"给我们建议"];
        [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"提交" target:self action:@selector(submitButtonTapped:)]];
    }
    
    [ResetFrame resetScrollView:self.scrollView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    self.scrollView.backgroundColor = BACKGROUND_COLOR;

    
    //圆角
    _textView.layer.cornerRadius = 3; //设置那个圆角的有多圆
    _textView.layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
    _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];//设置边框的颜色
    _textView.layer.masksToBounds = YES;  //设为NO去试试
    
    [self initDao];
    
}

- (void)initDao{
    if (!_dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}


//提交
- (void)submitButtonTapped:(id)sender
{
    if (_textView.text.length == 0) {
        MET_MIDDLE(@"内容不能为空");
        return;
    }
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [dic setObject:_textView.text forKey:@"suggest"];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_dao requestSuggestCreate:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            MET_MIDDLE(@"谢谢您的宝贵建议");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
    
    
}

//提交
- (void)doneButtonTapped:(id)sender
{
    if (_textView.text.length == 0) {
        MET_MIDDLE(@"内容为空，无需保存");
        return;
    }
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateNote:)]) {
        [_delegate updateNote:_textView.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
