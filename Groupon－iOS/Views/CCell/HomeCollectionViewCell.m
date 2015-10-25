//
//  HomeCollectionViewCell.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/7/31.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell
+ (instancetype)ccellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCCellIdentify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CCell" owner:self options:nil] objectAtIndex:0];
        
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CCell" owner:self options:nil] objectAtIndex:0];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.3f;
        
    }
    return self;
}
@end
