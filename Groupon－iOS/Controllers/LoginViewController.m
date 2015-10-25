//
//  LoginViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "LoginViewController.h"
#import "UserRegisterViewController.h"
#import "DoctorRegisterViewController.h"
#import "LoginViewModel.h"
@interface LoginViewController ()<FMActionSheetDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWorldTextField;
@property (nonatomic, strong) LoginViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation LoginViewController
- (void)showToastWithMessage:(NSString *)msg{
    CGPoint point = CGPointMake(kScreen_Width/2, kScreen_Height/2);
    [[[UIApplication sharedApplication] keyWindow] makeToast:msg duration:0.3 position:[NSValue valueWithCGPoint:point]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self blindViewModel];
    // Do any additional setup after loading the view.
}

- (void)blindViewModel{
    self.viewModel = [[LoginViewModel alloc] init];
    
    RAC(self.viewModel, nameStr) = self.userNameTextField.rac_textSignal;
    RAC(self.viewModel, passworldStr) = self.passWorldTextField.rac_textSignal;
    
    RAC(self, loginButton.enabled) = [self.viewModel loginButtonIsVisible];
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (!(self.userNameTextField.text.length >0)) {
            [self showToastWithMessage:@"账号不能为空，请重新输入"];
            return;
        }
        
        if (!(self.passWorldTextField.text.length >0)) {
            [self showToastWithMessage:@"密码不能为空，请重新输入"];
            return;
        }

        [LoginViewModel loginRequest_Params:[[NSMutableDictionary alloc] initWithDictionary:@{@"user_name":self.userNameTextField.text , @"password":self.passWorldTextField.text}] andBlock:^(BOOL success) {
            if (success) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self showToastWithMessage:@"账号或密码不匹配，请重新输入"];
            }
            
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registerAction:(id)sender {
    FMActionSheet *sheet = [[FMActionSheet alloc] initWithTitle:@"请选择您要注册的类型" buttonTitles:@[@"用户注册", @"医生注册"] cancelButtonTitle:@"取消" delegate:self];
    sheet.titleFont = [UIFont systemFontOfSize:15];
    sheet.titleBackgroundColor = [UIColor colorWithHexString:@"f4f5f8"];
    sheet.titleColor = [UIColor colorWithHexString:@"666666"];
    sheet.lineColor = [UIColor colorWithHexString:@"dbdce4"];
    [sheet show];

}
- (IBAction)didFinishEdtiAction:(id)sender {
    [self.view endEditing:YES];
}

- (void)actionSheet:(FMActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ( buttonIndex == 0) {
        [self performSegueWithIdentifier:@"UserRegisterViewController" sender:nil];
    }else if (buttonIndex == 1){
        [self performSegueWithIdentifier:@"DoctorRegisterViewController" sender:nil];
    }
}

- (void)returnBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

@end
