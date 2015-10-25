//
//  DoctorViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/14.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "DoctorViewController.h"

@interface DoctorViewController ()

@end

@implementation DoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = item;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)returnBack{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}
@end
