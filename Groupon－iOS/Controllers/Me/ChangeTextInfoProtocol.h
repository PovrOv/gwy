//
//  ChangeTextInfoProtocol.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/17.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    KUserNameType,
    KMobillePhoneType,
    KEmailType,
    KNameType,
    KPassWorld
} ChangeType;

#import <UIKit/UIKit.h>
@protocol ChangeTextInfoProtocol <NSObject>

- (void)ChangeTextInfo:(ChangeType)type str:(NSString *)str;
@end
