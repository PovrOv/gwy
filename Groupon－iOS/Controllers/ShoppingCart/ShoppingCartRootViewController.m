//
//  ShoppingCartRootViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/7/29.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "ShoppingCartRootViewController.h"

@interface ShoppingCartRootViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UITextField *codeTextField;
@property(nonatomic, strong)UITextField *oldPassworld;
@property(nonatomic, strong)UITextField *passworld;
@end

@implementation ShoppingCartRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    [self.view addSubview:self.tableView];
    
    [self configureTextfield];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - tableView delegate & datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"获取手机验证码";
            break;
        case 1:
            cell.textLabel.text = @"注册";
            break;
        case 2:
            cell.textLabel.text = @"第三方授权";
            break;
        case 3:
            cell.textLabel.text = @"登入";
            break;
        case 4:
            cell.textLabel.text = @"退出";
            break;
        case 5:
            cell.textLabel.text = @"修改密码";
            break;

        case 6:
            cell.textLabel.text = @"修改个人信息";
            break;

        case 7:
            cell.textLabel.text = @"获取个人信息";
            break;

            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self getMobilePhoneCode];
            break;
        case 1:
            [self registerUser];
            break;
        case 2:
            [self thirdBindLogin];
            break;
        case 3:
            [self getlogin];
            break;
        case 4:
            [self loginOut];
            break;
        case 5:
            [self changePassworld];
            break;
            
        case 6:
            [self changeInfomation];
            break;
            
        case 7:
            [self getInfomation];
            break;
            
            
        default:
            break;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

#pragma mark - private method

- (void)configureTextfield{
    
    
    self.codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
    self.codeTextField.placeholder = @"请填写验证码";
    self.codeTextField.backgroundColor = [UIColor redColor];
    
    self.oldPassworld = [[UITextField alloc] initWithFrame:CGRectMake(0, 50, 200, 30)];
    self.oldPassworld.placeholder = @"请输入旧密码";
    self.oldPassworld.backgroundColor = [UIColor redColor];
    
    self.passworld = [[UITextField alloc] initWithFrame:CGRectMake(0, 90, 200, 30)];
    self.passworld.placeholder = @"请输入新密码";
    self.passworld.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.oldPassworld];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.passworld];

}
- (void)getlogin{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"15000157269" forKey:@"username"];
    //    [dic setObject:@"login" forKey:@"method"];
    [dic setObject:@"123456" forKey:@"password"];
    
//    [[GoldenLeafNetworkAPIManager shareManager] request_loginWithParams:dic andBlock:^(id data, NSError *error) {
//        DebugLog(@"\n=====data%@, \n======error%@", data, error);
//    }];
    
}

- (void)getMobilePhoneCode{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"15000157269" forKey:@"phone"];
//    [[GoldenLeafNetworkAPIManager shareManager] request_getMobilePhoneCodeWithParams:dic andBlock:^(id data, NSError *error) {
//        DebugLog(@"\n=====data%@, \n======error%@", data, error);
//    }];
}

- (void)registerUser{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"15000157269" forKey:@"phone"];
    [dic setObject:@"15000157269" forKey:@"username"];
    [dic setObject:@"li52100" forKey:@"password"];
    [dic setObject:self.codeTextField.text forKey:@"validateCode"];
    [dic setObject:@"上海" forKey:@"city"];

//    [[GoldenLeafNetworkAPIManager shareManager] request_registerWithParams:dic andBlock:^(id data, NSError *error) {
//        DebugLog(@"\n=====data%@, \n======error%@", data, error);
//    }];
}
- (void)thirdBindLogin{
    
}

- (void)loginOut{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
//    [[GoldenLeafNetworkAPIManager shareManager] request_logoutWithParams:dic andBlock:^(id data, NSError *error) {
//        DebugLog(@"\n=====data%@, \n======error%@", data, error);
//    }];
}

- (void)changePassworld{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.oldPassworld.text forKey:@"oldPassword"];
    [dic setObject:self.passworld.text forKey:@"newPassword"];
    [dic setObject:self.passworld.text forKey:@"newPassword2"];
    
//    [[GoldenLeafNetworkAPIManager shareManager] request_changePasswordWithParams:dic andBlock:^(id data, NSError *error) {
//        DebugLog(@"\n=====data%@, \n======error%@", data, error);
//    }];
}
- (void)changeInfomation{
    
}

- (void)getInfomation{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [[GoldenLeafNetworkAPIManager shareManager] request_getUserInfomationWithParams:dic andBlock:^(id data, NSError *error) {
//        DebugLog(@"\n=====data%@, \n======error%@", data, error);
//    }];
}
#pragma mark - getter & setter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, kScreen_Width, CGRectGetHeight(self.view.frame))];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
@end
