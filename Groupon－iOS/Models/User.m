//
//  User.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/19.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "User.h"

static NSString *const KEmail_Address = @"email_address";
static NSString *const KPhone_Number = @"phone_number";
static NSString *const KUser_Name = @"user_name";
static NSString *const Ktoken = @"token";

static NSString *const KfileName = @"user.dat";
static NSString *const KType = @"type";

static NSString *const KUserID = @"KUserID";

static User *_user = nil;

static NSString *const Kannouncment = @"Kannouncment";
static NSString *const Khealthy = @"Khealthy";
static NSString *const Kclinic = @"Kclinic";

static NSString *const KData = @"KData";
static NSString *const KUserData = @"KUserData";

static NSString *const Kbirth_day = @"birth_day";
static NSString *const Kbirth_month = @"birth_month";
static NSString *const Kbirth_year = @"birth_year";
static NSString *const Kcity = @"city";
static NSString *const Ksex = @"sex";
static NSString *const Kname = @"name";

static NSString *const KPassWord = @"KPassWord";
@implementation User
+(instancetype)shareUser{
    if (!_user) {
        @try {
            _user = [NSKeyedUnarchiver unarchiveObjectWithFile:User.getFilePath];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            if (!_user) {
                _user = [[User alloc] init];
            }
        }
    }
    return _user;
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.email_address = [aDecoder decodeObjectForKey:KEmail_Address];
        self.phone_number = [aDecoder decodeObjectForKey:KPhone_Number];
        self.user_name = [aDecoder decodeObjectForKey:KUser_Name];
        self.token = [aDecoder decodeObjectForKey:Ktoken];
        self.type = [aDecoder decodeObjectForKey:KType];
        self.userID = [aDecoder decodeObjectForKey:KUserID];
        
        self.announcement = [aDecoder decodeObjectForKey:Kannouncment];
        self.healthTitle = [aDecoder decodeObjectForKey:Khealthy];
        self.clinicTitle = [aDecoder decodeObjectForKey:Kclinic];
        
        self.topicData = [aDecoder decodeObjectForKey:KData];
        self.userImageData = [aDecoder decodeObjectForKey:KUserData];
        
        self.birth_day = [aDecoder decodeObjectForKey:Kbirth_day];
        self.birth_month = [aDecoder decodeObjectForKey:Kbirth_month];
        self.birth_year = [aDecoder decodeObjectForKey:Kbirth_year];
        self.city = [aDecoder decodeObjectForKey:Kcity];
        self.sex = [aDecoder decodeObjectForKey:Ksex];
        self.name = [aDecoder decodeObjectForKey:Kname];
        self.passworld = [aDecoder decodeObjectForKey:KPassWord];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.email_address forKey:KEmail_Address];
    [aCoder encodeObject:self.phone_number forKey:KPhone_Number];
    [aCoder encodeObject:self.user_name forKey:KUser_Name];
    [aCoder encodeObject:self.token forKey:Ktoken];
    [aCoder encodeObject:self.type forKey:KType];
    [aCoder encodeObject:self.userID forKey:KUserID];
    
    [aCoder encodeObject:self.announcement forKey:Kannouncment];
    [aCoder encodeObject:self.healthTitle forKey:Khealthy];
    [aCoder encodeObject:self.clinicTitle forKey:Kclinic];
    
    [aCoder encodeObject:self.topicData forKey:KData];
    [aCoder encodeObject:self.userImageData forKey:KUserData];
    
    [aCoder encodeObject:self.birth_day forKey:Kbirth_day];
    [aCoder encodeObject:self.birth_month forKey:Kbirth_month];
    [aCoder encodeObject:self.birth_year forKey:Kbirth_year];
    [aCoder encodeObject:self.city forKey:Kcity];
    [aCoder encodeObject:self.sex forKey:Ksex];
    [aCoder encodeObject:self.name forKey:Kname];
    [aCoder encodeObject:self.passworld forKey:KPassWord];
    
}

+ (NSString *)getFilePath{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    return [[array objectAtIndex:0] stringByAppendingString:KfileName];
}

- (void)saveToDisk{
    [NSKeyedArchiver archiveRootObject:self toFile:User.getFilePath];
}
- (void)cleareUser{
    self.email_address = nil;
    self.phone_number = nil;
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.userImageData = nil;
    self.user_name = @"";
    self.token = @"";
    self.userID = nil;
    [self saveToDisk];
    
}

- (BOOL)islogin{
//    if ([self.user_name isEqualToString:@"未登录"]) {
//        return NO;
//    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    return (token.length > 0);
}

@end
