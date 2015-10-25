//
//  RegisterViewModel.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/19.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterViewModel : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *passworldOne;
@property (nonatomic, strong) NSString *passworldTwo;

@property (nonatomic, strong) NSString *positionaltitles;
@property (nonatomic, strong) NSString *hospital;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *telPhoneNum;
@property (nonatomic, strong) NSString *emailAddress;

- (RACSignal *)registerButtonIsVisible;

- (RACSignal *)registerDoctorButtonIsVisible;

- (void)request_RegisterWith:(NSMutableDictionary *)dict andBlock:(void(^)(BOOL success))block;

- (void)request_RegisterDoctorWith:(NSMutableDictionary *)dict andBlock:(void(^)(BOOL success))block;
@end


