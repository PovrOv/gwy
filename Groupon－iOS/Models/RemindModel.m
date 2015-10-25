//
//  RemindModel.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/19.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "RemindModel.h"

@implementation RemindModel
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        _day = [NSString setupCastToString:dic[@"day"]];
        _medicine = [NSString setupCastToString:dic[@"medicine"]];
        _medicine_name = [NSString setupCastToString:dic[@"medicine_name"]];
        _pad = [NSString setupCastToString:dic[@"pad"]];
        _time = [NSString setupCastToString:dic[@"time"]];
        _user_id = [NSString setupCastToString:dic[@"user_id"]];
        
        _iSPad = ([_pad isEqualToString:@"y"] && [_medicine isEqualToString:@"n"]);
        _iSMedicine =  ([_medicine isEqualToString:@"y"] && [_pad isEqualToString:@"n"]);
        _iSDaily = ([_medicine isEqualToString:@"n"] && [_pad isEqualToString:@"n"]);
        
        NSArray *countArray = [_time componentsSeparatedByString:@","];
        _times =  [NSString stringWithFormat:@"%ld", countArray.count];
        _rID = [dic[@"id"] integerValue];
    
        

    }
    return self;
}

//- (BOOL)isISPad{
//    return ([_pad isEqualToString:@"y"] && [_medicine isEqualToString:@"n"]);
//}
//
//- (BOOL)iSMedicine{
//    return ([_medicine isEqualToString:@"y"] && [_pad isEqualToString:@"n"]);
//}
//
//- (BOOL)iSDaily{
//    return ([_medicine isEqualToString:@"n"] && [_pad isEqualToString:@"n"]);
//}

- (NSString *)times{
    NSArray *countArray = [_time componentsSeparatedByString:@","];
    return [NSString stringWithFormat:@"%ld", countArray.count];
}
@end
