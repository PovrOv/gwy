//
//  TopicsTableViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/28.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "TopicsTableViewController.h"
#import "TopicTableViewCell.h"
#import "TopicModel.h"
#import "TopicDetailViewController.h"
#import "CreatTopicTableViewController.h"
#import "LoginViewController.h"
@interface TopicsTableViewController ()<UIAlertViewDelegate>
@property(nonatomic, strong) TopicModel *model;
@property(nonatomic, strong) NSMutableArray *dataArray;
@end
@implementation TopicsTableViewController


- (void)loadView{
    [super loadView];
    [self loadData];
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    UIButton *returnBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [returnBackButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [returnBackButton setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:returnBackButton];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"common_titleicon_add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
//    [returnBackButton setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *itemM = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = itemM;
    
    self.title = @"抱团取暖";
    _dataArray = [[NSMutableArray alloc] init];
    [self.tableView registerClass:[TopicTableViewCell class] forCellReuseIdentifier:@"TopicTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = rgb(235, 235, 235);
//    [self loadData];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self loadData];
}
- (void)returnBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)add:(UIButton *)sender{
    if (![User shareUser].islogin) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此操作需要先登入，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往登入", nil];
        [alert show];
        return;

    }
    CreatTopicTableViewController *control = [[UIStoryboard storyboardWithName:@"Group" bundle:nil] instantiateInitialViewController];
    [self.navigationController pushViewController:control animated:YES];
}

- (void)loadData{
    
    [[GoldenLeafNetworkAPIManager shareManager] request_getGroupTopicsListWithParams:nil andBlock:^(id data, NSError *error) {
        DebugLog(@"%@", data);
        NSArray *array = data[@"data"];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in array) {
            TopicModel *model = [[TopicModel alloc] initWithDict:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicModel *model = self.dataArray[indexPath.row];
    TopicTableViewCell *cell = [[TopicTableViewCell alloc] init];
    CGFloat height = [cell cellHeightWithMode:model];
    return height;
//    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicDetailViewController *control = [[TopicDetailViewController alloc] initWithTopicModel:self.dataArray[indexPath.row]];
//    control.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:control animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        LoginViewController *control = [[UIStoryboard storyboardWithName:@"Login" bundle: nil] instantiateInitialViewController];
        //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
        [self presentViewController:control animated:YES completion:nil];
    }
}
@end
