//
//  HomeCollectionViewLayout.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/7/31.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "HomeCollectionViewLayout.h"

#define ITEM_WIDTH kScreen_Width/3
#define ITEM_HEIGHT 50
#define ACTIVE_DISTANCE 1
#define ZOOM_FACTOR 0.4
@implementation HomeCollectionViewLayout

- (instancetype)init{
    if (self = [super init]) {
//        self.itemSize = CGSizeMake(ITEM_WIDTH-50, 109);
        self.itemSize = CGSizeMake(ITEM_WIDTH, 109);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
//        self.sectionInset = UIEdgeInsetsMake(5 , 5, 5, 5);
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        
    }
    return self;
}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
//    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
//    //从第二个循环到最后一个
//    for(int i = 1; i < [attributes count]; ++i) {
//        //当前attributes
//        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
//        //上一个attributes
//        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
//        //我们想设置的最大间距，可根据需要改
//        NSInteger maximumSpacing = 0;
//        //前一个cell的最右边
//        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
//        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
//        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
//        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width > self.collectionViewContentSize.width) {
//            CGRect frame = currentLayoutAttributes.frame;
//            frame.origin.x = origin + maximumSpacing;
//            currentLayoutAttributes.frame = frame;
//        }
//    }
//    return attributes;
//}

@end
