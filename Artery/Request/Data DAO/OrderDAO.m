//
//  OrderDAO.m
//  Shitan
//
//  Created by Richard Liu on 15/6/16.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "OrderDAO.h"
#import "RequestModel.h"


@implementation OrderDAO

//用户的订单列表
- (void)GetOrderList:(NSDictionary *)dict
     completionBlock:(OrderDAOBlock)completionBlock
      setFailedBlock:(OrderDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_OrderList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


//创建订单
- (void)GetOrderCreate:(NSDictionary *)dict
       completionBlock:(OrderDAOBlock)completionBlock
        setFailedBlock:(OrderDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_OrderCreate
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


//获取某个订单详情
- (void)getOrderDetails:(NSDictionary *)dict
        completionBlock:(OrderDAOBlock)completionBlock
         setFailedBlock:(OrderDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetOrderDes
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

//获取某个订单状态列表
- (void)getOrderState:(NSDictionary *)dict
      completionBlock:(OrderDAOBlock)completionBlock
       setFailedBlock:(OrderDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetOrderState
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}




// 查找某张订单下的所有清单记录
- (void)getOrderFindList:(NSDictionary *)dict
         completionBlock:(OrderDAOBlock)completionBlock
          setFailedBlock:(OrderDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetDishesFindList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}






@end
