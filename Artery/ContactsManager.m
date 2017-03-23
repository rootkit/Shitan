//
//  ContactsManager.m
//  Shitan
//
//  Created by 刘敏 on 15/1/5.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ContactsManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "KeyChainUUID.h"

static ContactsManager *instance = nil;

@implementation ContactsManager

+ (id)shareInstance {
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


- (void)initDao
{
    if (!_dao) {
        _dao = [[UserRelationshipDAO alloc] init];
    }
}


//延迟载入
- (void)delayLoadContacts
{
    [self performSelector:@selector(loadContacts) withObject:nil afterDelay:1.0];
}


// 导入通讯录
- (void)loadContacts
{

    [self initDao];
    
    NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
    NSMutableArray *bookArray = [[NSMutableArray alloc] init];
    
    CFErrorRef error;
    ABAddressBookRef myAddressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (!myAddressBook)
    {
        CLog(@"get addressBook failed:%@", error);
        CFRelease(error);

        return ;
    }
    else
    {
        ABAddressBookRequestAccessWithCompletion(myAddressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     if (granted)
                                                     {
                                                         NSLog(@"granted");
                                                     }
                                                     else
                                                     {
                                                         NSLog(@"%@", error);
                                                         CFRelease(error);
                                                     }
                                                 });
    }
    

    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(myAddressBook);
    CFMutableArrayRef mresults=CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                                        CFArrayGetCount(results),
                                                        results);
    //将结果按照拼音排序，将结果放入mresults数组中
    CFArraySortValues(mresults,
                      CFRangeMake(0, CFArrayGetCount(results)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void *) ABPersonGetSortOrdering());
    
    
    
    
    
    //遍历所有联系人
    for (int k=0; k<CFArrayGetCount(mresults); k++) {
        
        ABRecordRef record=CFArrayGetValueAtIndex(mresults,k);
        NSString *personname = (__bridge NSString *)ABRecordCopyCompositeName(record);
        
        ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
        
        //一个人可能有多个号码
        NSMutableArray *sArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            
            if ([personPhone length] > 4) {
                
                NSRange range = NSMakeRange(0,3);
                NSString *str = [personPhone substringWithRange:range];
                
                if ([str isEqualToString:@"+86"]) {
                    personPhone = [personPhone substringFromIndex:3];
                }
                
                //删除分隔符
                personPhone = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                [sArray addObject:personPhone];
            }
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        CLog(@"%@", sArray);
        
        //必须同时有姓名跟号码
        if (personname && sArray.count > 0) {
            
            for (NSString *phone in sArray)
            {
                if ([[AccountInfo sharedAccountInfo].mobile isEqualToString:phone]) {
                    break;
                }
                
                [dict setObject:personname forKey:@"name"];
                [dict setObject:sArray forKey:@"phone"];
                
                [phoneArray addObjectsFromArray:sArray];
                [bookArray addObject:dict];
                
                break;
            }
        }
    }

    [self uploadAddressBook:bookArray];
}


//上传通讯录
- (void)uploadAddressBook:(NSArray *)array
{
    
    [theAppDelegate.HUDManager hideHUD];
    
    if (!array && [array count] == 0) {
        return;
    }
    
    if (![AccountInfo sharedAccountInfo].userId) {
        return;
    }
    
    NSString* jsonString = [STJSONSerialization toJSONData:array];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [requestDict setObject:jsonString forKey:@"reqStr"];

    [requestDict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [requestDict setObject:[KeyChainUUID Value] forKey:@"deviceId"];
    
    [_dao requestSaveContacts:requestDict completionBlock:^(NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            CLog(@"成功");

        }
        else{
            CLog(@"%@", [result objectForKey:@"msg"]);
        }

        
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
    
}




@end
