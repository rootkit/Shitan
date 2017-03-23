//
//  GroupInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "GroupInfo.h"

@implementation GroupInfo


- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.deal_id = [dict objectForKeyNotNull:@"deal_id"];
    self.title = [dict objectForKeyNotNull:@"title"];
    self.des = [dict objectForKeyNotNull:@"description"];
    self.city = [dict objectForKeyNotNull:@"city"];
    
    self.list_price = [[dict objectForKeyNotNull:@"list_price"] floatValue];
    self.current_price = [[dict objectForKeyNotNull:@"current_price"] floatValue];
    
    self.purchase_count = [[dict objectForKeyNotNull:@"purchase_count"] integerValue];
    self.publish_date = [dict objectForKeyNotNull:@"publish_date"];
    self.details = [dict objectForKeyNotNull:@"details"];
    self.purchase_deadline = [dict objectForKeyNotNull:@"purchase_deadline"];
    
    self.image_url = [dict objectForKeyNotNull:@"image_url"];
    self.s_image_url = [dict objectForKeyNotNull:@"s_image_url"];
    
    self.isAppointmentis = [[dict objectForKeyNotNull:@"restrictions.is_reservation_required"] integerValue];
    self.isRefundable = [[dict objectForKeyNotNull:@"restrictions.is_refundable"] integerValue];
    
    self.special_tips = [dict objectForKeyNotNull:@"restrictions.special_tips"];
    self.notice = [dict objectForKeyNotNull:@"notice"];
    self.deal_url = [dict objectForKeyNotNull:@"deal_url"];
    self.deal_h5_url = [dict objectForKeyNotNull:@"deal_h5_url"];
    
    self.businessesName = [dict objectForKeyNotNull:@"businesses.name"];
    self.businessesId = [dict objectForKeyNotNull:@"businesses.id"];
    self.latitude = [dict objectForKeyNotNull:@"businesses.latitude"];
    self.longitude = [dict objectForKeyNotNull:@"businesses.longitude"];
    self.address = [dict objectForKeyNotNull:@"businesses.address"];
    self.url = [dict objectForKeyNotNull:@"businesses.url"];
    
    return self;
}

@end
