//
//  GLConnection.m
//  GoldenLeaf
//
//  Created by Sissi Chen on 7/15/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

@import Foundation;

typedef void (^OnSuccessBlock)(id result);
typedef void (^OnErrorBlock)(NSError *error);

#define ConnectionGET @"GET"
#define ConnectionPOST @"POST"
#define ConnectionPUT @"PUT"
#define ConnectionDELETE @"DELETE"

/**
 This is a wrapper class to issue REST requests to the REST API.
 There is NO extra thread/queue handling.
 */


@interface GLConnection : NSObject

@property (nonatomic, strong) OnSuccessBlock onSuccess;
@property (nonatomic, strong) OnErrorBlock onError;

/**
@param path "/users/:user_id"
 */
+ (void)getRequestWithPath:(NSString *)path
                 onSuccess:(OnSuccessBlock)onSuccess
                   onError:(OnErrorBlock)onError;

+ (void)postRequestWithPath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                  onSuccess:(OnSuccessBlock)onSuccess
                    onError:(OnErrorBlock)onError;

+ (void)deleteRequestWithPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
                    onSuccess:(OnSuccessBlock)onSuccess
                      onError:(OnErrorBlock)onError;

+ (GLConnection *)connectionWithURL:(NSURL *)url
                             method:(NSString *)method
                         parameters:(NSObject *)parameters
                          onSuccess:(OnSuccessBlock)onSuccess
                            onError:(OnErrorBlock)onError;

+ (NSURL *)absoluteURLWithPath:(NSString *)path host:(NSString *)host;

@end
