//
//  TopicModel.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/28.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _contentStr = [NSString stringWithFormat:@"%@", dict[@"title"]];
        _detail = [NSString stringWithFormat:@"%@", dict[@"body"]];
        if ([dict[@"user"] isKindOfClass:[NSDictionary class]]) {
            if ([dict[@"user"][@"name"] isKindOfClass:[NSString class]]) {
                _userNameStr = dict[@"user"][@"name"];
                
            }else{
                _userNameStr = dict[@"user"][@"user_name"];
            }
            
            if ([dict[@"user"][@"city"] isKindOfClass:[NSString class]]) {
                _city = dict[@"user"][@"city"];
                
            }else{
                _city = @"";
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

            
            if ([dict[@"user"][@"picture"] isKindOfClass:[NSString class]]) {
                _iconImageStr = [NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,dict[@"user"][@"picture"]];
            }else{
                _iconImageStr = @"";
            }
        }else{
            _userNameStr = @"没有名字";
        }
        if ([dict[@"picture"] isKindOfClass:[NSString class]]) {
            _imagePicStr =[NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,dict[@"picture"]];
        }else{
            _imagePicStr = @"";
        }
        NSString *time = [NSString getLocalDateFormateUTCDate:dict[@"created_at"]];
        _timeStr = [NSString converToTopicStr:time];
        _replyCountStr = [NSString stringWithFormat:@"%@回复",dict[@"replyCount"]];
        _topicID = dict[@"id"];
    }
    return self;
}
@end
