//
//  NSObject+Safe.m
//  KuaiDiYuan_S
//
//  Created by xulingjiao on 15/5/22.
//  Copyright (c) 2015年 KuaidiHelp. All rights reserved.
//

#import "NSObject+Safe.h"

@implementation NSObject(Safe)

-(id)safeCastForClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    return nil;
}

-(id)safeCastToString {
    if ([self isKindOfClass:[NSString class]])
        return self;
    NSString *desc = [self description];
    if ([desc isEqualToString:@"<null>"])
        return nil;
    return desc;
}

+ (id)setupCastToString:(NSString *)str{
    
    if ([str isKindOfClass:[NSString class]]){
        if ([str isEqualToString:@"<null>"]) {
            return @"";
        }
        
        return str;
    }
    if (str ==  nil) {
        return @"";
    }
    NSString *desc = [self description];
    if ([desc isEqualToString:@"<null>"])
        return @"";
    return desc;

}

- (BOOL)hasValue{
    if ([self isKindOfClass:[NSNull class]] || self == nil) {
        return NO;
    }
    return YES;
}
@end
