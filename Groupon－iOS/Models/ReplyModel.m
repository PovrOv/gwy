//
//  ReplyModel.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/29.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "ReplyModel.h"

@implementation ReplyModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _contentStr = [NSString stringWithFormat:@"%@", dict[@"body"]];
        if ([dict[@"user"][@"name"] isKindOfClass:[NSString class]]) {
            _userNameStr = [NSString stringWithFormat:@"%@", dict[@"user"][@"name"]];
        }else{
            _userNameStr = [NSString stringWithFormat:@"%@", dict[@"user"][@"user_name"]];
        }
        
        
        NSString *time = [NSString getLocalDateFormateUTCDate:dict[@"created_at"]];
        _timeStr = [NSString converToTopicStr:time];
        
//        _timeStr = [NSString getLocalDateFormateUTCDate:dict[@"created_at"]];
        _cityStr = [NSString stringWithFormat:@"%@", dict[@"user"][@"city"]];
        
        if ([dict[@"user"][@"picture"] isKindOfClass:[NSString class]]) {
            _iconImageURLStr =[NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,dict[@"user"][@"picture"]];
        }else{
            _iconImageURLStr = @"";
        }
        
        if ([dict[@"user"][@"type"] isKindOfClass:[NSString class]]) {
            _doctor = [dict[@"user"][@"type"] isEqualToString:@"doctor"] ? YES : NO;
            
        }else{
            _doctor = NO;
        }
        
        if ([dict[@"user"][@"sex"] isKindOfClass:[NSString class]]) {
            _sex = dict[@"user"][@"sex"];
            
        }else{
            _sex = @"男";
        }
    }
    return self;
}
@end
