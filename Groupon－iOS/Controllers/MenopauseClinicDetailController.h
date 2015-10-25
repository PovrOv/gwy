//
//  MenopauseClinicDetailController.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenopauseClinicDetailController : UIViewController
@property (nonatomic, copy) NSString *path;
- (instancetype)initWithPath:(NSString *)path;
@property(nonatomic, assign) BOOL isRoot;
@end
