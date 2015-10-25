//
//  ReplyTableViewCell.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/29.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "BaseTableViewCell.h"
@class ReplyModel;
typedef void (^buttonClickedButton)(ReplyModel* model);

@interface ReplyTableViewCell : BaseTableViewCell
@property(nonatomic, strong) UILabel *floorLabel;
@property(nonatomic, strong) ReplyModel *model;
@property(nonatomic, strong) buttonClickedButton block;


- (CGFloat)cellHeightWithMode:(ReplyModel *)model;

@end
