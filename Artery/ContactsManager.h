//
//  ContactsManager.h
//  Shitan
//
//  Created by 刘敏 on 15/1/5.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserRelationshipDAO.h"


@interface ContactsManager : NSObject

@property (nonatomic, strong) UserRelationshipDAO *dao;



+ (id)shareInstance;


//延迟载入
- (void)delayLoadContacts;

// 导入通讯录
- (void)loadContacts;

@end
