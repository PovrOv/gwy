//
//  HomeTextAndImageViewTableView2CellTableViewCell.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/25.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "HomeTextAndImageViewTableView2CellTableViewCell.h"

@implementation HomeTextAndImageViewTableView2CellTableViewCell

+ (CGFloat)cellHeight{
    return 55;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clicked:(id)sender {
    if (self.block) {
        self.block();
    }
}


@end
