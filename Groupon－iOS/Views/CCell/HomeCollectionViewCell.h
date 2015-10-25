//
//  HomeCollectionViewCell.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/7/31.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HomeCCellIdentify @"HomeCCell"
@interface HomeCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)UILabel *classfiTitleLabel;
@property(nonatomic, strong)UIImageView *imageView;

+ (instancetype)ccellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@end
