//
//  MeRootViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/7/29.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "MeRootViewController.h"
#import "MoreTableViewController.h"
@interface MeRootViewController ()

@end

@implementation MeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.tableView.backgroundColor = rgb(235, 235, 241);
    
//    UIImage *image = [UIImage imageNamed:@"更多"];
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
    self.navigationItem.rightBarButtonItem = item;
    
//    self.navigation
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moreAction:(UIButton *)sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    MoreTableViewController *control = [sb instantiateViewControllerWithIdentifier:@"MoreTableViewController"];
    
    [self.navigationController pushViewController:control animated:YES];
}
@end
