//
//  HomeTextAndImageViewTableView2CellTableViewCell.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/25.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void (^Cellblock)();
@interface HomeTextAndImageViewTableView2CellTableViewCell : BaseTableViewCell
@property(nonatomic, strong)Cellblock block;
@end
