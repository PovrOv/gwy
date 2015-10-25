//
//  NSObject+UTC.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/15.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UTC)
+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate;

+(NSString *)filterNULLStr:(NSString *)str;
+(BOOL)hasData:(NSString *)str;


-(NSString *)countDownStrWithTimeStr;
- (BOOL)hadSetted;
-(NSString *)countDays;

+ (NSString *)convertString:(NSString *)str;

+ (NSString *)converToTopicStr:(NSString *)timeStr;
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate;
+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate;

+ (BOOL)stringContainsEmoji:(NSString *)string;
@end
