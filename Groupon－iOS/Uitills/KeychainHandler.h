//
//  KeychainHandler.h
//  GlodenLeaf
//
//  Created by Sissi Chen  on 3/3/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainHandler : NSObject

+ (void)storeCredentialsWithUsername:(NSString *)username andPassword:(NSString *)password;
+ (NSDictionary *)getStoredCredentials;
+ (void)changeUsername:(NSString *)username;
+ (void)changePassword:(NSString *)password;

@end
