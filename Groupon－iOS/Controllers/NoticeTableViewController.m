//
//  NoticeTableViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/14.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "NoticeTableViewController.h"
#import "NoticeTableViewCell.h"
#import "LoginViewController.h"

#import "DoctorInfoTableViewController.h"
#import "NoticeModel.h"
#import "NoticeDetailTableViewController.h"
@interface NoticeTableViewController ()<UIAlertViewDelegate>
@property(nonatomic, strong)NSMutableArray *array;
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation NoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *itemM = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = itemM;
    
    self.tableView.rowHeight = 85;
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"作者介绍" style:UIBarButtonItemStylePlain target:self action:@selector(gotoinfo)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self loadData];
    
}
- (void)getCategories{
//    self.array = @[@"所有", @"主题1", @"主题2", @"主题3", @"主题4", @"主题5", @"主题6", @"主题7"];
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width, 40)];
    
    CGFloat width = (self.array.count * 80 > ([UIScreen mainScreen].bounds.size.width)) ? self.array.count * 80 : [UIScreen mainScreen].bounds.size.width;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [scroller addSubview:lineView];
    scroller.showsHorizontalScrollIndicator = NO;
    scroller.contentSize = CGSizeMake([self.array count] * 80, 30);
    for (int i = 0; i < self.array.count; i++) {
        UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(10+i*(30+50), 0, 50, 30)];
        label.titleLabel.textAlignment = NSTextAlignmentLeft;
        label.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [label setTitle:self.array[i][@"name"] forState:UIControlStateNormal];
        [label setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        if (i == 0) {
            [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        label.tag = 9000+i;
        [label addTarget:self action:@selector(labelClick:) forControlEvents:UIControlEventTouchUpInside];
        [scroller addSubview:label];
    }
    self.tableView.tableHeaderView = scroller;
}
- (void)labelClick:(UIButton *)sender{
    
    for (int i = 9000; i < 9000+self.array.count; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (sender.tag == 9000) {
        [self loadData];
        return;
    }
    
//    NSString *path = [NSString stringWithFormat:@"%@?category=%@", @"/api/v1/articles", self.array[sender.tag -9000]];
    NSDictionary *dic = @{@"category":self.array[sender.tag-9000][@"name"]};
    [self clickToLoadDataWith:dic];
    
}
- (void)loadData{
    
    [[GoldenLeafNetworkAPIManager shareManager] request_categoriesWithParams:nil andBlock:^(id data, NSError *error) {
        if (!error) {
//            DebugLog(@"%@", data);
            self.array = [[NSMutableArray alloc] initWithArray:data[@"data"]];
            [self.array insertObject:@{@"name":@"所有"} atIndex:0];
            [self getCategories];
        }
    }];
    
    self.dataArray = [[NSMutableArray alloc] init];
    [[GoldenLeafNetworkAPIManager shareManager] request_getArticleListWithPath:nil andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        NSArray *array = data[@"data"];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            //            NoticeModel *model =
            [self.dataArray addObject:dic];
        }
        [self.tableView reloadData];
    }];
//    [[GoldenLeafNetworkAPIManager shareManager] request_getArticleListWithPath:@"/api/v1/articles" andBlock:^(id data, NSError *error) {
//        
//    }];
    
}

- (void)clickToLoadDataWith:(NSDictionary *)dic{
    [[GoldenLeafNetworkAPIManager shareManager] request_getArticleListWithPath:dic andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        NSArray *array = data[@"data"];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            //            NoticeModel *model =
            [self.dataArray addObject:dic];
        }
        [self.tableView reloadData];
    }];
}
- (void)gotoinfo{
    DoctorInfoTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorInfoTableViewController"];
    [self.navigationController pushViewController:control animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

//@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *IntroductionLabel;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell" forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,dict[@"picture"]]]];
    
    cell.hospitalNameLabel.text = [NSString filterNULLStr:dict[@"title"]];
    cell.cityNameLabel.text = [NSString filterNULLStr:dict[@"author"][@"user_name"]];
    cell.IntroductionLabel.text = [NSString filterNULLStr:dict[@"body"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    User *user = [User shareUser];
    
    if (user.islogin) {
        user.healthTitle = @"";
        [user saveToDisk];
    }else{
        if (user.healthTitle.length > 0 && ![user.healthTitle isEqualToString:dict[@"title"]]) {
//            DebugLog(@"不能看");
            NSString *message = [NSString stringWithFormat:@"当前您只能查看标题为<%@>的须知", user.healthTitle];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您尚未登录,登录之后更精彩" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
            alert.delegate = self;
            [alert show];
            return;
        }else{
            user.healthTitle = dict[@"title"];
            [user saveToDisk];
        }
    }

    
    NSString *path = [NSString stringWithFormat:@"%@%@", @"/api/v1/articles/",dict[@"id"]];
    NoticeDetailTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NoticeDetailTableViewController"];
    control.path = path;
    [self.navigationController pushViewController:control animated:YES];
}

- (void)returnBack{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.isRoot) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        LoginViewController *control = [[UIStoryboard storyboardWithName:@"Login" bundle: nil] instantiateInitialViewController];
        //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
        [self presentViewController:control animated:YES completion:nil];
    }
}

@end
