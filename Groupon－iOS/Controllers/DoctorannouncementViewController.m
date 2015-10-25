//
//  DoctorannouncementViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/14.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "DoctorannouncementViewController.h"
#import "DoctorannouncementTableViewCell.h"
#import "DropDownMenu.h"
#import "NSString+UTC.h"
#import "AnnounceDetailTableViewController.h"
#import "LoginViewController.h"
@interface DoctorannouncementViewController ()<UITableViewDataSource, UITableViewDelegate,DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UIAlertViewDelegate>
{
    NSMutableArray *chooseArray ;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSMutableArray *doctorUser;
@property (nonatomic, weak) DropDownMenu *menu;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation DoctorannouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 75;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = item;

    chooseArray = [NSMutableArray arrayWithArray:@[
                                                   @[@"时间"],
                                                   @[@"城市"],@[@"医生"]
                                                   ]];
    self.dates = @[@"全部时间", @"最新", @"三天内", @"七天内"];
    self.cities = @[@"全部城市", @"北京", @"上海", @"重庆", @"天津", @"济南", @"石家庄", @"长春", @"哈尔滨", @"沈阳",@"呼和浩特", @"乌鲁木齐", @"兰州", @"银川", @"太原", @"西安", @"郑州", @"合肥", @"南京", @"杭州",@"福州", @"广州", @"南昌", @"海口", @"南宁", @"贵阳", @"长沙", @"武汉", @"成都", @"昆明",@"拉萨", @"西宁", @"台北", @"香港", @"澳门"];
    self.doctorUser = [[NSMutableArray alloc] initWithArray:@[@{@"id":@"0", @"user_name":@"全部医生"}]];
    DropDownMenu *dropDown = [[DropDownMenu alloc] initWithOrigin: CGPointMake(0, 0) andHeight:44];
    dropDown.delegate = self;
    dropDown.dataSource = self;
    [self.view addSubview:dropDown];
    
    _menu = dropDown;
    [dropDown selectDefalutIndexPath];
    
//    DropDownMenu * dropDownView = [[DropDownMenu alloc] initWithFrame:CGRectMake(0,0, kScreen_Width, 38) dataSource:self delegate:self];
//    dropDownView.mSuperView = self.topView;
//    [self.topView addSubview:dropDownView];
    
    self.dataArray = [[NSMutableArray alloc] init];

    // Do any additional setup after loading the view.
    [self loadData];
    [self getUserList];
}

- (void)getUserList{
    [[GoldenLeafNetworkAPIManager shareManager] request_getUserListWithPath:@"/api/v1/users-public?type=doctor" andBlock:^(id data, NSError *error) {
        if (error) {
            return ;
        }
        [self.doctorUser removeAllObjects];
        for (NSDictionary *dict in data[@"data"]) {
            if ([dict[@"announcement_author"] isKindOfClass:[NSString class]]) {
                if ([dict[@"announcement_author"] isEqualToString:@"Y"]) {
                    [self.doctorUser addObject:dict];
                }
                
            }
            
        }
        [self.doctorUser insertObject:@{@"user_name":@"全部医生", @"id":@"0"} atIndex:0];
//        DebugLog(@"%@", data);
        [self.menu reloadData];
    }];
}
- (void)loadData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"created_at,desc" forKey:@"sort"];
    
    [[GoldenLeafNetworkAPIManager shareManager] request_getTopicsListWithParams:dict andBlock:^(id data, NSError *error) {
        if (error) {
            return;
        }
        NSArray *array = data[@"data"];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in array) {
//            if([dict[@"author"][@"type"] isEqualToString:@"doctor"]){
            [self.dataArray addObject:dict];
//            }
        }
        [self.tableView reloadData];
    }];

}

- (void)loadDataWithDate:(NSString *)str{
    if ([str isEqualToString:@"全部时间"]) {
        [self loadData];
        return;
    }else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"created_at,desc" forKey:@"sort"];
        CGFloat numsBeforeDates;
        if ([str isEqualToString:@"最新"]) {
            numsBeforeDates = -1;
        }else if ([str isEqualToString:@"三天内"]){
            numsBeforeDates = -3;
        }else if([str isEqualToString:@"七天内"]){
            numsBeforeDates = -7;
        }else{
            [self loadData];
            return;
        }
        NSString *beforeStr = [self getBeforeDate];
        NSString *afterStr = [self getAfterDateWithNumDateBefore:numsBeforeDates];
        [dict setObject:afterStr forKey:@"after"];
        [dict setObject:beforeStr forKey:@"before"];
        [[GoldenLeafNetworkAPIManager shareManager] request_getTopicsListWithParams:dict andBlock:^(id data, NSError *error) {
            NSArray *array = data[@"data"];
            [self.dataArray removeAllObjects];
            for (NSDictionary *dict in array) {
                [self.dataArray addObject:dict];
            }
            [self.tableView reloadData];
        }];

    }

}

- (void)loadDataWithCity:(NSString *)city{
    if ([city isEqualToString:@"全部城市"]) {
        [self loadData];
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"location" forKey:@"sort"];
    [dict setObject:city forKey:@"location"];
    
    [[GoldenLeafNetworkAPIManager shareManager] request_getTopicsListWithParams:dict andBlock:^(id data, NSError *error) {
        NSArray *array = data[@"data"];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in array) {
            [self.dataArray addObject:dict];
        }
        [self.tableView reloadData];
    }];

}

- (void)loadDataWithDoctor:(NSString *)doctorStr{
    if ([doctorStr  isEqualToString:@"0"]) {
        [self loadData];
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"user_id" forKey:@"sort"];
    [dict setObject:[NSString stringWithFormat:@"%@,desc", doctorStr] forKey:@"user_id"];
    
    [[GoldenLeafNetworkAPIManager shareManager] request_getTopicsListWithParams:dict andBlock:^(id data, NSError *error) {
        NSArray *array = data[@"data"];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in array) {
            [self.dataArray addObject:dict];
        }
        [self.tableView reloadData];
    }];
}
- (NSString *)getBeforeDate{
//    NSDate *date = [NSDate date];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    [adcomps setDay:1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    NSString *beforeDate = [self.dateFormatter stringFromDate:newdate];
//    DebugLog(@"%@", beforeDate);
    
    return beforeDate;
}

- (NSString *)getAfterDateWithNumDateBefore:(CGFloat)dates{
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    [adcomps setDay:dates];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    NSString *afterDateStr = [self.dateFormatter stringFromDate:newdate];
//    DebugLog(@"%@", afterDateStr);
    return afterDateStr;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    DoctorannouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorannouncementTableViewCell" forIndexPath:indexPath];

    if ([dict[@"title"] isKindOfClass:[NSString class]]) {
        cell.contentLabel.text = dict[@"title"];

    }
    if ([dict[@"updated_at"] isKindOfClass:[NSString class]]) {
        cell.dataLabel.text = [NSString getLocalDateFormateUTCDate:dict[@"created_at"]];
    }
    
//    if( [dict[@"user_name"] isKindOfClass:[NSString class]] && [dict[@"location"] isKindOfClass:[NSString class]]){
        NSString *nameStr = [NSString stringWithFormat:@"%@,%@", dict[@"author"][@"user_name"], dict[@"location"]];
        cell.nameLabel.text = nameStr;
//    }

//    cell.nameLabel.text = dict[@"body"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
//    User *user = [User shareUser];
//    
//    if (user.islogin) {
//        user.announcement = @"";
//        [user saveToDisk];
//    }else{
//        if (user.announcement.length > 0 && ![user.announcement isEqualToString:dict[@"title"]]) {
//            DebugLog(@"不能看");
//            NSString *message = [NSString stringWithFormat:@"当前您只能查看标题为<%@>的公告", user.announcement];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您尚未登录,登录之后更精彩" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
//            alert.delegate = self;
//            [alert show];
//            return;
//        }else{
//            user.announcement = dict[@"title"];
//            [user saveToDisk];
//        }
//    }
    
    
    NSString *path = [NSString stringWithFormat:@"%@%@", @"/api/v1/announcements/",dict[@"id"]];
    AnnounceDetailTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AnnounceDetailTableViewController"];
    control.path = path;
    [self.navigationController pushViewController:control animated:YES];
}
- (void)returnBack{
    if (self.isRoot) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfColumnsInMenu:(DropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.dates.count;
    }else if (column == 1){
        return self.cities.count;
    }else {
        return self.doctorUser.count;
    }
}

- (NSString *)menu:(DropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.dates[indexPath.row];
    } else if (indexPath.column == 1){
        return self.cities[indexPath.row];
    } else {
        return self.doctorUser[indexPath.row][@"user_name"];
    }
}
- (void)menu:(DropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    }
    
    if (indexPath.column == 0) {
        if (indexPath.row  < 0) {
            return;
        }
        NSLog(@"%ld", (long)indexPath.row);
        [self loadDataWithDate:self.dates[indexPath.row]];
    }else if (indexPath.column == 1){
        [self loadDataWithCity:self.cities[indexPath.row]];
    }else if(indexPath.column == 2){
        [self loadDataWithDoctor:[NSString stringWithFormat:@"%@", self.doctorUser[indexPath.row][@"id"]]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        LoginViewController *control = [[UIStoryboard storyboardWithName:@"Login" bundle: nil] instantiateInitialViewController];
        //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
        [self presentViewController:control animated:YES completion:nil];
    }
}

- (NSDateFormatter *)dateFormatter{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}
@end
