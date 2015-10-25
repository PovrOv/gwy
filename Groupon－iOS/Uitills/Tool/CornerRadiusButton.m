//
//  CornerRadiusButton.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/24.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "CornerRadiusButton.h"

@implementation CornerRadiusButton

- (void)awakeFromNib{
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 3;
}

@end
