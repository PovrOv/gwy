//
//  ChangeNickTableViewController.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/2.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeNickTableViewController : UITableViewController<ChangeTextInfoProtocol>
@property(nonatomic, weak) id<ChangeTextInfoProtocol>delegate;
@end
