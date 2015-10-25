//
//  ReplyModel.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/29.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyModel : NSObject
@property(nonatomic, strong) NSString *iconImageURLStr;
@property(nonatomic, strong) NSString *userNameStr;
@property(nonatomic, strong) NSString *cityStr;
@property(nonatomic, strong) NSString *contentStr;
@property(nonatomic, strong) NSString *timeStr;

@property(nonatomic, assign) BOOL doctor;
@property(nonatomic, copy) NSString *sex;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
