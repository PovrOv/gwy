//
//  RegisterViewModel.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/19.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "RegisterViewModel.h"

@implementation RegisterViewModel

//- (RACSignal *)registerButtonIsVisible{
//    return [RACSignal combineLatest:@[RACObserve(self, userName), RACObserve(self, sex), RACObserve(self, date), RACObserve(self, address), RACObserve(self, passworldOne), RACObserve(self, passworldTwo)] reduce:^id(NSString *userName, NSString *sex, NSString *date, NSString *address, NSString *passworldOne, NSString *passworldTwo){
//        return @((userName.length >0) && (sex.length > 0) && (date.length > 0) && (address.length > 0) && (passworldOne.length >0 ) && ([passworldOne isEqualToString:passworldTwo ]));
//    }];
//}
- (RACSignal *)registerButtonIsVisible{
    return [RACSignal combineLatest:@[RACObserve(self, userName), RACObserve(self, sex), RACObserve(self, date), RACObserve(self, passworldOne), RACObserve(self, passworldTwo)] reduce:^id(NSString *userName, NSString *sex, NSString *date, NSString *passworldOne, NSString *passworldTwo){
        return @((userName.length >0) && (date.length > 0) && (passworldOne.length >0 ) &&(passworldTwo.length > 0));
    }];
}

- (RACSignal *)registerDoctorButtonIsVisible{
    return [RACSignal combineLatest:@[RACObserve(self, userName), RACObserve(self, sex), RACObserve(self, address), RACObserve(self, passworldOne), RACObserve(self, passworldTwo), RACObserve(self, positionaltitles), RACObserve(self, hospital), RACObserve(self, department), RACObserve(self, telPhoneNum), RACObserve(self, emailAddress)] reduce:^id(NSString *userName, NSString *sex, NSString *address, NSString *passworldOne, NSString *passworldTwo, NSString *positionaltitles, NSString *hospital, NSString *department, NSString *telPhoneNum, NSString *emailAddress){
        return @((userName.length >0) && (address.length > 0) && (passworldOne.length >0 )&&(passworldTwo.length > 0)&& (positionaltitles.length >0) && (hospital.length >0) && (department.length>0) && (telPhoneNum.length >0) && (emailAddress.length >0));
    }];
}
- (void)request_RegisterWith:(NSMutableDictionary *)dict andBlock:(void (^)(BOOL))block{
    [[GoldenLeafNetworkAPIManager shareManager] request_registerWithParams:dict andBlock:^(id data, NSError *error) {
        DebugLog(@"%@", data);
        if ([data[@"success"] integerValue] == 1) {
            User *user = [User shareUser];
            [[NSUserDefaults standardUserDefaults] setObject:data[@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            user.token = data[@"token"];
            user.user_name = data[@"data"][@"user_name"];
            user.phone_number = data[@"data"][@"phone_number"];
            user.email_address = data[@"data"][@"email_address"];
            user.type = data[@"data"][@"type"];
            user.userID = data[@"data"][@"id"];
            
            if ([data[@"data"][@"name"] isKindOfClass:[NSString class]]) {
               user.name = data[@"data"][@"name"];
            }else{
                user.name = @"";
            }
            
            [user saveToDisk];
            block(YES);
        }else{
            block(NO);
        }
    }];
}

- (void)request_RegisterDoctorWith:(NSMutableDictionary *)dict andBlock:(void (^)(BOOL))block{
    [[GoldenLeafNetworkAPIManager shareManager] request_registerWithParams:dict andBlock:^(id data, NSError *error) {
        DebugLog(@"%@", data);
        if ([data[@"success"] integerValue] == 1) {
            User *user = [User shareUser];
            [[NSUserDefaults standardUserDefaults] setObject:data[@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            user.token = data[@"token"];
            user.user_name = data[@"data"][@"user_name"];
            user.phone_number = data[@"data"][@"phone_number"];
            user.email_address = data[@"data"][@"email_address"];
            user.type = data[@"data"][@"type"];
            user.userID = data[@"data"][@"id"];
            if ([data[@"data"][@"name"] isKindOfClass:[NSString class]]) {
                user.name = data[@"data"][@"name"];
            }else{
                user.name = @"";
            }
            [user saveToDisk];
            block(YES);
        }else{
            block(NO);
        }
    }];
}
@end

