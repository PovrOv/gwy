//
//  TopicModel.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/28.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject
@property(nonatomic, copy) NSString *iconImageStr;
@property(nonatomic, copy) NSString *contentStr;
@property(nonatomic, copy) NSString *imagePicStr;
@property(nonatomic, copy) NSString *userNameStr;
@property(nonatomic, copy) NSString *timeStr;
@property(nonatomic, copy) NSString *replyCountStr;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *detail;
@property(nonatomic, assign) BOOL doctor;
@property(nonatomic, copy) NSString *sex;
@property(nonatomic, copy) NSString *topicID;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
