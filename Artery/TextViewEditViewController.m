//
//  TextViewEditViewController.m
//  Shitan
//
//  Created by Jia HongCHI on 14-10-10.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "TextViewEditViewController.h"
#import "AccountDAO.h"

@interface TextViewEditViewController ()

@property (strong, readwrite, nonatomic) AccountDAO *dao;
@property (weak, readwrite, nonatomic) IBOutlet UIScrollView *scrollew;

@end

@implementation TextViewEditViewController

- (void)initDao
{
    if (!self.dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDao];
    
    self.scrollew.backgroundColor = BACKGROUND_COLOR;
    
    [self setNavBarTitle:@"编辑简介"];
    
    if ([AccountInfo sharedAccountInfo].signature) {
        _textView.text = [AccountInfo sharedAccountInfo].signature;
    }
    
    [ResetFrame resetScrollView:self.scrollew contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:0];
    
    //保存按钮
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"保存" target:self action:@selector(saveButtonTapped:)]];

    [_textView becomeFirstResponder];
    
    
}


- (void)saveButtonTapped:(id)sender{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dict setObject:_textView.text forKey:@"signature"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_dao requestUserUpdate:requestDict
            completionBlock:^(NSDictionary *result) {
                
                if ([[result objectForKey:@"code"] integerValue] == 200)
                {
                    [AccountInfo sharedAccountInfo].signature = _textView.text;
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
