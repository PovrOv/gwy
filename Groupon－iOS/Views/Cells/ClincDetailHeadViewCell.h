//
//  ClincDetailHeadViewCell.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/10/11.
//  Copyright © 2015年 lixiaohu. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ClincDetaiHeadModel.h"
@interface ClincDetailHeadViewCell : BaseTableViewCell
@property(nonatomic, strong) ClincDetaiHeadModel *model;
@property(nonatomic, strong) UIButton *lookMapButton;
+(CGFloat)cellHeightWithModel:(ClincDetaiHeadModel *)model;
@end
