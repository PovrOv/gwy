//
//  RemindModel.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/19.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindModel : NSObject
@property(nonatomic, strong) NSString *day;
@property(nonatomic, strong) NSString *medicine;
@property(nonatomic, strong) NSString *medicine_name;
@property(nonatomic, strong) NSString *pad;
@property(nonatomic, strong) NSString *time;
@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, assign) long rID;

@property(nonatomic, assign) BOOL iSMedicine;
@property(nonatomic, assign) BOOL iSPad;
@property(nonatomic, assign) BOOL iSDaily;
@property(nonatomic, strong) NSString *times;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
