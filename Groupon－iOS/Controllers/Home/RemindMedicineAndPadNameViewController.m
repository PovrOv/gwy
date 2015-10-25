//
//  RemindMedicineAndPadNameViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "RemindMedicineAndPadNameViewController.h"

@interface RemindMedicineAndPadNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *contentTextfield;

@end
@implementation RemindMedicineAndPadNameViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)save{
    if ([self.delegate respondsToSelector:@selector(ChangeTextInfo:str:)]) {
        [self.delegate ChangeTextInfo:self.type str:self.contentTextfield.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
