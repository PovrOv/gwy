//
//  GrouponNetApiClient.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/7/30.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIUrl.h"

typedef enum : NSUInteger {
    GET = 0,
    POST,
    PUT,
    DELETE,
    UPDATE
} NetworkMethod;


@interface GoldenLeafNetApiClient : AFHTTPRequestOperationManager
+ (instancetype)shareJsonClient;

- (void)requestJsonDataWithPath:(NSString *)path
                     withParams:(NSMutableDictionary *)params
                 withMethodType:(NSUInteger)networkMethod
                       andBlock:(void(^)(id data, NSError *error))block;
- (void)requestJsonDataWithPath:(NSString *)path
                     withParams:(NSDictionary *)params
                 withMethodType:(NSUInteger)networkMethod
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id, NSError *))block;

- (void)requestJsonDataWithPath:(NSString *)path
                           file:(NSDictionary *)file
                     withParams:(NSDictionary *)params
                 withMethodType:(NSUInteger)networkMethod
                       andBlock:(void(^)(id data, NSError *error))block;
- (void)uploadImage:(UIImage *)image
               path:(NSString *)path
               name:(NSString *)name
       successBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
       failureBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
      progressBlock:(void(^)(CGFloat progressValue))progress;


@end
