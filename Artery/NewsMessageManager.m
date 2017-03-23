//
//  NewsMessageManager.m
//  Shitan
//
//  Created by 刘敏 on 15/1/3.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "NewsMessageManager.h"


static NewsMessageManager *instance = nil;

@implementation NewsMessageManager

+ (id)shareInstance {
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


- (void)initDAO
{
    if (!self.dao) {
        self.dao = [[MessageDAO alloc] init];
    }

}

//获取未读消息
- (void)getUnreadMessages
{
    [self initDAO];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"receiverId"];
    
    [_dao requestUnreadMessage:dic completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            
            if ([result objectForKey:@"obj"]) {
                NSUInteger count = [[[result objectForKey:@"obj"] objectForKey:@"result"] integerValue];
                
                if(count > 0)
                {
                    //设置上标
//                    [theAppDelegate updateTabbarBadgeAtIndex:3 enable:2];                    
                }
            }
        } 
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}



#pragma mark 计时器
/*********************************  计时器  *******************************/
//循环事件
- (void)LoopAction:(NSTimer *)time{
    
    if (_timeNum == 0) {
        //倒计时结束后要调用的语句
        _timeNum = 10.0;
        
        if ([AccountInfo sharedAccountInfo].userId) {
            [[NewsMessageManager shareInstance] getUnreadMessages];
        }
        
        [[NewsMessageManager shareInstance] startclock];
        
        [time invalidate];
        return;
    }
    
    else
    {
        _timeNum -= 1;
    }
}


//开始倒计时
- (void)startclock{
    _timeNum = 10.0;
    _timeToStart = nil;
    _timeToStart = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(LoopAction:) userInfo:NULL repeats:YES];
}


@end
