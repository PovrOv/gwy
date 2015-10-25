//
//  HomeTableViewClineCell.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/23.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface HomeTableViewClineCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *hospitalName;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
