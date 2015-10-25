//
//  TopicTableViewCell.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/28.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "BaseTableViewCell.h"
@class TopicModel;
@interface TopicTableViewCell : BaseTableViewCell
@property(nonatomic, strong)TopicModel *model;

- (CGFloat)cellHeightWithMode:(TopicModel *)model;
@end
