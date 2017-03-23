//
//  MarkPlistOperation.m
//  Artery
//
//  Created by RichardLiu on 15/3/26.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "MarkPlistOperation.h"

@implementation MarkPlistOperation


+ (NSArray *)readPlist
{
    NSMutableArray *array  = [[NSMutableArray alloc] init];
    //写入文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    
    //获取路径
    NSString *filename = [path stringByAppendingPathComponent:@"markData.plist"];
    //读取数据
    array = [NSMutableArray arrayWithContentsOfFile:filename];  //读取数据
    
    //倒序输出
    array = (NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
    
    return array;
}


+ (void)writePlist:(NSDictionary *)mark
{
    NSMutableArray *array  = [[NSMutableArray alloc] init];
    //写入文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    
    //获取路径
    NSString *filename = [path stringByAppendingPathComponent:@"markData.plist"];
    
    //读取数据
    array = [NSMutableArray arrayWithContentsOfFile:filename];

    BOOL success = [fileManager fileExistsAtPath:filename];
    //不存在先创建Plist文件
    if (!success) {
        
        NSMutableArray * fileArray = [[NSMutableArray alloc] initWithCapacity:0];
        [fileArray addObject:mark];
        
        [fileArray writeToFile:filename atomically:YES];
    }
    else{
        
        for (NSDictionary *item in array) {
            if([[item objectForKey:@"rawTag"] isEqualToString:[mark objectForKey:@"rawTag"]])
            {
                return;
            }
        }
        
        //最多存储40个
        if(array.count == 40)
        {
            [array replaceObjectAtIndex:39 withObject:mark];
        }
        else{
            [array addObject:mark];
            [array writeToFile:filename atomically:YES];
        }

    }
}

@end
