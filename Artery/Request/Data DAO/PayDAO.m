//
//  PayDAO.m
//  Shitan
//
//  Created by Richard Liu on 15/7/30.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "PayDAO.h"
#import "RequestModel.h"

@implementation PayDAO

//  获取微信支付预付款ID
- (void)getWechatPrepayId:(NSDictionary *)dict
          completionBlock:(PayDAOBlock)completionBlock
           setFailedBlock:(PayDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetWechatPrepayId
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

@end
