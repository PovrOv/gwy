//
//  User.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/19.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString *email_address;
@property (nonatomic, strong) NSString *phone_number;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *token;
@property (nonatomic ,strong) NSString *type;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *passworld;
@property (nonatomic, strong) NSString *birth_day;
@property (nonatomic, strong) NSString *birth_month;
@property (nonatomic, strong) NSString *birth_year;
@property (nonatomic, strong) NSString *city;

@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *healthTitle;
@property (nonatomic, strong) NSString *clinicTitle;
@property (nonatomic, strong) NSString *announcement;

@property (nonatomic, strong) NSData *topicData;

@property (nonatomic, strong) NSData *userImageData;

+ (instancetype)shareUser;
- (BOOL)islogin;
- (void)saveToDisk;
- (void)cleareUser;
@end
