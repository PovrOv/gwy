//
//  RadiousImageView.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/24.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "RadiousImageView.h"

@implementation RadiousImageView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = CGRectGetWidth(self.frame)/2;
}

@end
