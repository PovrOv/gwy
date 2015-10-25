//
//  AnnounceDetailTableViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/20.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "AnnounceDetailTableViewController.h"

@interface AnnounceDetailTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableVIew;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *articleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation AnnounceDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    
    [self loadData];
}
//
//@property (strong, nonatomic) IBOutlet UITableView *tableVIew;
//@property (weak, nonatomic) IBOutlet UIImageView *imageV;
//@property (weak, nonatomic) IBOutlet UILabel *articleNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)loadData{
    [[GoldenLeafNetworkAPIManager shareManager] request_getTopicsDetailWithPath:self.path andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        
        NSString *imageStr = [NSString stringWithFormat:@"%@",data[@"data"][@"author"][@"picture"]];
        if (![imageStr isEqualToString:@"<null>"]) {
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,data[@"data"][@"author"][@"picture"]]]];
        }
        
        self.articleNameLabel.text = data[@"data"][@"author"][@"user_name"];
        self.introductionLabel.text = data[@"data"][@"title"];
        self.contentTextView.text = data[@"data"][@"body"];
        
        [self.tableView reloadData];
        
    }];
}
- (void)returnBack{
    
    if (self.isRoot) {
         [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
//    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else{
//         [self.navigationController popViewControllerAnimated:YES];
//    }
//   

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
@end
