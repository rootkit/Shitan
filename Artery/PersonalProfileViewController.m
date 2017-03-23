//
//  PersonalProfileViewController.m
//  Shitan
//
//  Created by Jia HongCHI on 14-10-4.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PersonalProfileViewController.h"
#import "TextFieldEditViewController.h"
#import "TextViewEditViewController.h"
#import "DatePickeViewController.h"
#import "CityPickerViewController.h"
#import "SJAvatarBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GenderChooseViewController.h"
#import "LXActionSheet.h"
#import "UploadDAO.h"
#import "Units.h"
#import "ParsModel.h"
#import "AccountDAO.h"

@interface PersonalProfileViewController ()<LXActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIStoryboard *board;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic, readwrite) LXActionSheet *actionSheet;
@property (strong, readwrite, nonatomic) UploadDAO *uploadDAO;
@property (strong, readwrite, nonatomic) AccountDAO *dao;

@end

@implementation PersonalProfileViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];
    
    [MobClick beginLogPageView:@"个人资料"];
}

- (void)initDao
{
    if (!_uploadDAO) {
        self.uploadDAO = [[UploadDAO alloc] init];
    }
    
    if (!self.dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人资料"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDao];
    
    board = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    [self setNavBarTitle:@"个人资料"];
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:0];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 65;
    }
    if (indexPath.row == 5) {
        
        if ([AccountInfo sharedAccountInfo].signature) {
            return [self calculateDesLabelheight:[AccountInfo sharedAccountInfo].signature] + 28;
        }
        return 45;
    }
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"HeadCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
            UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width-90, 12, 56, 56)];
            headImageView.tag = 0x332D;
            [cell.contentView addSubview:headImageView];
            
            cell.textLabel.text = @"头像";
            headImageView.contentMode = UIViewContentModeScaleAspectFill;
            
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [btn setFrame:CGRectMake(MAINSCREEN.size.width-90, 12, 56, 56)];
//            [btn addTarget:self action:@selector(headButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [cell.contentView addSubview:btn];
            
        }
        
        UIImageView *headImageView = (UIImageView *)[cell.contentView viewWithTag:0x332D];
        headImageView.layer.cornerRadius = 6; //设置那个圆角的有多圆
        headImageView.layer.masksToBounds = YES;  //设为NO去试试
        
        
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[AccountInfo sharedAccountInfo].portraiturl] placeholderImage:[UIImage imageNamed:@"mine_head.png"]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.detailTextLabel.minimumScaleFactor = 0.6f;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        NSString *title;
        NSString *value;
  
        if (indexPath.row == 1) {
            title = @"昵称";
            value = [AccountInfo sharedAccountInfo].nickname;
            
        }
        
        if (indexPath.row == 2) {
            title = @"性别";
            value = [AccountInfo sharedAccountInfo].gender == 0 ? @"男":@"女";
        }
        
        if (indexPath.row == 3) {
            title = @"出生日期";
            value = [AccountInfo sharedAccountInfo].birthday;
        }
        if (indexPath.row == 4) {
            title = @"所在地";
            if ((NSNull *)[AccountInfo sharedAccountInfo].city != [NSNull null]) {
                value = [AccountInfo sharedAccountInfo].city;
            }
            else{
                value = @"未填写";
            }
            
        }
        else if(indexPath.row == 5)
        {
            title = @"简介";
            if ((NSNull *)[AccountInfo sharedAccountInfo].signature != [NSNull null]) {
                value = [AccountInfo sharedAccountInfo].signature;
            }
            else{
                value = @"未填写";
            }
            cell.detailTextLabel.numberOfLines = 5;
            
        }
        
        cell.textLabel.text = title;
        cell.detailTextLabel.text = value;
        return cell;
        
    }
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        _actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照", @"从手机相册中选择"]];
        _actionSheet.tag = 101;
        [_actionSheet showInView:self.view];
    }
    
    if (indexPath.row == 1) {
        TextFieldEditViewController *vc = [board instantiateViewControllerWithIdentifier:@"TextFieldEditViewController"];
        vc.editTitle = @"昵称";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        GenderChooseViewController *vc = [board instantiateViewControllerWithIdentifier:@"GenderChooseViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 3) {
        DatePickeViewController *vc = [board instantiateViewControllerWithIdentifier:@"DatePickeViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 4) {
        CityPickerViewController *vc = [board instantiateViewControllerWithIdentifier:@"CityPickerViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 5) {
        TextViewEditViewController *vc = [board instantiateViewControllerWithIdentifier:@"TextViewEditViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


// 计算DesLabl的高度
- (CGFloat)calculateDesLabelheight:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:16.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(220, 2000);
    
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    if (size.height < 16) {
        return 16;
    }

    
    return size.height;
}


////点击头像
//- (void)headButtonTouch:(id)sender {
//    UIImageView *headImageView = (UIImageView *)[self.tableView viewWithTag:0x332D];
//    [SJAvatarBrowser showImage:headImageView];
//}

#pragma mark - LXActionSheetDelegate
- (void)actionSheet:(LXActionSheet *)mActionSheet didClickOnButtonIndex:(int)buttonIndex
{
    if (mActionSheet.tag == 101) {
        switch (buttonIndex) {
            case 0:
            {
                //照相机
                if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
                    //                    AlertWithTitleAndMessage(@"您的设备不支持拍照功能",@"");
                    return;
                }
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                //调用前摄像头
                //			_pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            case 1:
            {
                //相簿
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
                
            default:
                break;
        }
    }
}

#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
	
	UIImage* userImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CLog(@"%02f, %02f", userImage.size.height, userImage.size.width);
    UIImage *headImage = ImageWithImageSimple(userImage, CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width));
    
    [_uploadDAO requestUploadHeadImage:headImage completionBlock:^(NSDictionary *result) {
        
        [ParsModel parsData:result successBlock:^(NSDictionary *dict) {
            CLog(@"%@", dict);
            //更新用户信息
            [self updateHeadImage:[NSString stringWithFormat:@"%@", [dict objectForKey:@"url"]]];
        } failureBlock:^(NSDictionary *dict) {
            CLog(@"%@", dict);
        }];
        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateHeadImage:(NSString *)headUrl
{
    
    [AccountInfo sharedAccountInfo].portraiturl = headUrl;
    
    //重载
    [_tableView reloadData];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dict setObject:headUrl forKey:@"portraitUrl"];

    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_dao requestUserUpdate:requestDict
            completionBlock:^(NSDictionary *result) {
                if ([[result objectForKey:@"code"] integerValue] == 200)
                {
                    //跟新用户信息
                    [AccountInfo sharedAccountInfo].portraiturl = headUrl;
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
