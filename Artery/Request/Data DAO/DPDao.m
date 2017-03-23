//
//  DPDao.m
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "DPDao.h"
#import "RequestModel.h"

@implementation DPDao

/**
 *  获取指定商户的团购信息
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GetMerchantsGroup:(NSDictionary *)dict
          completionBlock:(DPDaoBlock)completionBlock
           setFailedBlock:(DPDaoBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithDianPingAPI:URL_DPMerchantsGroup
                                                      getDict:dict
                                              completionBlock:completionBlock
                                               setFailedBlock:failedBlock];
}

- (void)GetUserGroup:(NSDictionary *)dict completionBlock:(DPDaoBlock)completionBlock setFailedBlock:(DPDaoBlock)failedBlock{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_InitGroupBuying
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}

- (void)GetGroupList:(NSDictionary *)dict completionBlock:(DPDaoBlock)completionBlock setFailedBlock:(DPDaoBlock)failedBlock{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_GroupList
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}

- (void)GEtPacketList:(NSDictionary *)dict completionBlock:(DPDaoBlock)completionBlock setFailedBlock:(DPDaoBlock   )failedBlock{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_PacketList postDict:dict completionBlock:completionBlock setFailedBlock:failedBlock];
    
}


- (void)CouponCode:(NSDictionary *)dict completionBlock:(DPDaoBlock)completionBlock setFailedBlock:(DPDaoBlock)failedBlock{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_CouponCode
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}

- (void)GroupCash:(NSDictionary *)dict completionBlock:(DPDaoBlock)completionBlock setFailedBlock:(DPDaoBlock)failedBlock{
    
    [[RequestModel shareInstance] requestModelWithAPI:URL_GroupCash
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}

@end
