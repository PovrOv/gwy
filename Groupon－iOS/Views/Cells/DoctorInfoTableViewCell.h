//
//  DoctorInfoTableViewCell.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/20.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *professionalLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLabel;
@end
