//
//  RemindViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/16.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "RemindViewController.h"
#import "RemindCell.h"
@interface RemindViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *array;
@end
@implementation RemindViewController

- (void)viewDidLoad{
    [super viewDidLoad];
//    [self.tableView registerClass:[RemindCell class] forCellReuseIdentifier:@"RemindCell"];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"remind.plist"];
    NSArray *arrayM = [[NSMutableArray alloc] initWithContentsOfFile:path];
    if (arrayM == nil) {
        self.array = [[NSMutableArray alloc] init];
    }else{
        self.array = [[NSMutableArray alloc] init];
        if (![arrayM[0][@"time"] isEqualToString:@"请选择用药时间"]) {
            [self.array addObject:arrayM[0]];
        }
        if (![arrayM[1][@"time"] isEqualToString:@"请选择用药时间"]) {
            [self.array addObject:arrayM[1]];
        }
        if (![arrayM[2][@"date"] isEqualToString:@"请选择"]) {
            [self.array addObject:arrayM[2]];
        }
        
    }

    self.tableView.rowHeight = 60;
    
    UIButton *refleshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [refleshButton addTarget:self action:@selector(reflesh) forControlEvents:UIControlEventTouchUpInside];
    [refleshButton setTitle:@"刷新" forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:refleshButton];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)reflesh{
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.array[indexPath.row];
    NSArray *allKeys = [dict allKeys];
//    medicine  pad  date
    if ([allKeys containsObject:@"medicine"]) {
        NSString *time = [dict[@"time"] countDownStrWithTimeStr];
        cell.remindLabel.text = [NSString stringWithFormat:@"%d. 别忘了%@后服用%@药品", indexPath.row+1,time,dict[@"medicine"]];
    }else if ([allKeys containsObject:@"pad"]){
        NSString *time = [dict[@"time"] countDownStrWithTimeStr];
        cell.remindLabel.text = [NSString stringWithFormat:@"%d. 别忘了%@后服用%@添剂",indexPath.row+1, time,dict[@"pad"]];
    }else if([allKeys containsObject:@"date"]){
        NSString *countDownDate = [dict[@"date"] countDays];
        cell.remindLabel.text = [NSString stringWithFormat:@"%d. 别忘了%@后随诊", indexPath.row+1,countDownDate];
    }
    
//    cell.remindLabel.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row+1, dict[@"tip"]];
    return cell;
}
@end
