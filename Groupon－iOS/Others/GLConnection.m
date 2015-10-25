//
//  GLConnection.m
//  GoldenLeaf
//
//  Created by Sissi Chen on 7/15/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

#import "NSString+BBStringAdditions.h"
#import "NSString+HTTPParsing.h"
#import "NSObject+BBNSObjectAdditions.h"
#import "NSDictionary+HTTPParsing.h"

#import "GLConnection.h"

#define TIMEOUT_INTERVAL 60.0f

@interface GLConnection () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSObject *parameters;

@end

@implementation GLConnection

+ (void)getRequestWithPath:(NSString *)path
                 onSuccess:(OnSuccessBlock)onSuccess
                   onError:(OnErrorBlock)onError {
    [GLConnection connectionWithURL:[GLConnection URLWithPath:path]
                             method:ConnectionGET
                         parameters:nil
                          onSuccess:^(NSDictionary *json) {
                              onSuccess(json);
                          } onError:^(NSError *error) {
                              onError(error);
                          }];
}

+ (void)postRequestWithPath:(NSString *)path
                 parameters:(NSDictionary *)parameters
                  onSuccess:(OnSuccessBlock)onSuccess
                    onError:(OnErrorBlock)onError {
    [GLConnection connectionWithURL:[GLConnection URLWithPath:path]
                             method:ConnectionPOST
                         parameters:parameters
                          onSuccess:^(NSDictionary *json) {
                              onSuccess(json);
                          } onError:^(NSError *error) {
                              onError(error);
                          }];
}

+ (void)deleteRequestWithPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
                    onSuccess:(OnSuccessBlock)onSuccess
                      onError:(OnErrorBlock)onError {
    [GLConnection connectionWithURL:[GLConnection URLWithPath:path]
                             method:ConnectionDELETE
                         parameters:parameters
                          onSuccess:^(NSDictionary *json) {
                              onSuccess(json);
                          } onError:^(NSError *error) {
                              onError(error);
                          }];
    
}

#pragma mark - construction

+ (GLConnection *)connectionWithURL:(NSURL *)url
                             method:(NSString *)method
                         parameters:(NSObject *)parameters
                          onSuccess:(OnSuccessBlock)onSuccess
                            onError:(OnErrorBlock)onError {
    return [[GLConnection alloc] initWithURL:url
                                      method:method
                                  parameters:parameters
                                   onSuccess:(OnSuccessBlock)onSuccess
                                     onError:(OnErrorBlock)onError];
}

- (instancetype)initWithURL:(NSURL *)url
                     method:(NSString *)method
                 parameters:(NSObject *)parameters
                  onSuccess:(OnSuccessBlock)onSuccess
                    onError:(OnErrorBlock)onError {
    if ((self = [super init])) {
        self.url = url;
        self.onSuccess = onSuccess;
        self.onError = onError;
        self.parameters = parameters;
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        
        if ([method isEqualToString:ConnectionGET]) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:TIMEOUT_INTERVAL];
            
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            [self taskWithSession:session request:request];
        } else {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:TIMEOUT_INTERVAL];
            request.HTTPMethod = method;
            
            if (parameters != nil) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
                [request setHTTPBody:data];
                [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                
                [self taskWithSession:session request:request];
            }
        }
    }
    
    return self;
}

- (void)taskWithSession:(NSURLSession *)session request:(NSURLRequest *)request {
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            if (((NSHTTPURLResponse *)response).statusCode >= 400) {
                NSString *description = @"An unknown error has occurred";
                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                if ([userInfo isValidDictionary]) {
                    if ([userInfo[@"value"] isValidString]) {
                        description = userInfo[@"value"];
                    } else if ([userInfo[@"value"] isValidArray]) {
                        description = @"";
                        
                        for (NSString *valueString in userInfo[@"value"]) {
                            description = [description stringByAppendingString:valueString];
                        }
                    }
                } else {
                    NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    if ([responseData isValidString]) {
                        description = responseData;
                    }
                }
                
                NSError *resError = [[NSError alloc] initWithDomain:@"com.goldenLeaf.connection" code:((NSHTTPURLResponse *)response).statusCode userInfo:@{NSLocalizedDescriptionKey: description}];
                
                self.onError(resError);
            } else {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                self.onSuccess(json);
            }
        } else {
            self.onError(error);
        }
    }];
    
    [dataTask resume];
}

#pragma mark - url helpers

+ (NSURL *)URLWithPath:(NSString *)path {
    // use default host
    NSString *host = @"120.26.113.30:8080/api/v1";
    return [GLConnection absoluteURLWithPath:path host:host];
}

+ (NSURL *)absoluteURLWithPath:(NSString *)path host:(NSString *)host {
    if ([[NSURL URLWithString:path] host]) {
        return [NSURL URLWithString:path];
    } else {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/%@", host, path];
        return [NSURL URLWithString:[urlString stringByURLEncoding]];
    }
}

@end
