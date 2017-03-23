//
//  KeyChainUUID.m
//  KeyChainUDID
//
//  Created by Emck on 8/17/13.
//  Copyright (c) 2013 Apptem. All rights reserved.
//

#import "KeyChainUUID.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>

static NSString * AKeyChainUUIDSessionCache = nil;
static NSString * const aKeyChainUUIDIdentifier = @"com.apptem.KeyChainUUID";
static NSString * const aKeyChainUUIDKey = @"KeyChainUUID";

@implementation KeyChainUUID


+ (NSString *)Value
{
    // 1. Check Cache
    if (AKeyChainUUIDSessionCache != nil) {     // if exist return cache
        return AKeyChainUUIDSessionCache;
    }
    // 2. no Cache, get from KeyChain
    AKeyChainUUIDSessionCache = [KeyChainUUID getKeyChainUUID];
    if (AKeyChainUUIDSessionCache != nil) return AKeyChainUUIDSessionCache;
    // 3. no KeyChain, create new
    // Create KeyChainUUID and Save
    NSMutableDictionary *KeyChainUUIDPairs = [NSMutableDictionary dictionary];
    [KeyChainUUIDPairs setObject:[KeyChainUUID makeUUID] forKey:aKeyChainUUIDKey];
    [KeyChainUUID saveObject:KeyChainUUIDPairs];

    // 4. again,get from KeyChain
    AKeyChainUUIDSessionCache = [KeyChainUUID getKeyChainUUID];
    return AKeyChainUUIDSessionCache;
}

+ (NSString *)makeUUID
{
    NSBundle *bundle =[NSBundle mainBundle];
    NSDictionary *infos =[bundle infoDictionary];
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    // Combination: random + App BundleIdentifier + Time
    NSString *BundleIdentifier = [NSString stringWithFormat:@"%d%@%f", (NSUInteger)(arc4random() % NSUIntegerMax),[infos objectForKey:@"CFBundleIdentifier"],now];
    
    const char *cStr = [BundleIdentifier UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    
    NSString *KeyChainUUID = [NSString stringWithFormat:
                 @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08x",
                 result[0], result[1], result[2], result[3],
                 result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11],
                 result[12], result[13], result[14], result[15],
                 (NSUInteger)(arc4random() % NSUIntegerMax)];    
    return KeyChainUUID;
}

// Delete KeyChain UUID
+ (void)Renew
{
    [KeyChainUUID deleteKeychain:aKeyChainUUIDIdentifier];
}

+ (NSString *)getKeyChainUUID
{
    NSMutableDictionary *KeyChainUUIDPairs = (NSMutableDictionary *)[KeyChainUUID loadKeychainData:aKeyChainUUIDIdentifier];
    if (KeyChainUUIDPairs == nil) return nil;                 // is nil
    return [KeyChainUUIDPairs objectForKey:aKeyChainUUIDKey];
}

// Save Objec to KeyChain
+ (void)saveObject:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self makeKeychain:aKeyChainUUIDIdentifier];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

// Make Keychain
+ (NSMutableDictionary *)makeKeychain:(NSString *)Identifier {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            Identifier, (__bridge id)kSecAttrService,
            Identifier, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

// Load Keychain
+ (id)loadKeychainData:(NSString *)Identifier
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self makeKeychain:Identifier];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
        } @finally { }
    }
    if (keyData) CFRelease(keyData);
    return ret;
}

// Delete Keychain
+ (void)deleteKeychain:(NSString *)Identifier
{
    NSMutableDictionary *keychainQuery = [self makeKeychain:Identifier];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

@end