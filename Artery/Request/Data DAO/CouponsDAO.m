//
//  CouponsDAO.m
//  Shitan
//
//  Created by Richard Liu on 15/4/29.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "CouponsDAO.h"
#import "RequestModel.h"


@implementation CouponsDAO


// 用户的优惠券信息
- (void)UsersOfTheCoupons:(NSDictionary *)dict
          completionBlock:(CouponsDAOBlock)completionBlock
           setFailedBlock:(CouponsDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_CouponList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


//查找购物时所有可用的优惠卷
- (void)UsersOfBusinessCoupons:(NSDictionary *)dict
               completionBlock:(CouponsDAOBlock)completionBlock
                setFailedBlock:(CouponsDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_CouponList2
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


@end
