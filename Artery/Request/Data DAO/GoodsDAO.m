//
//  GoodsDAO.m
//  Shitan
//
//  Created by Richard Liu on 15/6/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "GoodsDAO.h"
#import "RequestModel.h"

@implementation GoodsDAO

//获取城市中的商品列表
- (void)GetProductList:(NSDictionary *)dict
       completionBlock:(GoodsDAOBlock)completionBlock
        setFailedBlock:(GoodsDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ProductList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



//获取商品详情信息
- (void)GetProductDetail:(NSDictionary *)dict
         completionBlock:(GoodsDAOBlock)completionBlock
          setFailedBlock:(GoodsDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_ProductDetail
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}



//获取商品的规格列表
- (void)getProductRulesList:(NSDictionary *)dict
            completionBlock:(GoodsDAOBlock)completionBlock
             setFailedBlock:(GoodsDAOBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_RulesFindList
                                              getDict:dict
                                      completionBlock:completionBlock
                                       setFailedBlock:failedBlock];
}

@end
