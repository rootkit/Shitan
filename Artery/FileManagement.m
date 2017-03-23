
////
//  FileManagement.m
//  Shitan
//
//  Created by Richard Liu on 15/5/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "FileManagement.h"

@implementation FileManagement

//创建草稿箱
+ (void)createCustomFolder{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = NSTemporaryDirectory();
    NSString *createPath = [NSString stringWithFormat:@"%@Draft",pathDocuments];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath])
    {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else
    {
        CLog(@"Have");
    }
}

//清空缓存文件文件夹
+ (void)clearDraftFolder
{
    NSString *path = NSTemporaryDirectory();
    //读取
    NSString *plistPath = [NSString stringWithFormat:@"%@Draft", path];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:plistPath error:NULL];
    
    //清空Draft文件夹
    for(NSString *item in contents)
    {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", plistPath, item];
        
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        CLog(@"%@", error);
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEDRAFTBOX" object:nil];
}


//清空缓存文件夹Document
+ (void)clearCoreData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    //读取
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    //清空Draft文件夹
    for(NSString *item in contents)
    {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, item];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}


@end
