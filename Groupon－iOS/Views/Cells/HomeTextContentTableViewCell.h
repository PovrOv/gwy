//
//  HomeTextContentTableViewCell.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/13.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cellDidClickedDelegate <NSObject>

- (void)cellDidClicked:(NSDictionary *)dict;

@end
@interface HomeTextContentTableViewCell : BaseTableViewCell
@property (strong, nonatomic) UILabel *contentLabel;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak) id<cellDidClickedDelegate> delegate;
- (void)animation;

- (instancetype)cellWithTableView:(UITableView *)tableView;
@end
