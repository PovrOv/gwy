//
//  LoginViewModel.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (RACSignal *)loginButtonIsVisible{
    return [RACSignal combineLatest:@[RACObserve(self, nameStr), RACObserve(self, passworldStr)] reduce:^id(NSString *name, NSString *passworld){
        return @((name.length > 0) && passworld.length >0);
    }];

}

+ (void)loginRequest_Params:(NSMutableDictionary *)dict andBlock:(void (^)(BOOL))block{
    [[GoldenLeafNetworkAPIManager shareManager] request_loginWithParams:dict andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        if (data) {
            User *user = [User shareUser];
            [[NSUserDefaults standardUserDefaults] setObject:data[@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            user.token = [data[@"token"] safeCastToString];
            user.user_name = [data[@"data"][@"user_name"] safeCastToString];
            user.phone_number = [data[@"data"][@"phone_number"] safeCastToString];
            user.email_address = [data[@"data"][@"email_address"] safeCastToString];
            user.type = [data[@"data"][@"type"] safeCastToString];
            user.userID = [data[@"data"][@"id"] safeCastToString];
            
            NSDictionary *dataM = data[@"data"];
            user.birth_day = [dataM[@"birth_day"] safeCastToString];
            user.birth_month = [dataM[@"birth_month"] safeCastToString];
            user.birth_year = [dataM[@"birth_year"] safeCastToString];
            user.city = [dataM[@"city"] safeCastToString];
            user.sex = [dataM[@"sex"] safeCastToString];
            if ([dataM[@"data"][@"name"] isKindOfClass:[NSString class]]) {
                user.name = dataM[@"data"][@"name"];
            }else{
                user.name = @"";
            }
            
            user.passworld = dict[@"password"];
            [user saveToDisk];
            block(YES);
        }else{
            block(NO);
            
        }
    }];
}

@end
