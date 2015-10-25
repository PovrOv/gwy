//
//  HomeColllectionViewTableViewCell.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/13.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^homeCCellBlock)(NSInteger index);
@interface HomeColllectionViewTableViewCell :BaseTableViewCell

@property(nonatomic, strong)homeCCellBlock ccellDidClickedBlock;
@end
