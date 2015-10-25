//
//  MenopauseClinicTableViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/14.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "MenopauseClinicTableViewController.h"
#import "MenopauseClinicTableViewCell.h"
#import "MenopauseClinicDetailController.h"
#import "LoginViewController.h"
@interface MenopauseClinicTableViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MenopauseClinicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = item;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.dataArray = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void)loadData{
    [[GoldenLeafNetworkAPIManager shareManager] request_getClinicsListWithParams:nil andBlock:^(id data, NSError *error) {
        NSArray *array = data[@"data"];
        for (NSDictionary *dict in array) {
            [self.dataArray addObject:dict];
        }
        [self.tableView reloadData];
    }];

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
    MenopauseClinicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenopauseClinicTableViewCell" forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,[NSString convertString:dict[@"picture"]]]]];
    cell.hospitalNameLabel.text = [NSString convertString:dict[@"name"]];
    cell.cityNameLabel.text = [NSString convertString:dict[@"city"]];
    
    cell.IntroductionLabel.text = [NSString convertString:dict[@"description"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    
//    User *user = [User shareUser];
//    
//    if (user.islogin) {
//        user.clinicTitle = @"";
//        [user saveToDisk];
//    }else{
//        if (user.clinicTitle.length > 0 && ![user.clinicTitle isEqualToString:dict[@"name"]]) {
//            DebugLog(@"不能看");
//            NSString *message = [NSString stringWithFormat:@"当前您只能查看标题为<%@>的门诊信息", user.clinicTitle];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您尚未登录,登录之后更精彩" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
//            alert.delegate = self;
//            [alert show];
//            return;
//        }else{
//            user.clinicTitle = dict[@"name"];
//            [user saveToDisk];
//        }
//    }
    
    NSString *path = [NSString stringWithFormat:@"%@%@", @"/api/v1/clinics/",dict[@"id"]];
//    MenopauseClinicDetailController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenopauseClinicDetailController"];
    MenopauseClinicDetailController *control = [[MenopauseClinicDetailController alloc] init];
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
