//
//  GrouponNetworkAPIManager.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/7/30.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "GoldenLeafNetworkAPIManager.h"
#import "GoldenLeafNetApiClient.h"
#import "AFHTTPRequestOperation.h"

@implementation GoldenLeafNetworkAPIManager
+ (instancetype)shareManager{
    static GoldenLeafNetworkAPIManager *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[GoldenLeafNetworkAPIManager alloc] init];
    });
    return _shareManager;
}

- (void)request_getMobilePhoneCodeWithParams:(id)params andBlock:(void (^)(id, NSError *))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"cvc" withParams:params withMethodType:POST andBlock:^(id data, NSError *error) {
        if (data) {
            block(data,nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
    }];
}

- (void)request_registerWithParams:(id)params andBlock:(void (^)(id, NSError *))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"/api/v1/users" withParams:params withMethodType:POST andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
    }];
}


- (void)request_thirdRegisterWithParams:(id)params
                               andBlock:(void(^)(id data, NSError *error))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"ThirdR" withParams:params withMethodType:POST andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
    }];
}

- (void)request_loginWithParams:(id)params
                       andBlock:(void(^)(id data, NSError *error))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"/api/v1/login" withParams:params withMethodType:POST andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
    }];
}

- (void)request_logoutWithParams:(id)params
                        andBlock:(void(^)(id data, NSError *error))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"logout" withParams:params withMethodType:POST andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }

    }];
}

#pragma mark - about user infomation
- (void)request_changePasswordWithParams:(id)params
                                andBlock:(void(^)(id data, NSError *error))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"ep" withParams:params withMethodType:POST andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }

    }];
}

- (void)request_changeUserInfomationWithParams:(id)params
                                      andBlock:(void(^)(id data, NSError *error))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"cp" withParams:params withMethodType:POST andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
    }];
}

- (void)request_getUserInfomationWithParams:(id)params
                                   andBlock:(void(^)(id data, NSError *error))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"gp" withParams:params withMethodType:GET andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
    }];
}

- (void)request_getWeatherWithCityName:(NSString *)city andBlock:(void (^)(id, NSError *))block{
    NSString *str = [NSString stringWithFormat:@"http://api.map.baidu.com/telematics/v3/weather?location=%@&output=json&ak=VfoUZbwe3PkWwSMFYarn3h1a&mcode=ED:18:E8:77:48:58:DD:BB:CC:61:6A:FA:07:89:AD:82:84:EC:D3:34;com.slbw.citymanager", city];
    NSString *sUrlM = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, nil, nil, kCFStringEncodingUTF8));
    
    [[GoldenLeafNetApiClient shareJsonClient] GET:sUrlM parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *data = (NSDictionary *)responseObject;
        NSString *state;
        if ([data[@"status"] isKindOfClass:[NSString class]]) {
            state = data[@"status"];
        }else{
            state = @"";
        }
        if ([state isEqualToString:@"success"]) {
            block(data, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)request_getArticleListWithPath:(NSDictionary *)dic andBlock:(void (^)(id, NSError *))block{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"/api/v1/articles" withParams:dict withMethodType:GET andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        if(error){
            block(nil, error);
        }else{
            block(data, nil);
        }
//        if ([data[@"status"] isEqualToString:@"success"]) {
//            block(data, nil);
//        }
    }];
}

- (void)request_getClinicsListWithParams:(id)dic andBlock:(void (^)(id, NSError *))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"/api/v1/clinics" withParams:dic withMethodType:GET andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        if (data) {
            block(data, nil);
        }
    }];
}

- (void)request_getClinicsDetailWithPath:(NSString *)path andBlock:(void (^)(id, NSError *))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:GET andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        if (data) {
            block(data, nil);
        }
    }];

}

//- (void)request_getTopicsListWithParams:(NSMutableDictionary *)dic andBlock:(void (^)(id, NSError *))block{
//    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"/api/v1/topics" withParams:dic withMethodType:GET andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
//        if (data) {
//            block(data, nil);
//        }
//    }];
//}

- (void)request_getTopicsListWithParams:(NSMutableDictionary *)dic andBlock:(void (^)(id, NSError *))block{
//    ?sort=created_at,desc
    [dic setObject:@"created_at,desc" forKey:@"sort"];
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"/api/v1/announcements" withParams:dic withMethodType:GET andBlock:^(id data, NSError *error) {
//                DebugLog(@"%@", data);
                if (data) {
                    block(data, nil);
                }
            }];

}

- (void)request_getTopicsDetailWithPath:(NSString *)path andBlock:(void (^)(id, NSError *))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:GET andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        if (data) {
            block(data, nil);
        }
    }];
}

- (void)request_getUserInfoWithPath:(NSString *)path andBlock:(void (^)(id, NSError *))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:GET andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        if (data) {
            block(data, nil);
        }
    }];
}

- (void)request_createTopicsWithParams:(NSMutableDictionary *)dict andBlock:(void (^)(id, NSError *))block{
    
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"/api/v1/announcements" withParams:dict withMethodType:POST andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
    }];
}

- (void)request_updateUserInfoWithParams:(NSMutableDictionary *)dict andBlock:(void (^)(id, NSError *))block{
    NSString *path = [NSString stringWithFormat:@"%@%@",@"/api/v1/users/", [User shareUser].userID ];
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:dict withMethodType:PUT andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }

    }];
}

- (void)request_updateUserImage:(NSMutableDictionary *)dict andBlock:(void(^)(id data, NSError *error))block{
    NSString *path = [NSString stringWithFormat:@"%@%@",@"/api/v1/users/", [User shareUser].userID ];
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:PUT andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
        
    }];
}
- (void)request_categoriesWithParams:(NSMutableDictionary *)dict andBlock:(void (^)(id, NSError *))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"/api/v1/categories" withParams:dict withMethodType:GET andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
    }];
}

- (void)request_getUserListWithPath:(NSString *)path andBlock:(void (^)(id, NSError *))block{
//    author=Y
//    NSDictionary *dict = @{@"author":@"Y"};
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:GET andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        if (data) {
            block(data, nil);
        }
    }];
}

- (void)request_getGroupTopicsListWithParams:(NSMutableDictionary *)dic andBlock:(void (^)(id, NSError *))block{
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"/api/v1/topics?sort=created_at,desc" withParams:dic withMethodType:GET andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
    }];
}

- (void)request_getGroupReplyListWithTopicID:(NSString *)topicID andBlock:(void (^)(id, NSError *))block{
    NSString *path = [NSString stringWithFormat:@"/api/v1/topics/%@/replies?sort=created_at,desc", topicID];
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:GET andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
    }];
}


- (void)request_createRepltWithParams:(NSMutableDictionary *)dict topicID:(NSString *)topicID  andBlock:(void (^)(id, NSError *))block{
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/topics/%@/replies", topicID];
    
        [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:dict withMethodType:POST andBlock:^(id data, NSError *error) {
            if (data) {
                block(data, nil);
//                DebugLog(@"%@", data);
            }else{
                block(nil, error);
//                DebugLog(@"%@", error);
            }
        }];
}

- (void)request_createTopicWithParams:(NSMutableDictionary *)dict withData:(NSData *)dataM andBlock:(void (^)(id, NSError *))block{
    
    if ([User shareUser].topicData) {
        [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"/api/v1/topics" withParams:dict withMethodType:CREATE andBlock:^(id data, NSError *error) {
            if (data) {
                block(data, nil);
//                DebugLog(@"%@", data);
            }else{
                block(nil, error);
//                DebugLog(@"%@", error);
            }
        }];

    }else{
       
        [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:@"/api/v1/topics" withParams:dict withMethodType:POST andBlock:^(id data, NSError *error) {
            if (data) {
                block(data, nil);
//                DebugLog(@"%@", data);
            }else{
                block(nil, error);
//                DebugLog(@"%@", error);
            }
        }];
    }
}

- (void)request_updateUserImageWithParams:(NSMutableDictionary *)dict withData:(NSData *)dataM andBlock:(void (^)(id, NSError *))block{
    NSString *path = [NSString stringWithFormat:@"%@%@",@"/api/v1/users/", [User shareUser].userID ];
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:dict withMethodType:PUT andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
//            DebugLog(@"%@", data);
        }else{
            block(nil, error);
//            DebugLog(@"%@", error);
        }
        
    }];
}




//remind list
- (void)request_getRemindWithBlock:(void (^)(id, NSError *))block{
    NSString *path = [NSString stringWithFormat:@"%@%@/reminders",@"/api/v1/users/", [User shareUser].userID ];
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:GET andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
            //            DebugLog(@"%@", data);
        }else{
            block(nil, error);
            //            DebugLog(@"%@", error);
        }
        
    }];
}


//create remind
//remind list

- (void)request_updateRemindWithParams:(NSMutableDictionary *)params withReminder_id:(long)Rid andBlock:(void (^)(id, NSError *))block{

    NSString *path = [NSString stringWithFormat:@"%@%@/reminders/%ld",@"/api/v1/users/", [User shareUser].userID,Rid];
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:PUT andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
            //            DebugLog(@"%@", data);
        }else{
            block(nil, error);
            //            DebugLog(@"%@", error);
        }
        
    }];
}

- (void)request_createRemindWithParams:(NSMutableDictionary *)params andBlock:(void (^)(id, NSError *))block{
    
    NSString *path = [NSString stringWithFormat:@"%@%@/reminders",@"/api/v1/users/", [User shareUser].userID];
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:POST andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
            //            DebugLog(@"%@", data);
        }else{
            block(nil, error);
            //            DebugLog(@"%@", error);
        }
        
    }];
}

- (void)request_deleteRemindWithReminder_id:(long)Rid andBlock:(void (^)(id, NSError *))block{
    NSString *path = [NSString stringWithFormat:@"%@%@/reminders/%ld",@"/api/v1/users/", [User shareUser].userID,Rid];
    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:DELETE andBlock:^(id data, NSError *error) {
        if (data) {
            block(data, nil);
            //            DebugLog(@"%@", data);
        }else{
            block(nil, error);
            //            DebugLog(@"%@", error);
        }
        
    }];
}

//- (void)request_updateRemindWithParams:(NSMutableDictionary *)params andBlock:(void (^)(id, NSError *))block{
//    NSString *path = [NSString stringWithFormat:@"%@%@/reminders",@"/api/v1/users/", [User shareUser].userID ];
//    [[GoldenLeafNetApiClient shareJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:PUT andBlock:^(id data, NSError *error) {
//        if (data) {
//            block(data, nil);
//            //            DebugLog(@"%@", data);
//        }else{
//            block(nil, error);
//            //            DebugLog(@"%@", error);
//        }
//        
//    }];
//}
@end
