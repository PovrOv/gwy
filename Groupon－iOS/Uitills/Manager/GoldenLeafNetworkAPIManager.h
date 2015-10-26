//
//  GrouponNetworkAPIManager.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/7/30.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoldenLeafNetworkAPIManager : NSObject<NSURLConnectionDataDelegate>
+(instancetype)shareManager;

#pragma mark -  about login
- (void)request_getMobilePhoneCodeWithParams:(id)params
                                    andBlock:(void(^)(id data, NSError *error))block;

- (void)request_registerWithParams:(id)params
                          andBlock:(void(^)(id data, NSError *error))block;

- (void)request_thirdRegisterWithParams:(id)params
                               andBlock:(void(^)(id data, NSError *error))block;

- (void)request_loginWithParams:(id)params
                       andBlock:(void(^)(id data, NSError *error))block;

- (void)request_logoutWithParams:(id)params
                        andBlock:(void(^)(id data, NSError *error))block;

#pragma mark - about user infomation
- (void)request_changePasswordWithParams:(id)params
                                andBlock:(void(^)(id data, NSError *error))block;

- (void)request_changeUserInfomationWithParams:(id)params
                                      andBlock:(void(^)(id data, NSError *error))block;

- (void)request_getUserInfomationWithParams:(id)params
                                   andBlock:(void(^)(id data, NSError *error))block;


#pragma mark - weather

- (void)request_getWeatherWithCityName:(NSString *)city andBlock:(void(^)(id data, NSError *error))block;


- (void)request_getArticleListWithPath:(NSDictionary *)dic andBlock:(void(^)(id data, NSError *error))block;

- (void)request_getClinicsListWithParams:(NSDictionary *)dic andBlock:(void(^)(id data, NSError *error))block;

- (void)request_getClinicsDetailWithPath:(NSString *)path andBlock:(void(^)(id data, NSError *error))block;

- (void)request_getTopicsListWithParams:(NSMutableDictionary *)dic andBlock:(void(^)(id data, NSError *error))block;
- (void)request_getTopicsDetailWithPath:(NSString *)path andBlock:(void(^)(id data, NSError *error))block;

- (void)request_getUserInfoWithPath:(NSString *)path andBlock:(void(^)(id data, NSError *error))block;

- (void)request_createTopicsWithParams:(NSMutableDictionary *)dict andBlock:(void(^)(id data, NSError *error))block;

- (void)request_updateUserInfoWithParams:(NSMutableDictionary *)dict andBlock:(void(^)(id data, NSError *error))block;

- (void)request_updateUserImage:(NSMutableDictionary *)dict andBlock:(void(^)(id data, NSError *error))block;

-(void)request_categoriesWithParams:(NSMutableDictionary *)dict andBlock:(void(^)(id data, NSError *error))block;

- (void)request_getUserListWithPath:(NSString *)path andBlock:(void(^)(id data, NSError *error))block;

- (void)request_getGroupTopicsListWithParams:(NSMutableDictionary *)dic andBlock:(void(^)(id data, NSError *error))block;

- (void)request_getGroupReplyListWithTopicID:(NSString *)topicID andBlock:(void(^)(id data, NSError *error))block;

-(void)request_createRepltWithParams:(NSMutableDictionary *)dict topicID:(NSString *)topicID andBlock:(void(^)(id data, NSError *error))block;

-(void)request_createTopicWithParams:(NSMutableDictionary *)dict withData:(NSData *)dataM andBlock:(void(^)(id data, NSError *error))block;

-(void)request_updateUserImageWithParams:(NSMutableDictionary *)dict withData:(NSData *)dataM andBlock:(void (^)(id, NSError *))block;

- (void)request_getRemindWithBlock:(void (^)(id, NSError *))block;

- (void)request_createRemindWithParams:(NSMutableDictionary *)params andBlock:(void (^)(id, NSError *))block;

- (void)request_updateRemindWithParams:(NSMutableDictionary *)params withReminder_id:(long)Rid andBlock:(void (^)(id, NSError *))block;

- (void)request_deleteRemindWithReminder_id:(long)Rid andBlock:(void (^)(id, NSError *))block;
@end
