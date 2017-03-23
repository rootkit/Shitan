//
//  AddressDAO.h
//  Shitan
//
//  Created by Richard Liu on 15/6/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AddressDAOBlock)(NSDictionary *result);

@interface AddressDAO : NSObject

/**
 *  获取收货地址列表
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)GetAddressList:(NSDictionary *)dict
       completionBlock:(AddressDAOBlock)completionBlock
        setFailedBlock:(AddressDAOBlock)failedBlock;



/**
 *  更新收货地址
 *  POST方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)UpdateAddressInfo:(NSDictionary *)dict
          completionBlock:(AddressDAOBlock)completionBlock
           setFailedBlock:(AddressDAOBlock)failedBlock;



/**
 *  删除收货地址
 *  POST方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)DeleteAddressInfo:(NSDictionary *)dict
          completionBlock:(AddressDAOBlock)completionBlock
           setFailedBlock:(AddressDAOBlock)failedBlock;

/**
 *  删除所有收货地址
 *  POST方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)DeleteAllAddressInfo:(NSDictionary *)dict
             completionBlock:(AddressDAOBlock)completionBlock
              setFailedBlock:(AddressDAOBlock)failedBlock;


/**
 *  增加收货地址
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)AddAddressInfo:(NSDictionary *)dict
       completionBlock:(AddressDAOBlock)completionBlock
        setFailedBlock:(AddressDAOBlock)failedBlock;


/**
 *  设置默认收货地址
 *  get方法
 *
 *  @param dict
 *  @param completionBlock
 *  @param failedBlock
 */
- (void)setDefaultAddressInfo:(NSDictionary *)dict
       completionBlock:(AddressDAOBlock)completionBlock
        setFailedBlock:(AddressDAOBlock)failedBlock;

@end
