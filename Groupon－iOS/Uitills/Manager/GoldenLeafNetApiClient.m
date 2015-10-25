//
//  GrouponNetApiClient.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/7/30.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "GoldenLeafNetApiClient.h"

#import "NSString+MD5.h"

static NSString *const app_secret = @"tuangou_guizhou";

@interface GoldenLeafNetApiClient ()

@property(nonatomic, strong)NSArray *keys;

@end

@implementation GoldenLeafNetApiClient

+ (instancetype)shareJsonClient{
    static GoldenLeafNetApiClient *_shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareClient = [[GoldenLeafNetApiClient alloc] initWithBaseURL:[NSURL URLWithString:KNetpath_Code_Base]];
    });
    return _shareClient;
}
- (NSString *)encodeMD5WithDictionary:(NSDictionary *)dic {
    //將key按字母大小進行排序
    self.keys = [[dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 caseInsensitiveCompare:obj2] == NSOrderedDescending;
    }];
    
    //拼接字符串
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    for (NSString *key in self.keys) {
        NSString *string = [NSString stringWithFormat:@"%@%@",key,dic[key]];
        [valueArray addObject:string];
    }
    //拼接urlString
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:[valueArray componentsJoinedByString:@""]];
    //    //首尾插入一段特定字符串
    //    [urlString insertString:CODE_DEFAULT atIndex:0];
    //    [urlString insertString:CODE_DEFAULT atIndex:urlString.length];
    
    NSLog(@"\n\nurlString:%@\nMD5:%@\n\n",urlString,[urlString md5Encrypt]);
    
    //md5加密并返回
    return [urlString md5Encrypt];
    
    
}

- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
//    self.requestSerializer = [AFJSONRequestSerializer serializer];
//    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
//    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
//        self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    self.responseSerializer = [AFJSONResponseSerializer serializer];
//    self.requestSerializer = [AFJSONRequestSerializer serializer];
////    self.requestSerializer = [AFHTTPRequestSerializer serializer];
////    self.responseSerializer = [AFHTTPResponseSerializer serializer];
//    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];

    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    self.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    if ([User shareUser].islogin) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        [self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)path withParams:(NSMutableDictionary *)params withMethodType:(NSUInteger)networkMethod andBlock:(void (^)(id, NSError *))block{
//    //获得系统时间
//    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
//    NSString *timeStr = [NSString stringWithFormat:@"%0.f", ts*1000];
//    DebugLog(@"%@", timeStr);
    
   NSString *urlStr = [NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,path];

    [self requestJsonDataWithPath:urlStr withParams:params withMethodType:networkMethod autoShowError:YES andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil, error);
        }else{
            block(data, nil);
        }
    }];
}

- (void)requestJsonDataWithPath:(NSString *)path withParams:(NSDictionary *)params withMethodType:(NSUInteger)networkMethod autoShowError:(BOOL)autoShowError andBlock:(void (^)(id, NSError *))block{
    if (!path || path.length <= 0) {
        return;
    }
    if ([User shareUser].islogin) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        [self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
//    [self.requestSerializer setValue:@"image/png" forKey:@"content-type"];
    
    
//    DebugLog(@"\n===========path:%@ \n===========params:%@", path, params);
//    path = @"http://115.29.248.18:8081/APP/rest";
//    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    switch (networkMethod) {
        case GET:{
            [self GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                DebugLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                DebugLog(@"\n===========response===========\n%@:\n%@", path, error);
                block(nil, error);
            }];
        }
            break;
        case POST:{
            [self POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                DebugLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                DebugLog(@"\n===========response===========\n%@:\n%@", path, error);
                block(nil, error);
            }];
        }
            break;
        case PUT:{
            [self PUT:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                DebugLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                DebugLog(@"\n===========response===========\n%@:\n%@", path, error);
                block(nil, error);
            }];
        }
            break;
        case DELETE:{
            [self POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                NSData *dataM;
                NSRange range = [path rangeOfString:@"/api/v1/users/"];
                if (range.length > 0) {
                    dataM = [User shareUser].userImageData;
                    UIImage *image = [UIImage imageNamed:@"appicon_1024"];
//                    NSData* data = [User shareUser].userImageData;
                    if (dataM == nil) {
                        dataM = UIImageJPEGRepresentation(image, 0.2);
                    }
                }else{
                    dataM = [User shareUser].topicData;
                }
//                DebugLog(@"");
                
//                NSData *data  = UIImageJPEGRepresentation([User shareUser].topicData, 0.1);
                // 可以在上传时使用当前的系统事件作为文件名
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                       // 设置时间格式
                
                formatter.dateFormat = @"yyyyMMddHHmmss";
                
                NSString *str = [formatter stringFromDate:[NSDate date]];
                
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                
                [formData appendPartWithFileData:dataM name:@"picture" fileName:fileName mimeType:@"image/png"];
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                block(responseObject, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                block(nil, error);
            }];
        }
            break;
            
        default:
            break;
    }
    
    
    
}

-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError{
    NSError *error = nil;
    //code为非0值时，表示有错
//    NSNumber *resultCode = [responseJSON valueForKeyPath:@"code"];
    
//    if (resultCode.intValue != 0) {
//        error = [NSError errorWithDomain:kNetPath_Code_Base code:resultCode.intValue userInfo:responseJSON];
//        if (autoShowError) {
////            [self showError:error];
//        }
//        
//        if (resultCode.intValue == 1000 || resultCode.intValue == 3207) {//用户未登录
//            [Login doLogout];
//            [((AppDelegate *)[UIApplication sharedApplication].delegate) setupIntroductionViewController];
//        }
//    }
    return error;
}

@end
