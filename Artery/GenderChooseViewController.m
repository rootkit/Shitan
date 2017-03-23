//
//  GenderChooseViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-10-16.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "GenderChooseViewController.h"
#import "AccountDAO.h"

@interface GenderChooseViewController ()

@property (strong, readwrite, nonatomic) AccountDAO *dao;

@end

@implementation GenderChooseViewController



- (void)initDao
{
    if (!self.dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDao];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self setNavBarTitle:@"选择性别"];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:@"男", @"女", nil];
    
    _genderArray = tempArray;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_genderArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    

    cell.textLabel.text = [_genderArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == [AccountInfo sharedAccountInfo].gender) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 选中操作
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    

    NSInteger gender = 0;
    
    NSString *genderS = [_genderArray objectAtIndex:indexPath.row];
    
    if ([genderS isEqualToString:@"女"]) {
        gender = 1;
    }
    
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [postDict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    [postDict setObject:[NSNumber numberWithInteger:gender] forKey:@"gender"];
    
    [self saveGender:postDict gender:gender];

}


- (void)saveGender:(NSDictionary *)dict gender:(NSInteger)gender{
    
    if (gender == [AccountInfo sharedAccountInfo].gender) {
        CLog(@"性别未做修改！");
        
        //返回
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    
    [_dao requestUserUpdate:requestDict
            completionBlock:^(NSDictionary *result) {
                
                if ([[result objectForKey:@"code"] integerValue] == 200)
                {
                    //跟新用户信息
                    [AccountInfo sharedAccountInfo].gender = gender;
                    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
