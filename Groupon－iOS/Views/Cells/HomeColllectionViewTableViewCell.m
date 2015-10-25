//
//  HomeColllectionViewTableViewCell.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/13.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "HomeColllectionViewTableViewCell.h"
#import "HomeCCollectionViewCell.h"
@interface HomeColllectionViewTableViewCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *dataSource;
@end
@implementation HomeColllectionViewTableViewCell

+ (CGFloat)cellHeight{
    return 110;
}
- (void)awakeFromNib {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.frame)/4-15, 109);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:dic[@"icon"]];
    cell.titleLabel.text = dic[@"title"];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ccellDidClickedBlock) {
        self.ccellDidClickedBlock(indexPath.row);
    }

}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@{@"icon":@"firstpage_diagnosisicon_pressed", @"title":@"自我诊断"}, @{@"icon":@"firstpage_docicon", @"title":@"医生告诉您"},
                        @{@"icon":@"firstpage_groupicon",
                          @"title":@"抱团取暖"},@{@"icon":@"firstpage_meicon", @"title":@"个人特区"}];
        
    }
    return _dataSource;
}
@end
