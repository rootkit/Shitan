//
//  AddressDAO.m
//  Shitan
//
//  Created by Richard Liu on 15/6/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "AddressDAO.h"
#import "RequestModel.h"

@implementation AddressDAO


// 获取收货地址列表
- (void)GetAddressList:(NSDictionary *)dict
       completionBlock:(AddressDAOBlock)completionBlock
        setFailedBlock:(AddressDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BuyerAddrList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



// 更新收货地址
- (void)UpdateAddressInfo:(NSDictionary *)dict
          completionBlock:(AddressDAOBlock)completionBlock
           setFailedBlock:(AddressDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BuyerAddrUpdate
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



// 删除收货地址
- (void)DeleteAddressInfo:(NSDictionary *)dict
          completionBlock:(AddressDAOBlock)completionBlock
           setFailedBlock:(AddressDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BuyerAddrDelete
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

//  删除所有收货地址

- (void)DeleteAllAddressInfo:(NSDictionary *)dict
             completionBlock:(AddressDAOBlock)completionBlock
              setFailedBlock:(AddressDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BuyerALLAddrDelete
                                             postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
    
}



//  增加收货地址
- (void)AddAddressInfo:(NSDictionary *)dict
       completionBlock:(AddressDAOBlock)completionBlock
        setFailedBlock:(AddressDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BuyerAddrAdd
                                              postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}


//  设置默认收货地址
- (void)setDefaultAddressInfo:(NSDictionary *)dict
              completionBlock:(AddressDAOBlock)completionBlock
               setFailedBlock:(AddressDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_BuyerAddrSetDefault
                                              postDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

@end
