//
//  DoctorRegisterViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "DoctorRegisterViewController.h"
#import "RegisterViewModel.h"
#import "TSLocateView.h"
#import "LoginViewModel.h"
@interface DoctorRegisterViewController ()<UITextFieldDelegate, FMActionSheetDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *positionaltitlesTextField;

@property (weak, nonatomic) IBOutlet UITextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *hospitalTextField;
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *telPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passworldOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passworldTwoTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *sexCell;
@property (weak, nonatomic) IBOutlet UITextField *titlesCell;

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (nonatomic, strong)RegisterViewModel *viewModel;
@property (nonatomic, strong)TSLocateView *locateView;
@property(strong, nonatomic) NSDate *date1, *date2, *date3;
@property(strong, nonatomic) UITextField *activeTextField;
@end

@implementation DoctorRegisterViewController
- (void)showToastWithMessage:(NSString *)msg{
    CGPoint point = CGPointMake(kScreen_Width/2, kScreen_Height/2);
    [[[UIApplication sharedApplication] keyWindow] makeToast:msg duration:0.3 position:[NSValue valueWithCGPoint:point]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self blindViewModel];
    // Do any additional setup after loading the view.
    self.sexTextField.delegate = self;
    
}

- (void)blindViewModel{
    self.viewModel = [[RegisterViewModel alloc] init];
    RAC(self.viewModel, userName) = self.userNameTextField.rac_textSignal;
    RAC(self.viewModel, sex) = self.sexTextField.rac_textSignal;
    RAC(self.viewModel, address) = self.addressTextField.rac_textSignal;
    RAC(self.viewModel, positionaltitles) = self.positionaltitlesTextField.rac_textSignal;
    RAC(self.viewModel, hospital) = self.hospitalTextField.rac_textSignal;
    RAC(self.viewModel, department) = self.departmentTextField.rac_textSignal;
    RAC(self.viewModel, telPhoneNum) = self.telPhoneTextField.rac_textSignal;
    RAC(self.viewModel, emailAddress) = self.emailTextField.rac_textSignal;
    RAC(self.viewModel, passworldOne) = self.passworldOneTextField.rac_textSignal;
    RAC(self.viewModel, passworldTwo) = self.passworldTwoTextField.rac_textSignal;
    
//    RAC(self.registerButton, enabled) = [self.viewModel registerDoctorButtonIsVisible];
    
    
    
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (!(self.userNameTextField.text.length > 0)) {
            [self showToastWithMessage:@"用户名不能为空"];
            return;
        }
        
        if (!(self.positionaltitlesTextField.text.length > 0)) {
            [self showToastWithMessage:@"职称不能为空"];
            return;
        }
        
        if (!(self.sexTextField.text.length > 0)) {
            [self showToastWithMessage:@"性别不能为空"];
            return;
        }
        
        if (!(self.addressTextField.text.length > 0)) {
            [self showToastWithMessage:@"城市不能为空"];
            return;
        }
        
        if (!(self.hospitalTextField.text.length > 0)) {
            [self showToastWithMessage:@"所属医院不能为空"];
            return;
        }
        
        if (!(self.departmentTextField.text.length >0)) {
            [self showToastWithMessage:@"科室不能为空"];
            return;
        }
        
        if (!(self.telPhoneTextField.text.length > 0)) {
            [self showToastWithMessage:@"电话不能为空"];
            return;
        }
        if (!(self.nameLabel.text.length > 0)) {
            [self showToastWithMessage:@"姓名不能为空"];
            return;
        }

        
//        if (!(self.emailTextField.text.length > 0)) {
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

        
       NSDictionary *dic = @{@"user_name":self.userNameTextField.text, @"email_address":self.emailTextField.text, @"password":self.passworldOneTextField.text, @"type":@"doctor", @"sex":self.sexTextField.text,  @"birth_day":@"", @"birth_month":@"", @"birth_year":@"", @"phone_number":self.telPhoneTextField.text, @"picture":@"", @"occupation":self.positionaltitlesTextField.text, @"hospital":self.hospitalTextField.text, @"department":self.departmentTextField.text, @"city":self.addressTextField.text, @"name":self.nameLabel.text};
        [self.viewModel request_RegisterDoctorWith:[[NSMutableDictionary alloc] initWithDictionary:dic] andBlock:^(BOOL success) {
            if (success) {
                [User shareUser].passworld = self.passworldOneTextField.text;
                [[User  shareUser] saveToDisk];
                [[NSNotificationCenter defaultCenter] postNotificationName:KLoginNotification object:nil];
                [LoginViewModel loginRequest_Params:[[NSMutableDictionary alloc] initWithDictionary:@{@"user_name":self.userNameTextField.text , @"password":self.passworldTwoTextField.text}] andBlock:^(BOOL success) {
                    if (success) {
//                                                [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        //                        [self showToastWithMessage:@"账号或密码不匹配，请重新输入"];
                    }
                    
                }];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self showToastWithMessage:@"注册失败，请核对手机号,或者换个用户名试试？"];
            }
        }];
         }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DebugLog(@"%@", indexPath);
    if (indexPath.section == 1 && indexPath.row == 3) {
//        [self.tableView endEditing:YES];
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_locateView removeFromSuperview];
    
}
//#pragma mark -- CJAreaPickerDelegate
//
//- (void)areaPicker:(CJAreaPicker *)picker didSelectAddress:(NSString *)address {
//    
//    self.addressTextField.text = address;
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.tableView endEditing:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tableView endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.sexTextField) {
//        [textField resignFirstResponder];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1000) {
        TSLocateView *locateView = (TSLocateView *)actionSheet;
        TSLocation *location = locateView.locate;
        NSLog(@"city:%@ lat:%f lon:%f", location.city, location.latitude, location.longitude);
        //You can uses location to your application.
        //    if(buttonIndex == 0) {
        //        NSLog(@"Cancel");
        //    }else {
        //        NSLog(@"Select");
        //    }
        self.addressTextField.text = location.city;
        return;

    }
    
    if ( buttonIndex == 0) {
        self.sexTextField.text = @"男";
    }else if (buttonIndex == 1){
        self.sexTextField.text = @"女";
    }
    [self.sexTextField resignFirstResponder];
}

//- (void)actionSheet:(FMActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//}
@end
