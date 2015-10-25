//
//  MeDoctorCenter.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/15.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "MeDoctorCenter.h"
#import "TSLocateView.h"
#import "MBProgressHUD.h"
@interface MeDoctorCenter ()<UIActionSheetDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextfiled;
@property (weak, nonatomic) IBOutlet UITextField *hospitalTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextField;
@property (nonatomic, assign) BOOL could;

@property (nonatomic, strong) TSLocateView *locateView;
@end
@implementation MeDoctorCenter
- (void)showToastWithMessage:(NSString *)msg{
    CGPoint point = CGPointMake(kScreen_Width/2, kScreen_Height/2);
    [[[UIApplication sharedApplication] keyWindow] makeToast:msg duration:0.3 position:[NSValue valueWithCGPoint:point]];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = item;
    self.title = @"个人特区";
}

- (void)returnBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_locateView removeFromSuperview];
}

//user_id
//title
//body
//hospital (optional)
//location (optional)
- (IBAction)sendAction:(id)sender {
    if (_could) {
        return;
    }
    [self.tableView endEditing:YES];
    
    
    if (!self.userNameTextfiled.text.length > 0) {
        [self showToastWithMessage:@"标题不能为空"];
        return;
    }
    if (!self.hospitalTextField.text.length > 0) {
        [self showToastWithMessage:@"所在医院不能为空"];
        return;
    }
    if (!self.cityTextField.text.length > 0) {
        [self showToastWithMessage:@"城市不能为空"];
        return;
    }
    if (!self.contentTextField.text.length > 0) {
        [self showToastWithMessage:@"内容不能为空"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"发布公告中...";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.userNameTextfiled.text forKey:@"title"];
    [dict setObject:self.contentTextField.text forKey:@"body"];
    [dict setObject:[User shareUser].userID forKey:@"user_id"];
    [dict setObject:self.hospitalTextField.text forKey:@"hospital"];
    [dict setObject:self.cityTextField.text forKey:@"location"];
    _could = YES;
    [[GoldenLeafNetworkAPIManager shareManager] request_createTopicsWithParams:dict andBlock:^(id data, NSError *error) {
        if (data) {
//            DebugLog(@"%@", data);
            [hud hide:YES];
//            btn.enabled = YES;
            _could = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [hud hide:YES];
            [self showToastWithMessage:@"服务器繁忙，请稍候再试"];
            _could = NO;
        }
    }];
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DebugLog(@"%@", indexPath);
    [self.tableView endEditing:YES];
    if (indexPath.section == 0 && indexPath.row == 2) {
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
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self sendAction:nil];
    }
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
        self.cityTextField.text = location.city;
        return;
        
    }
}


#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -- CJAreaPickerDelegate

//- (void)areaPicker:(CJAreaPicker *)picker didSelectAddress:(NSString *)address {
//    
//    self.cityTextField.text = address;
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
@end
