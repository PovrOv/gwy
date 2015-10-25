//
//  HomeTextAndImageViewTableViewCell.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/13.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTextAndImageViewTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@end
