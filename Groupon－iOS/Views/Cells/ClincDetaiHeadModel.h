//
//  ClincDetaiHeadModel.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/10/11.
//  Copyright © 2015年 lixiaohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClincDetaiHeadModel : NSObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *contentStr;
@property(nonatomic, strong) NSString *headImageUrlStr;

@property(nonatomic, strong) NSMutableArray *addressArray;
@property(nonatomic, strong) NSString *postal_code;
@property(nonatomic, strong) NSString *website;
@property(nonatomic, strong) NSMutableArray *transportationArray;
@property(nonatomic, strong) NSMutableArray *telArray;

@property(nonatomic, strong) NSMutableArray *doctorsArray;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
