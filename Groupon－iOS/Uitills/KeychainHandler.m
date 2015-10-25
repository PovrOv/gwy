//
//  KeychainHandler.m
//  GlodenLeaf
//
//  Created by Sissi Chen  on 3/3/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

#import "KeychainHandler.h"

#import "KeychainItemWrapper.h"

@implementation KeychainHandler

+ (void)storeCredentialsWithUsername:(NSString *)username andPassword:(NSString *)password{
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:[[NSBundle mainBundle] bundleIdentifier] accessGroup:nil];
    
    [keychainItem resetKeychainItem];
    
    [keychainItem setObject:username forKey:(__bridge id)(kSecAttrAccount)];
    [keychainItem setObject:password forKey:(__bridge id)(kSecValueData)];
    
}

+ (void)changeUsername:(NSString *)username {
    NSDictionary *credentials = [self getStoredCredentials];
    [self storeCredentialsWithUsername:username andPassword:credentials[@"Password"]];
}

+ (void)changePassword:(NSString *)password {
    NSDictionary *credentials = [self getStoredCredentials];
    [self storeCredentialsWithUsername:credentials[@"Username"] andPassword:password];
}

+ (NSDictionary *)getStoredCredentials{
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:[[NSBundle mainBundle] bundleIdentifier] accessGroup:nil];
    
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                username,
                                                password,
                                                nil]
                                       forKeys:[NSArray arrayWithObjects:
                                                [NSString stringWithFormat:@"Username"],
                                                [NSString stringWithFormat:@"Password"],
                                                nil]];
    
}

@end
