//
//  FileManagement.h
//  Shitan
//
//  Created by Richard Liu on 15/5/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagement : NSObject

//创建草稿箱
+ (void)createCustomFolder;

//清空缓存文件文件夹
+ (void)clearDraftFolder;

//清空缓存文件文件夹
+ (void)clearCoreData;

@end
