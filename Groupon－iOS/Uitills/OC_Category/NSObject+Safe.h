//
//  NSObject+Safe.h
//  KuaiDiYuan_S
//
//  Created by xulingjiao on 15/5/22.
//  Copyright (c) 2015年 KuaidiHelp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Safe)

//安全类型转换，如果转换成功，返回非nil值，否则返回nil
//解决当返回类型id时,(NSString *)returnValue这样不安全类型转换导致的崩溃问题。
-(id)safeCastForClass:(Class)cls;

-(id)safeCastToString;

+ (id)setupCastToString:(NSString *)str;

- (BOOL)hasValue;
@end
