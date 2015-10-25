//
//  NSObject+UTC.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/15.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "NSString+UTC.h"

@implementation NSString (UTC)
//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //输入格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
//    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
//    [dateFormatter setTimeZone:localTimeZone];
//    
//    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
//    //输出格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
//
//    return dateString;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *locationTimeString=[dateFormatter stringFromDate:dateFormatted];
    return locationTimeString;
}

+ (NSString *)filterNULLStr:(NSString *)str{
    if (![str isKindOfClass:[NSString class]] || (str == nil)) {
        str = @"";
    }
    return str;
}
+ (BOOL)hasData:(NSString *)str{
    if ([str isKindOfClass:[NSNull class]] || (str == nil)) {
        return NO;
    }
    return YES;
}
- (BOOL)iSOverDueDownTime:(NSDateComponents *)components{
    
    if (components.hour < 0) {
        return YES;
    }
    if (components.minute < 0) {
        return YES;
    }
    return NO;
}

- (BOOL)hadSetted{
    if ([self isEqualToString:@"请选择用药时间"]) {
        return NO;
    }else{
        return YES;
    }

}
- (NSString *)countDownStrWithTimeStr{
    if ([self isEqualToString:@"请选择用药时间"]) {
        return @"未设置";
    }
    NSDate *date = [NSDate date];
//    NSDate *select  = [date date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"HH:mm"];
//    NSString *dateAndTime = [dateFormatter stringFromDate:select];
//    [array addObject:dateAndTime];
//    NSLog(@"%@",dateAndTime);
    NSArray *timesArray = [self componentsSeparatedByString:@","];
    
    
//    NSString  *timeStr = [NSString stringWithFormat:@"%@:00", str];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSCalendar *cal=[NSCalendar currentCalendar];
    
    unsigned int unitFlags=NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    
    NSString *currentDate = [dateFormatter stringFromDate:date];
    
    for (NSString *str in timesArray) {
        NSString  *timeStr = [NSString stringWithFormat:@"%@:00", str];
        
        NSDateComponents *d = [cal components:unitFlags fromDate:[dateFormatter dateFromString:currentDate] toDate:[dateFormatter dateFromString:timeStr] options:0];
        if ([self iSOverDueDownTime:d]) {
            continue;
        }
        
        
        NSLog(@"%ld天%ld小时%ld分钟%ld秒",(long)[d day],(long)[d hour],(long)[d minute],(long)[d second]);
        
        if (d.hour > 0) {
            return [NSString stringWithFormat:@"%ld小时%ld分钟",(long)[d hour],(long)[d minute]];
        }
        if (d.hour == 0 && d.minute >0) {
            return [NSString stringWithFormat:@"%ld分钟",(long)[d minute]];
        }
        if (d.hour == 0 && d.minute == 0 && d.second > 0) {
            return [NSString stringWithFormat:@"%ld秒",(long)[d second]];
        }
    }
    
//    NSString  *timeStr = [NSString stringWithFormat:@"%@:00",timesArray[0]];
    NSArray *currentTimeArray = [currentDate componentsSeparatedByString:@":"];
    NSArray *array = [timesArray[0] componentsSeparatedByString:@":"];
    CGFloat hour = [array[0] floatValue]  + 23 - [currentTimeArray[0] floatValue];
    CGFloat munute = [array[1] floatValue]  + 59 - [currentTimeArray[1] floatValue];
    if (munute > 60) {
        munute -= 60;
        hour +=1;
    }
//    hour = hour ? hour : hour + 23;
//    munute = munute ? munute : munute + 59;
    
    return [NSString stringWithFormat:@"%ld小时%ld分钟",(long)hour, (long)munute];
//    for (int i = 0 ; i < 1; i++) {
//    
//    }
//    
//    return [NSString stringWithFormat:@"%ld小时%ld分钟%ld秒",(long)[d hour],(long)[d minute],(long)[d second]];
//    

//    if ([d day] == 0 && [d hour] == 0 && [d minute] == 0) {
//        return @"0秒";
//    }
//    if ([d day] == 0 && [d hour] != 0) {
//        return [NSString stringWithFormat:@"%ld分钟%ld秒",(long)[d minute],(long)[d second]];
//    }
//    if ([d day] == 0 && [d hour] == 0 && [d minute] != 0) {
//        return [NSString stringWithFormat:@"%ld秒",(long)[d second]];
//    }
    
//    return [NSString stringWithFormat:@"%ld小时%ld分钟%ld秒",(long)[d hour],(long)[d minute],(long)[d second]];
}
- (NSString *)getAfterDateWithNumDateBefore:(CGFloat)dates{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    [adcomps setDay:dates];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    NSString *afterDateStr = [dateFormat stringFromDate:newdate];
    DebugLog(@"%@", afterDateStr);
    return afterDateStr;
    
}

- (NSString *)countDays{
    if ([self isEqualToString:@"请选择"]) {
        return @"未设置";
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    
    NSDate *date = [dateFormat dateFromString:self];
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:1];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    
    NSString *afterDateStr = [dateFormat stringFromDate:newdate];
    DebugLog(@"%@", afterDateStr);
    NSCalendar *cal=[NSCalendar currentCalendar];
    unsigned int unitFlags=NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:[NSDate date] toDate:newdate options:0];
    NSString *daysStr;
    if (d.day > 0) {
        return [NSString stringWithFormat:@"%ld天", (long)d.day];
    }else{
        [adcomps setMonth:3+1];
        [adcomps setDay:0];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
        
        d = [cal components:unitFlags fromDate:[NSDate date] toDate:newdate options:0];
//        return [NSString stringWithFormat:@"%ld天", (long)d.day];
        if (d.day > 0) {
            NSInteger days = 0;
            for (NSInteger i = 1; i <= d.month; i++) {
                days = i * 30;
            }
            return [NSString stringWithFormat:@"%ld天", (long)d.day + days];
        }else{
            [adcomps setMonth:6+1+3];
            [adcomps setDay:0];
            NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
            
            d = [cal components:unitFlags fromDate:[NSDate date] toDate:newdate options:0];
            NSInteger days = 0;
            for (NSInteger i = 1; i <= d.month; i++) {
                days = i * 30;
            }
            return [NSString stringWithFormat:@"%ld天", (long)d.day + days];
        }
    }
    
}

+ (NSString *)convertString:(NSString *)str{
    if ([str isKindOfClass:[NSString class]]) {
        return str;
    }else{
        return @"";
    }
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    
    return date;
}
+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSString *str = [formatter stringFromDate:date];
    return str;
}
+ (NSString *)converToTopicStr:(NSString *)timeStr{
    if (timeStr != nil) {
        
        NSDate *createData = [NSString dateFromFomate:timeStr formate:@"yyyy-MM-dd HH:mm"];
        CGFloat scronds = fabsf([createData timeIntervalSinceNow]);
        NSString *createString = nil;
        if (scronds<120) {
            createString = @"刚刚";
            
        }
        else if(scronds < 3600)
        {
            createString = [NSString stringWithFormat:@"%d分钟前",(NSInteger)(scronds/60)];
        
        }else if (scronds < 24 * 3600){
            createString = [NSString stringWithFormat:@"%d小时前",(NSInteger)(scronds/3600)];
        }
        else
        {
            createString = [NSString stringFromFomate:createData formate:@"MM-dd HH:mm"];
        }
        return createString;
        
    }
    else
    {
        return @"";
    }
    

}


+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
@end
