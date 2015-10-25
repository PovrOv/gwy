//
//  ClincDetaiHeadModel.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/10/11.
//  Copyright © 2015年 lixiaohu. All rights reserved.
//

#import "ClincDetaiHeadModel.h"

@implementation ClincDetaiHeadModel

//@property(nonatomic, strong) NSString *name;
//@property(nonatomic, strong) NSString *contentStr;
//@property(nonatomic, strong) NSString *headImageUrlStr;
//
//@property(nonatomic, strong) NSArray *addressArray;
//@property(nonatomic, strong) NSString *postal_code;
//@property(nonatomic, strong) NSString *website;
//@property(nonatomic, strong) NSArray *transportationArray;
//@property(nonatomic, strong) NSArray *telArray;
//
//@property(nonatomic, strong) NSArray *doctorsArray;
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.headImageUrlStr = [NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,dict[@"picture"]];
        self.contentStr = [NSString filterNULLStr:dict[@"description"]];
        self.name = [NSString filterNULLStr:dict[@"name"]];
        self.website = [NSString filterNULLStr:dict[@"website"]];
        self.postal_code = [NSString filterNULLStr:dict[@"postal_code"]];
        
        self.addressArray = [[NSMutableArray alloc] init];
        self.transportationArray = [[NSMutableArray alloc] init];
        self.telArray = [[NSMutableArray alloc] init];
        self.doctorsArray = [[NSMutableArray alloc] init];
        
        NSString *province,*city,*district;
        
        if ([NSString hasData:dict[@"province"]]) {
            province  = dict[@"province"];
        }else{
            province = @"";
        }
        if ([NSString hasData:dict[@"city"]]) {
            city = dict[@"city"];
        }else{
            city = @"";
        }
        if ([NSString hasData:dict[@"district"]]) {
            district = dict[@"district"];
        }else{
            district = @"";
        }
        
        if ([NSString hasData:dict[@"address_1"]]) {
            NSString *addressM = [NSString stringWithFormat:@"%@%@%@%@", province, city,district,dict[@"address_1"]];
            [self.addressArray addObject:addressM];
        }
        if ([NSString hasData:dict[@"address_2"]]) {
            [self.addressArray addObject:dict[@"address_2"]];
        }
        if ([NSString hasData:dict[@"address_3"]]) {
            [self.addressArray addObject:dict[@"address_3"]];
        }
        
        
        if ([NSString hasData:dict[@"transportation_1"]]) {
            [self.transportationArray addObject:dict[@"transportation_1"]];
        }
        if ([NSString hasData:dict[@"transportation_2"]]) {
            [self.transportationArray addObject:dict[@"transportation_2"]];
        }
        if ([NSString hasData:dict[@"transportation_3"]]) {
            [self.transportationArray addObject:dict[@"transportation_3"]];
        }
        if ([NSString hasData:dict[@"transportation_4"]]) {
            [self.transportationArray addObject:dict[@"transportation_4"]];
        }
        if ([NSString hasData:dict[@"transportation_5"]]) {
            [self.transportationArray addObject:dict[@"transportation_5"]];
        }
        if ([NSString hasData:dict[@"transportation_6"]]) {
            [self.transportationArray addObject:dict[@"transportation_6"]];
        }
        
        NSArray *array = dict[@"doctors"];
        for (NSDictionary *dict in array) {
            [self.doctorsArray addObject:dict];
        }
        
        if ([NSString hasData:dict[@"telephone_name_1"]] && [NSString hasData:dict[@"telephone_1"]]) {
            
            NSString *telStr = [NSString stringWithFormat:@"(%@)%@", dict[@"telephone_name_1"], dict[@"telephone_1"]];
            [self.telArray addObject:telStr];
            
        }
        if ([NSString hasData:dict[@"telephone_name_2"]] && [NSString hasData:dict[@"telephone_2"]]) {
            
            NSString *telStr = [NSString stringWithFormat:@"(%@)%@", dict[@"telephone_name_2"], dict[@"telephone_2"]];
            [self.telArray addObject:telStr];
            
        }

        if ([NSString hasData:dict[@"telephone_name_3"]] && [NSString hasData:dict[@"telephone_3"]]) {
            
            NSString *telStr = [NSString stringWithFormat:@"(%@)%@", dict[@"telephone_name_3"], dict[@"telephone_3"]];
            [self.telArray addObject:telStr];
            
        }

        if ([NSString hasData:dict[@"telephone_name_4"]] && [NSString hasData:dict[@"telephone_4"]]) {
            
            NSString *telStr = [NSString stringWithFormat:@"(%@)%@", dict[@"telephone_name_4"], dict[@"telephone_4"]];
            [self.telArray addObject:telStr];
            
        }

        if ([NSString hasData:dict[@"telephone_name_5"]] && [NSString hasData:dict[@"telephone_5"]]) {
            
            NSString *telStr = [NSString stringWithFormat:@"(%@)%@", dict[@"telephone_name_5"], dict[@"telephone_5"]];
            [self.telArray addObject:telStr];
            
        }

        if ([NSString hasData:dict[@"telephone_name_6"]] && [NSString hasData:dict[@"telephone_6"]]) {
            
            NSString *telStr = [NSString stringWithFormat:@"(%@)%@", dict[@"telephone_name_6"], dict[@"telephone_6"]];
            [self.telArray addObject:telStr];
            
        }

        
    }
    return self;
}
@end
