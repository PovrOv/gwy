//
//  NSString+height.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/28.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (height)
+(CGFloat)heightWithFontSize:(CGFloat)fontSize size:(CGSize)size str:(NSString *)str;

+ (CGFloat)widthWithFontSize:(CGFloat)fontSize size:(CGSize)size str:(NSString *)str;
@end
