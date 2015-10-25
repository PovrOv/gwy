//
//  SettingTableViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "SettingTableViewController.h"
#import "FMActionSheet.h"
#import "ChanegInfoTableViewController.h"
#import "ChangePasswordTableViewController.h"
@interface SettingTableViewController ()<UITextFieldDelegate, FMActionSheetDelegate, ChangeTextInfoProtocol>

@property (weak, nonatomic) IBOutlet UITableViewCell *sexTextField;

@property (weak, nonatomic) IBOutlet UITextField *birthday;

@property (weak, nonatomic) IBOutlet UITextField *sex;
//@property(strong, nonatomic) UITextField *activeTextField;
@property (strong, nonatomic) NSDate *date1, *date2, *date3;
@property (strong, nonatomic) NSMutableDictionary *userInfoDict;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhone;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation SettingTableViewController
- (void)showToastWithMessage:(NSString *)msg{
    CGPoint point = CGPointMake(kScreen_Width/2, kScreen_Height/2);
    [[[UIApplication sharedApplication] keyWindow] makeToast:msg duration:0.3 position:[NSValue valueWithCGPoint:point]];
}

- (void)loadView{
    [super loadView];
//    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-100];
    NSDate *minDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:currentDate options:0];
    datePicker.minimumDate = minDate;
    [comps setYear:-40];
    NSDate *defaultDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:currentDate options:0];
    datePicker.date = defaultDate;
    datePicker.maximumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.birthday setInputView:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc]
                          initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(resignInputField)];
    doneButton.tintColor = [UIColor lightGrayColor];
    [toolBar
     setItems:[NSArray
               arrayWithObjects:[[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:
                                 UIBarButtonSystemItemFlexibleSpace
                                 target:nil
                                 action:nil],
               doneButton, nil]];
    doneButton.tintColor = [UIColor blackColor];
    self.birthday.inputAccessoryView = toolBar;
    
    
    self.sex.delegate = self;
    
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self save];
}
- (void)initView{
   User *user = [User shareUser];
    self.userName.text = user.user_name;
    if ([user.birth_year integerValue] == 0) {
        self.birthday.text = @"未设置";
    }else{
        self.birthday.text = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)[user.birth_year integerValue], (long)[user.birth_month integerValue], (long)[user.birth_day integerValue]];
    }
    
    self.sex.text = user.sex;
    self.mobilePhone.text = user.phone_number;
    self.email.text = user.email_address;
    self.name.text = user.name;
    
}
//active = Y;
//"birth_day" = 1;
//"birth_month" = 2;
//"birth_year" = 1990;
//city = qw;
//"created_at" = "2015-09-14T14:57:53.000Z";
//department = "";
//"email_address" = "lxh@qq.com";
//hospital = "";
//id = 43;
//occupation = "\U4e13\U5bb6";
//"phone_number" = "lxh@qq.com";
//picture = "<null>";
//sex = "\U5973";
//type = user;
//"updated_at" = "2015-09-14T14:57:53.000Z";
//"user_name" = "lxh@qq.com";
//verified = Y;

//- (void)loadData{
//    
//    NSString *path = [NSString stringWithFormat:@"%@%@", @"/api/v1/users/",[User shareUser].userID];
//    [[GoldenLeafNetworkAPIManager shareManager] request_getUserInfoWithPath:path andBlock:^(id data, NSError *error) {
//        if (data) {
//            DebugLog(@"%@", data);
//            self.userInfoDict = [[NSMutableDictionary alloc] initWithDictionary:data[@"data"]];
//            
//            
//            dispatch_async ( dispatch_get_main_queue (), ^{
////                NSString *year = [NSString convertString:self.userInfoDict[@"birth_year"]];
////                NSString *month = [NSString convertString:self.userInfoDict[@"birth_month"]];
////                NSString *day = [NSString convertString:self.userInfoDict[@"birth_day"]]
////                ;
//                self.userName.text = [NSString convertString:self.userInfoDict[@"user_name"]];
//                NSString *birthday = [NSString stringWithFormat:@"%@-%@-%@", self.userInfoDict[@"birth_year"], self.userInfoDict[@"birth_month"], self.userInfoDict[@"birth_day"]];
//                self.birthday.text = birthday;
//                self.sex.text = [NSString convertString:self.userInfoDict[@"sex"]];
//                self.mobilePhone.text = [NSString convertString:self.userInfoDict[@"phone_number"]];
//                self.email.text = [NSString convertString:self.userInfoDict[@"email_address"]];
//                self.name.text = [NSString convertString:self.userInfoDict[@"name"]];
//               
//                User *user = [User shareUser];
//                user.name = self.name.text;
//                [user saveToDisk];
//                [self.tableView reloadData];
//            });
//        }
//    }];
//}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.tableView endEditing:YES];
    FMActionSheet *sheet = [[FMActionSheet alloc] initWithTitle:@"请选择性别" buttonTitles:@[@"男", @"女"] cancelButtonTitle:@"取消" delegate:self];
    sheet.titleFont = [UIFont systemFontOfSize:15];
    sheet.titleBackgroundColor = [UIColor colorWithHexString:@"f4f5f8"];
    sheet.titleColor = [UIColor colorWithHexString:@"666666"];
    sheet.lineColor = [UIColor colorWithHexString:@"dbdce4"];
    [sheet show];
    return NO;
}
- (void)actionSheet:(FMActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    User *user = [User shareUser];
    if ( buttonIndex == 0) {
        self.sex.text = @"男";
        user.sex = @"男";
    }else if (buttonIndex == 1){
        self.sex.text = @"女";
        user.sex = @"女";
    }
    [self.userInfoDict setObject:self.sex.text forKey:@"sex"];
    
    [user saveToDisk];
    [self.sex resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)resignInputField {
    [self.birthday resignFirstResponder];
}
- (void)updateTextField:(id)sender {
//    self.birthday.textColor
    UIDatePicker *picker = (UIDatePicker*)self.birthday.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    self.birthday.text = [dateFormat stringFromDate:picker.date];
    NSArray *dateArray = [self.birthday.text componentsSeparatedByString:@"-"];
    [self.userInfoDict setObject:dateArray[0] forKey:@"birth_year"];
    [self.userInfoDict setObject:dateArray[1] forKey:@"birth_month"];
    [self.userInfoDict setObject:dateArray[2] forKey:@"birth_day"];
    
    User *user = [User shareUser];
    user.birth_year = dateArray[0];
    user.birth_month = dateArray[1];
    user.birth_day = dateArray[2];
    [user saveToDisk];
    
    if (self.birthday.tag == 1) {
        self.date1 = picker.date;
    } else if (self.birthday.tag == 2) {
        self.date2 = picker.date;
    } else if (self.birthday.tag == 3) {
        self.date3 = picker.date;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.birthday = textField;
}
#pragma mark - Table view data source
- (void)returnBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSDate *)dateWithmonth:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

- (NSInteger)daysFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate {
    if (startDate && endDate) {
        NSDateComponents *components =
        [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                        fromDate:startDate
                                          toDate:endDate
                                         options:0];
        
        NSInteger days = [components day];
        return days;
    }
    
    return 0;
}
- (IBAction)loginOutAction:(id)sender {
    [[User shareUser] cleareUser];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"remind.plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    if (array == nil) {
        array = [[NSMutableArray alloc] init];
    }
    
    [array insertObject:@{@"medicine":@"请输入药品名称", @"time":@"请选择用药时间",@"times":@"请输入用药次数"} atIndex:0];
    [array insertObject:@{@"pad":@"请输入药品名称", @"time":@"请选择用药时间",@"times":@"请输入用药次数"} atIndex:1];
    
    [array insertObject:@{@"date":@"请选择"} atIndex:2];
    
    [array writeToFile:path atomically:YES];


    if (![[User shareUser] islogin]) {
        [self showToastWithMessage:@"退出成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self showToastWithMessage:@"退出成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)ChangeTextInfo:(ChangeType)type str:(NSString *)str{
    DebugLog(@"%@", str);
    
    User *user = [User shareUser];
    switch (type) {
        case KUserNameType:{
            self.userName.text = str;
            [self.userInfoDict setObject:str forKey:@"user_name"];
            user.user_name = str;
        }
            break;
        case KMobillePhoneType:{
            self.mobilePhone.text = str;
            [self.userInfoDict setObject:str forKey:@"phone_number"];
            user.phone_number = str;
        }
            break;
        case KEmailType:{
            [self.userInfoDict setObject:str forKey:@"email_address"];
            self.email.text = str;
            
        }
            break;
        case KNameType:{
            self.name.text = str;
            [self.userInfoDict setObject:str forKey:@"name"];
            
            user.name = self.name.text;

        }
            break;
        case KPassWorld:{
            [self.userInfoDict setObject:str forKey:@"password"];
            user.passworld = str;
            [user saveToDisk];
            
            [self updaUserInfo];
        }
            
            break;
            
        default:
            break;
    }
    [user saveToDisk];

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChanegInfoTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChanegInfoTableViewController"];
    control.userInfoDict = [[NSMutableDictionary alloc] initWithDictionary:self.userInfoDict];
    control.delegate = self;
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            control.type = KUserNameType;
            [self.navigationController pushViewController:control animated:YES];
        }else if (indexPath.row == 3){
            control.type = KMobillePhoneType;
            [self.navigationController pushViewController:control animated:YES];
        }else if (indexPath.row == 4){
            control.type = KEmailType;
            [self.navigationController pushViewController:control animated:YES];
        }else if (indexPath.row == 5){
            control.type = KNameType;
            [self.navigationController pushViewController:control animated:YES];
        }
            
        
    }else if (indexPath.section == 2){
//        if (indexPath.row == 1) {
//            <#statements#>
//        }
//        [self.navigationController pushViewController:control animated:YES];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ChangePasswordTableViewController"]) {
        ChangePasswordTableViewController *control = segue.destinationViewController;
        control.delegate = self;
    }
}

- (void)updaUserInfo{
    //    user_name (optional)
    //    email_address (optional)
    //    password (optional)
    //    type ('user' or 'doctor') (optional)
    //    name (optional)
    //    sex (optional)
    //    birth_day (optional)
    //    birth_month (optional)
    //    birth_year (optional)
    //    phone_number (optional)
    //    picture (optional)
    //    occupation (optional)
    //    hospital (optional)
    //    department (optional)
    //    city (optional)
    User *user = [User shareUser];
    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
    if (user.user_name.length > 0) {
        [userInfoDict setObject:user.user_name forKey:@"user_name"];
    }
    
    if (user.email_address.length > 0) {
        [userInfoDict setObject:user.email_address forKey:@"email_address"];
    }
    
    if (user.passworld.length > 0) {
        [userInfoDict setObject:user.passworld forKey:@"password"];
    }
    if (user.name.length > 0) {
        [userInfoDict setObject:user.name forKey:@"name"];
    }
    
    if (user.birth_day) {
        [userInfoDict setObject:user.birth_day forKey:@"birth_day"];
    }
    
    if (user.birth_month) {
        [userInfoDict setObject:user.birth_month forKey:@"birth_month"];
    }
    
    if (user.birth_year) {
        [userInfoDict setObject:user.birth_year forKey:@"birth_year"];
    }
    
    if (user.phone_number.length > 0) {
        [userInfoDict setObject:user.phone_number forKey:@"phone_number"];
    }
    if (user.sex.length > 0) {
        [userInfoDict setObject:user.sex forKey:@"sex"];
    }
    
    [[GoldenLeafNetworkAPIManager shareManager] request_updateUserInfoWithParams:userInfoDict andBlock:^(id data, NSError *error) {
        if (data) {
            DebugLog(@"%@", data);
        }
    }];
 
}

@end
