//
//  MeUserCenter.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/15.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "MeUserCenter.h"

@interface MeUserCenter ()


@end
@implementation MeUserCenter

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)returnBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
