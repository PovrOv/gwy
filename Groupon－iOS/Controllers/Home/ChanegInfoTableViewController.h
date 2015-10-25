//
//  ChanegInfoTableViewController.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/26.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanegInfoTableViewController : UITableViewController<ChangeTextInfoProtocol>
@property(nonatomic, weak) id<ChangeTextInfoProtocol> delegate;
@property(nonatomic, assign) ChangeType type;
@property(nonatomic, strong) NSMutableDictionary *userInfoDict;
@end
