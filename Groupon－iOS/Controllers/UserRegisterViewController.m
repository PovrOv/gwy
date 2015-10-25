//
//  UserRegisterViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "RegisterViewModel.h"
#import "TSLocateView.h"
#import "LoginViewModel.h"
@interface UserRegisterViewController ()<UITextFieldDelegate, UIActionSheetDelegate,FMActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTexfield;
@property (weak, nonatomic) IBOutlet UITableViewCell *sexCell;
@property (weak, nonatomic) IBOutlet UITextField *sexTexfield;

@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passworldOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passworldTwoTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressL;

@property (nonatomic, strong)TSLocateView *locateView;

@property (nonatomic, strong) RegisterViewModel *viewModel;
@property(strong, nonatomic) UITextField *activeTextField;
@property(strong, nonatomic) NSDate *date1, *date2, *date3;
@property(nonatomic, strong)  NSDateFormatter *dateFormat;

@end

@implementation UserRegisterViewController
- (void)showToastWithMessage:(NSString *)msg{
    CGPoint point = CGPointMake(kScreen_Width/2, kScreen_Height/2);
    [[[UIApplication sharedApplication] keyWindow] makeToast:msg duration:0.3 position:[NSValue valueWithCGPoint:point]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.registerButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [self blindViewModel];
    
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
    [self.dateTextField setInputView:datePicker];
    
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
    self.dateTextField.inputAccessoryView = toolBar;
    // Do any additional setup after loading the view.
    
    self.sexTexfield.delegate = self;
    
    CGRect frame = self.registerButton.frame;
    frame.size.width = kScreen_Width - 20;
    self.registerButton.frame = frame;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [_locateView removeFromSuperview];
}
- (void)resignInputField {
//    [self.activeTextField resignFirstResponder];
    [self.view endEditing:YES];
}
- (void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.activeTextField.inputView;

    
    self.activeTextField.text = [self.dateFormat stringFromDate:picker.date];
    
    if (self.activeTextField.tag == 1) {
        self.date1 = picker.date;
    } else if (self.activeTextField.tag == 2) {
        self.date2 = picker.date;
    } else if (self.activeTextField.tag == 3) {
        self.date3 = picker.date;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}
- (void)blindViewModel{
    self.viewModel = [[RegisterViewModel alloc] init];
    RAC(self.viewModel, userName) = self.userNameTexfield.rac_textSignal;
    RAC(self.viewModel, sex) = self.sexTexfield.rac_textSignal;
    RAC(self.viewModel, date) = self.dateTextField.rac_textSignal;
    RAC(self.viewModel, address) = self.addressTextField.rac_textSignal;
    RAC(self.viewModel, passworldOne) = self.passworldOneTextField.rac_textSignal;
    RAC(self.viewModel, passworldTwo) = self.passworldTwoTextField.rac_textSignal;
    
//    RAC(self, registerButton.enabled) = [self.viewModel registerButtonIsVisible];
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (!(self.userNameTexfield.text.length > 0)) {
            [self showToastWithMessage:@"用户名不能为空"];
            return;
        }
        DebugLog(@"%@", self.mobilePhoneNum.text);
        
        if (!(self.sexTexfield.text.length > 0)) {
            [self showToastWithMessage:@"性别不能为空"];
            return;
        }
        if (!(self.dateTextField.text.length > 0)) {
            [self showToastWithMessage:@"出生日期不能为空"];
            return;
        }
        if (!(self.addressTextField.text.length > 0)) {
            [self showToastWithMessage:@"地址不能为空"];
            return;
        }
        if ((self.mobilePhoneNum.text.length != 11)) {
            [self showToastWithMessage:@"手机号格式不正确"];
            return;
        }
//        if (!(self.emailAddressL.text.length > 0)) {
//            [self showToastWithMessage:@"邮箱不能为空"];
//            return;
//        }
        if (!(self.passworldOneTextField.text.length > 0)) {
            [self showToastWithMessage:@"密码不能为空"];
            return;
        }
        if (!([self.passworldOneTextField.text isEqualToString:self.passworldTwoTextField.text])) {
            [self showToastWithMessage:@"两次密码输入不一致，请重新输入"];
            return;
        }

        NSString *birthDay = self.dateTextField.text;
        NSArray *birthDayArray = [birthDay componentsSeparatedByString:@"-"];
        
        
        NSDictionary *dic = @{@"user_name":self.userNameTexfield.text, @"email_address":self.emailAddressL.text, @"password":self.passworldOneTextField.text, @"type":@"user", @"sex":self.sexTexfield.text,  @"birth_day":birthDayArray[2], @"birth_month":birthDayArray[1], @"birth_year":birthDayArray[0], @"phone_number":self.mobilePhoneNum.text, @"picture":@"", @"occupation":@"", @"hospital":@"", @"department":@"", @"city":self.addressTextField.text};
        
        
        [self.viewModel request_RegisterWith:[[NSMutableDictionary alloc] initWithDictionary:dic] andBlock:^(BOOL success) {
            if (success) {
                [User shareUser].passworld = self.passworldOneTextField.text;
                [[User  shareUser] saveToDisk];
                [[NSNotificationCenter defaultCenter] postNotificationName:KLoginNotification object:nil];
                [LoginViewModel loginRequest_Params:[[NSMutableDictionary alloc] initWithDictionary:@{@"user_name":self.userNameTexfield.text , @"password":self.passworldTwoTextField.text}] andBlock:^(BOOL success) {
                    if (success) {
//                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
//                        [self showToastWithMessage:@"账号或密码不匹配，请重新输入"];
                    }
                    
                }];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self showToastWithMessage:@"注册失败，请核对手机号是否正确,或者换个用户名试试？"];
            }
        }];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DebugLog(@"%@", indexPath);
    if (indexPath.section == 1 && indexPath.row == 3) {
//        CJAreaPicker *picker = [[CJAreaPicker alloc]initWithStyle:UITableViewStylePlain];
//        picker.delegate = self;
//        
//        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:picker];
//        
//        [self presentViewController:navc animated:YES completion:nil];
        if (_locateView != nil) {
            [_locateView removeFromSuperview];
        }
        _locateView = [[TSLocateView alloc] initWithTitle:@"请选择城市" delegate:self];
        [_locateView showInView:[UIApplication sharedApplication].keyWindow];
    }
}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    TSLocateView *locateView = (TSLocateView *)actionSheet;
//    TSLocation *location = locateView.locate;
//    NSLog(@"city:%@ lat:%f lon:%f", location.city, location.latitude, location.longitude);
//    self.addressTextField.text = location.city;
//    //You can uses location to your application.
//    if(buttonIndex == 0) {
//        NSLog(@"Cancel");
//    }else {
//        NSLog(@"Select");
//    }
//}

//#pragma mark -- CJAreaPickerDelegate
//
//- (void)areaPicker:(CJAreaPicker *)picker didSelectAddress:(NSString *)address {
//    
//    self.addressTextField.text = address;
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tableView endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.sexTexfield) {
        [self.tableView endEditing:YES];
        FMActionSheet *sheet = [[FMActionSheet alloc] initWithTitle:@"请选择性别" buttonTitles:@[@"男", @"女"] cancelButtonTitle:@"取消" delegate:self];
        sheet.titleFont = [UIFont systemFontOfSize:15];
        sheet.titleBackgroundColor = [UIColor colorWithHexString:@"f4f5f8"];
        sheet.titleColor = [UIColor colorWithHexString:@"666666"];
        sheet.lineColor = [UIColor colorWithHexString:@"dbdce4"];
        [sheet show];
        return NO;
    }
    return YES;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 1000) {
        TSLocateView *locateView = (TSLocateView *)actionSheet;
        TSLocation *location = locateView.locate;
        NSLog(@"city:%@ lat:%f lon:%f", location.city, location.latitude, location.longitude);
        self.addressTextField.text = location.city;
        //You can uses location to your application.
        if(buttonIndex == 0) {
            NSLog(@"Cancel");
        }else {
            NSLog(@"Select");
        }
        return;
    }
    if ( buttonIndex == 0) {
        self.sexTexfield.text = @"男";
    }else if (buttonIndex == 1){
        self.sexTexfield.text = @"女";
    }
    [self.sexTexfield resignFirstResponder];
}
#pragma mark - Notification

// Called when the UIKeyboardWillShowNotification is sent.

- (void)keyboardWillShow:(NSNotification *)aNotification {
    if (self.activeTextField.tag == 3) {
//        CGRect coveredFrame = self.activeTextField.inputView.frame;
        
////        self.scrollView.contentSize = CGSizeMake(
//                                                 self.view.frame.size.width,
//                                                 SCREEN_HEIGHT + coveredFrame.size.height + coveredFrame.origin.y);
//        // scroll to the text view
////        [self.scrollView scrollRectToVisible:self.activeTextField.superview.frame
////                                    animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHide:(NSNotification *)aNotification {
    if (self.activeTextField.tag == 3) {
//        self.scrollView.contentSize =
//        CGSizeMake(self.view.frame.size.width, SCREEN_HEIGHT);
//        [self.scrollView setContentOffset:CGPointMake(0, -STATUS_NAV_BAR_HEIGHT)];
    }
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

- (NSDateFormatter *)dateFormat{
    if (_dateFormat == nil) {
       _dateFormat = [[NSDateFormatter alloc] init];
        [_dateFormat setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormat;
}
@end
