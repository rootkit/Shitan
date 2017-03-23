//
//  MerchantDAO.m
//  Shitan
//
//  Created by Richard Liu on 15/6/26.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "MerchantDAO.h"
#import "RequestModel.h"

@implementation MerchantDAO


// 首页商户列表
- (void)GetAddrList:(NSDictionary *)dict
    completionBlock:(MerchantDAOBlock)completionBlock
     setFailedBlock:(MerchantDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_MerchantsList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


//  获取某个商户信息
- (void)getMerchantsInfo:(NSDictionary *)dict
         completionBlock:(MerchantDAOBlock)completionBlock
          setFailedBlock:(MerchantDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_MerchantsInfo
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

@end
