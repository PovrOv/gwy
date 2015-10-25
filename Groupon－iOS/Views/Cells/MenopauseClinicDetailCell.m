//
//  MenopauseClinicDetailCell.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "MenopauseClinicDetailCell.h"

@implementation MenopauseClinicDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ClincDoctorCell" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}
@end
