//
//  PacketList.h
//  Shitan
//
//  Created by Avalon on 15/5/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PacketList : NSObject

//交易记录Id
@property (nonatomic, copy) NSString *recordId;
//用户的ID
@property (nonatomic, copy) NSString *userId;
//自增Id,无实际含义
@property (nonatomic, assign) int ID;
//红包类型：0团购返利，1提现
@property (nonatomic, assign) int ptype;
//状态：0（默认），1提现中，2提现成功，3提现失败 ，仅在提现时有用
@property (nonatomic, assign) int state;
//补充注释
@property (nonatomic, copy) NSString *note;
//剩余金额
@property (nonatomic, assign) float totalMoney;
//收入和支出,变化金钱
@property (nonatomic, assign) float changeMoney;
//创建时间
@property (nonatomic, copy) NSString *createTime;
//更新时间
@property (nonatomic, copy) NSString *updateTime;


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
