//
//  BufferViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/9/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "BufferViewController.h"

@interface BufferViewController ()

@end

@implementation BufferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(laodMainVC) withObject:nil afterDelay:0.2];
}

- (void)laodMainVC
{
    [theAppDelegate laodMainVC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
