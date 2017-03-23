//
//  RuleInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/8/1.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RuleInfo.h"

@implementation RuleInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{

    self.ruleId = [dict objectForKeyNotNull:@"ruleId"];
    self.parentId = [dict objectForKeyNotNull:@"parentId"];
    self.productId = [dict objectForKeyNotNull:@"productId"];
    self.name = [dict objectForKeyNotNull:@"name"];
    self.content = [dict objectForKeyNotNull:@"content"];
    
    self.price = [dict objectForKeyNotNull:@"price"];
    
    self.num = [[dict objectForKeyNotNull:@"num"] integerValue];
    
    //子规格
    if([dict objectForKey:@"subRulesExt"] != [NSNull null] && [[dict objectForKey:@"subRulesExt"] isKindOfClass:[NSArray class]])
    {
        self.rulesArray  = [self encapsulationPraiseArray:[dict objectForKey:@"subRulesExt"]];
    }
    

    return self;
}


//子规格
- (NSArray *)encapsulationPraiseArray:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *item in array) {
        RuleInfo *pInfo = [[RuleInfo alloc] initWithParsData:item];
        [tempArray addObject:pInfo];
    }
    
    return tempArray;
}

@end
