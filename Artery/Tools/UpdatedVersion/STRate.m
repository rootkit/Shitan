//
//  STRate.m
//  Shitan
//
//  Created by Richard Liu on 15/4/24.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STRate.h"
#import "AlertBlock.h"

#define kSTRateRunCountDefault  @"kSTRateRunCountDefault"

#define kSTRateRunCount         @"STRateRunCount"
#define kSTRateTitle            @"STRateTitle"
#define kSTRateMessage          @"STRateMessage"
#define kSTRateAppID            @"STRateAppID"


@implementation STRate

+ (void)loadRate{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    NSUInteger numberOfExecutions = [standardDefaults integerForKey:kSTRateRunCountDefault] + 1;
    
    [[[STRate alloc] initWithNumberOfExecutions:numberOfExecutions] performSelector:@selector(setup) withObject:nil afterDelay:1.0];
    
    [standardDefaults setInteger:numberOfExecutions forKey:kSTRateRunCountDefault];
    [standardDefaults synchronize];
}



+ (NSUInteger)numberOfExecutions {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kSTRateRunCountDefault];
}

- (id)initWithNumberOfExecutions:(NSUInteger) executionCount {
    if ((self = [super init])) {
        numberOfExecutions = executionCount;
    }
    
    return self;
}

- (void)setup{
    
    NSDictionary *bundleDictionary = [[NSBundle mainBundle] infoDictionary];
    
    if (numberOfExecutions == [[bundleDictionary objectForKey:kSTRateRunCount] intValue]) {
        NSString *title = NSLocalizedString([bundleDictionary objectForKey:kSTRateTitle], nil);
        NSString *message = NSLocalizedString([bundleDictionary objectForKey:kSTRateMessage], nil);
        
        
        
        AlertBlock *alert = [[AlertBlock alloc] initWithTitle:title
                                                      message:message
                                            cancelButtonTitle:@"下次再说"
                                            otherButtonTitles:@"立即评分"
                                                        block:^(NSInteger buttonIndex) {
                                                            //在这里面执行触发的行为，省掉了代理，这样的好处是在使用多个Alert的时候可以明确定义各自触发的行为，不需要在代理方法里判断是哪个Alert了
                                                            if (buttonIndex == 0) {
                                                                //重设为1
                                                                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kSTRateRunCountDefault];
                                                            }
                                                            else if (buttonIndex == 1){
                                                                NSString *evaluateString = nil;
                                                                NSString *appId = [[[NSBundle mainBundle] infoDictionary] objectForKey:kSTRateAppID];
                                                                
                                                                if (isIOS7) {
                                                                    evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
                                                                }
                                                                else{
                                                                    evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
                                                                }
                                                                
                                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
                                                            }
            
        }];
        [alert show];
    }
}



@end
