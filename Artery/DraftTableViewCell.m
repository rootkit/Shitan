//
//  DraftTableViewCell.m
//  Shitan
//
//  Created by 刘敏 on 15/1/20.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "DraftTableViewCell.h"

@implementation DraftTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)initWithParsData:(NSDictionary *)dict
{
    NSString *pathDocuments = NSTemporaryDirectory();
    NSString *createPath = [NSString stringWithFormat:@"%@/Draft",pathDocuments];
    NSString *dataFilePath = [createPath stringByAppendingPathComponent:[dict objectForKey:@"waterURL"]];
    
    
    _imageV.image = [UIImage imageWithContentsOfFile:dataFilePath];

    if([dict objectForKey:@"imgDesc"])
    {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 6, MAINSCREEN.size.width-81-21, 21)];
        [_desLabel setText:[dict objectForKey:@"imgDesc"]];
        [_desLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_desLabel setBackgroundColor:[UIColor clearColor]];
        [_desLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:_desLabel];
        
        
        _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 26, MAINSCREEN.size.width-81-21, 21)];
        //地点存在
        if ([dict objectForKey:@"placeN"]) {
            [_placeLabel setText:[dict objectForKey:@"placeN"]];
        }
        else{
            [_placeLabel setText:@"地点：--"];
        }

        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 46, 180, 21)];

    }
    else{
        
        //地点存在
        _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 16, MAINSCREEN.size.width-81-21, 21)];
        //地点存在
        if ([dict objectForKey:@"placeN"])
        {
            [_placeLabel setText:[dict objectForKey:@"placeN"]];
        }
        else{
            [_placeLabel setText:@"地点：--"];
        }
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(83, 36, 180, 21)];
    }
    
    
    [_placeLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_placeLabel setBackgroundColor:[UIColor clearColor]];
    [_placeLabel setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:_placeLabel];
    
    
    [_timeLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_timeLabel setTextColor:[UIColor lightGrayColor]];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    [_timeLabel setText:[dict objectForKey:@"time"]];
    
    [self.contentView addSubview:_timeLabel];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
