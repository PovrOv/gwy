//
//  ChangePasswordTableViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/2.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "ChangePasswordTableViewController.h"

@interface ChangePasswordTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPassworld;
@property (weak, nonatomic) IBOutlet UITextField *Password1;
@property (weak, nonatomic) IBOutlet UITextField *passwold2;

@end

@implementation ChangePasswordTableViewController
- (IBAction)save:(id)sender {
    if ([self.delegate respondsToSelector:@selector(ChangeTextInfo:str:)]) {
        [self.delegate ChangeTextInfo:KPassWorld str:self.Password1.text];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
