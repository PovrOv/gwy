//
//  ChanegInfoTableViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/26.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "ChanegInfoTableViewController.h"

@interface ChanegInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *infotext;

@end

@implementation ChanegInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
     self.navigationItem.rightBarButtonItem = item;
    
    if (self.type == KMobillePhoneType) {
        self.infotext.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

//user_name (optional)
//email_address (optional)
//password (optional)
//type ('user' or 'doctor') (optional)
//sex (optional)
//birth_day (optional)
//birth_month (optional)
//birth_year (optional)
//phone_number (optional)
//picture (optional)
//occupation (optional)
//hospital (optional)
//department (optional)
//city (optional)

- (void)save{
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    switch (self.type) {
        case KUserNameType:
            [self.userInfoDict setObject:self.infotext.text forKey:@"user_name"];
            break;
        case KEmailType:
            [self.userInfoDict setObject:self.infotext.text forKey:@"email_address"];
            break;
        case KMobillePhoneType:
            [self.userInfoDict setObject:self.infotext.text forKey:@"phone_number"];
            break;
        case KNameType:
            [self.userInfoDict setObject:self.infotext.text forKey:@"name"];
            break;
        case KPassWorld:
            [self.userInfoDict setObject:self.infotext.text forKey:@"password"];
            break;
        default:
            break;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.userInfoDict];
    [[GoldenLeafNetworkAPIManager shareManager] request_updateUserInfoWithParams:dict andBlock:^(id data, NSError *error) {
        if (data) {
//            DebugLog(@"%@", data);
        }
    }];
    if ([self.delegate respondsToSelector:@selector(ChangeTextInfo:str:)]) {
        [self.delegate ChangeTextInfo:self.type str:self.infotext.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
