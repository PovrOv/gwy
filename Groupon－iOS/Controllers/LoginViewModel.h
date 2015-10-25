//
//  LoginViewModel.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject
@property(nonatomic, strong)NSString *nameStr;
@property(nonatomic, strong)NSString *passworldStr;

- (RACSignal *)loginButtonIsVisible;

+ (void)loginRequest_Params:(NSMutableDictionary *)dict andBlock:(void(^)(BOOL success))block;
@end
