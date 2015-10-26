//
//  RemindInputViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "RemindInputViewController.h"
#import "RemindMedicineAndPadNameViewController.h"
#import "FMActionSheet.h"
#import "TimePickerView.h"
#import "MBProgressHUD.h"
@interface RemindInputViewController ()<RemindProtocol, FMActionSheetDelegate, TimePickerViewDelegate, UITextFieldDelegate>{
    NSInteger _medicineTimes;
    NSInteger _padTimes;
    
    BOOL updateMedician;
    BOOL updatePad;
    BOOL updateDaily;
    
    long medicianID;
    long padID;
    long dailyID;
}
@property (weak, nonatomic) IBOutlet UISwitch *medthinSwitch;
@property (weak, nonatomic) IBOutlet UILabel *medithName;
@property (weak, nonatomic) IBOutlet UILabel *medithNum;
@property (weak, nonatomic) IBOutlet UILabel *medithTime;

@property (weak, nonatomic) IBOutlet UISwitch *padSwitch;
@property (weak, nonatomic) IBOutlet UILabel *padName;
@property (weak, nonatomic) IBOutlet UILabel *padNum;
@property (weak, nonatomic) IBOutlet UILabel *padTime;

@property (weak, nonatomic) IBOutlet UILabel *clineTime;
@property (weak, nonatomic) IBOutlet UITableViewCell *medicineNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *medicineNumCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *medicineTimeCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *padNameCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *padNumCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *padTimeCell;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@end
@implementation RemindInputViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-100];
    NSDate *minDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:currentDate options:0];
    datePicker.minimumDate = minDate;
    [comps setYear:-40];
//    NSDate *defaultDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:currentDate options:0];
    datePicker.date = currentDate;
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
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"remind.plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    
    if (array == nil) {
//        array = [[NSMutableArray alloc] init];
    }else{
        self.medithName.text = array[0][@"medicine"];
        self.medithNum.text = array[0][@"times"];
        self.medithTime.text = array[0][@"time"];
        
        self.padName.text = array[1][@"pad"];
        self.padNum.text = array[1][@"times"];
        self.padTime.text = array[1][@"time"];
        
        self.dateTextField.text = array[2][@"date"];
    }
    
    [self setup];

}

- (void)setup{
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"remind.plist"];
    NSMutableArray *arrayM = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    NSDictionary *medDic = arrayM[0];
    if ([[medDic allKeys] containsObject:@"medicine"]) {
        if ([medDic[@"time"] hadSetted]) {
            updateMedician = YES;
            medicianID = [medDic[@"id"] longValue];
            
        }else{
            updateMedician = NO;
        }
    }
    NSDictionary *padDic = arrayM[1];
    if ([[padDic allKeys] containsObject:@"pad"]) {
        if ([padDic[@"time"] hadSetted]) {
            updatePad = YES;
            NSLog(@"%ld", [padDic[@"id"] longValue]);
           padID = [padDic[@"id"] longValue];
        }else{
            updatePad = NO;
        }
        
    }
        NSDictionary *dateDic = arrayM[2];
    if ([[dateDic allKeys] containsObject:@"date"]) {
        NSString *dateM = [dateDic[@"date"] countDays];
        if ([dateM isEqualToString:@"未设置"]) {
            updateDaily = NO;
//           dailyID = [medDic[@"id"] longValue];
        }else{
            updateDaily = YES;
            dailyID = [dateDic[@"id"] longValue];
        }
    }
    
}
- (IBAction)medicineSwitchAction:(id)sender {
    if (self.medthinSwitch.isOn == NO) {
        self.medicineNameCell.userInteractionEnabled = NO;
        self.medicineNumCell.userInteractionEnabled =NO;
        self.medicineTimeCell.userInteractionEnabled = NO;
    }else{
        self.medicineNameCell.userInteractionEnabled = YES;
        self.medicineNumCell.userInteractionEnabled =YES;
        self.medicineTimeCell.userInteractionEnabled = YES;
    }
}

- (IBAction)padSwitchAction:(id)sender {
    if (self.padSwitch.isOn == NO) {
        self.padNameCell.userInteractionEnabled = NO;
        self.padNumCell.userInteractionEnabled =NO;
        self.padTimeCell.userInteractionEnabled = NO;
    }else{
        self.padNameCell.userInteractionEnabled = YES;
        self.padNumCell.userInteractionEnabled =YES;
        self.padTimeCell.userInteractionEnabled = YES;
    }
}

//day (optional)
//time (optional)

//medicine (y/n)
//pad (y/n)
//medicine_name (optional)





- (IBAction)send:(id)sender {
    
//    [MBProgressHUD showHUDAddedTo:delegate.view animated:YES];
//    _mbpgHUD.dimBackground=YES;//将当前的view至于后台
//    [_mbpgHUD setMode:MBProgressHUDModeIndeterminate];
//    _mbpgHUD.labelText =title;
//    _mbpgHUD.delegate=(id)delegate;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"提交提醒中...";
    hud.margin = 10.f;
//    hud.yOffset = 150.f;
    hud.dimBackground=YES;
    hud.removeFromSuperViewOnHide = YES;
    
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"remind.plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
 
    
    if (self.medthinSwitch.isOn == YES && ![self.medithName.text isEqualToString:@"请输入药品名称"]) {
        
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[User shareUser].userID forKey:@"user_id"];
        [dic setObject:@"y" forKey:@"daily"];
        [dic setObject:@"y" forKey:@"weekly"];
        
        [dic setObject:@"n" forKey:@"pad"];
        [dic setObject:@"y" forKey:@"medicine"];
        [dic setObject:self.medithName.text forKey:@"medicine_name"];
        [dic setObject:self.medithTime.text forKey:@"time"];
        
        [array removeObjectAtIndex:0];
        NSArray *M = [self.medithTime.text componentsSeparatedByString:@","];
        [array insertObject:@{@"medicine":self.medithName.text, @"time":self.medithTime.text,@"times":@(M.count), @"id":@(medicianID)} atIndex:0];
        
        
        if (updateMedician) {
            [[GoldenLeafNetworkAPIManager shareManager] request_updateRemindWithParams:dic withReminder_id:medicianID andBlock:^(id data, NSError *error) {
                if (data) {
                    DebugLog(@"%@", data);
                }
            }];
        }else{
            [[GoldenLeafNetworkAPIManager shareManager] request_createRemindWithParams:dic andBlock:^(id data, NSError *error) {
                if (data) {
                    DebugLog(@"%@", data);
                    updateMedician = YES;
                }
            }];
        }
        
    }else{
        [array removeObjectAtIndex:0];
        [array insertObject:@{@"medicine":@"请输入药品名称", @"time":@"请选择用药时间",@"times":@"请输入用药次数"} atIndex:0];
        
        if (medicianID > 0) {
            [[GoldenLeafNetworkAPIManager shareManager] request_deleteRemindWithReminder_id:medicianID andBlock:^(id data, NSError *error) {
                DebugLog(@"%@", data);
            }];
        }
    }
    if(self.padSwitch.isOn == YES && ![self.padName.text isEqualToString:@"请输入药品名称"]){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[User shareUser].userID forKey:@"user_id"];
        [dic setObject:@"y" forKey:@"daily"];
        [dic setObject:@"y" forKey:@"weekly"];
        
        [dic setObject:@"y" forKey:@"pad"];
        [dic setObject:@"n" forKey:@"medicine"];
        [dic setObject:self.padName.text forKey:@"medicine_name"];
        [dic setObject:self.padTime.text forKey:@"time"];
        
        [array removeObjectAtIndex:1];
        NSArray *M = [self.padTime.text componentsSeparatedByString:@","];
        [array insertObject:@{@"pad":self.padName.text, @"time":self.padTime.text,@"times":@(M.count), @"id":@(padID)} atIndex:1];
        
        if (updatePad) {
            [[GoldenLeafNetworkAPIManager shareManager] request_updateRemindWithParams:dic withReminder_id:padID  andBlock:^(id data, NSError *error) {
                if (data) {
                    DebugLog(@"%@", data);
                }
            }];
        }else{
            [[GoldenLeafNetworkAPIManager shareManager] request_createRemindWithParams:dic andBlock:^(id data, NSError *error) {
                if (data) {
                    DebugLog(@"%@", data);
                    updatePad = YES;
                    
                }
            }];
        }
    
    }else{
        [array removeObjectAtIndex:1];
        [array insertObject:@{@"pad":@"请输入药品名称", @"time":@"请选择用药时间",@"times":@"请输入用药次数"} atIndex:1];
        
        if (padID > 0) {
            [[GoldenLeafNetworkAPIManager shareManager] request_deleteRemindWithReminder_id:padID andBlock:^(id data, NSError *error) {
                if (data) {
                    DebugLog(@"%@", data);
                }
            }];

        }
        
    }
    
    if(self.dateTextField.text.length && ![self.dateTextField.text isEqualToString:@"请选择"]){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[User shareUser].userID forKey:@"user_id"];
        [dic setObject:@"y" forKey:@"daily"];
        [dic setObject:@"y" forKey:@"weekly"];
        
        [dic setObject:@"n" forKey:@"pad"];
        [dic setObject:@"n" forKey:@"medicine"];
        
        [dic setObject:self.dateTextField.text forKey:@"day"];
        
        [array removeObjectAtIndex:2];
        [array insertObject:@{@"date":self.dateTextField.text, @"id":@(dailyID)} atIndex:2];
        if (updateDaily) {
            [[GoldenLeafNetworkAPIManager shareManager] request_updateRemindWithParams:dic withReminder_id:dailyID andBlock:^(id data, NSError *error) {
                if (data) {
                    DebugLog(@"%@", data);
                }
            }];
        }else{
            [[GoldenLeafNetworkAPIManager shareManager] request_createRemindWithParams:dic andBlock:^(id data, NSError *error) {
                if (data) {
                    DebugLog(@"%@", data);
                    updateDaily = YES;
                }
            }];
        }
    }else{
        [array removeObjectAtIndex:2];
        [array insertObject:@{@"date":@"请选择"} atIndex:2];
    }
    [array writeToFile:path atomically:YES];
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"remind.plist"];
//    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
//    if (array == nil) {
//        array = [[NSMutableArray alloc] init];
//    }
//    if (self.medthinSwitch.isOn == YES) {
//        if(array.count > 0){
//            [array removeObjectAtIndex:0];
//        }
//        
//        [array insertObject:@{@"medicine":self.medithName.text, @"time":self.medithTime.text,@"times":self.medithNum.text} atIndex:0];
//    }else{
//        if(array.count > 0){
//            [array removeObjectAtIndex:0];
//        }
//        
//        [array insertObject:@{@"medicine":@"请输入药品名称", @"time":@"请选择用药时间",@"times":@"请输入用药次数"} atIndex:0];
//    }
//    if (self.padSwitch.isOn == YES) {
//        
////        [array addObject:dict];
////        NSArray *medicineTimesArray = [self.padTime.text componentsSeparatedByString:@"   "];
////        for (NSString *time in medicineTimesArray) {
//        if (array.count >= 2) {
//            [array removeObjectAtIndex:1];
//        }
//        [array insertObject:@{@"pad":self.padName.text, @"time":self.padTime.text, @"times" : self.padNum.text} atIndex:1];
////        }
//    }else{
//        if (array.count >= 2) {
//            [array removeObjectAtIndex:1];
//        }
//        [array insertObject:@{@"pad":@"请输入药品名称", @"time":@"请选择用药时间",@"times":@"请输入用药次数"} atIndex:1];
//    }
//    if (self.dateTextField.text.length) {
//        
//        if (array.count >= 3) {
//            [array removeObjectAtIndex:2];
//        }
////        NSDictionary *dict = @{@"tip":[NSString stringWithFormat:@"别忘了%@后随诊", self.dateTextField.text]};
//        if (![self.dateTextField.text isEqualToString:@"请选择"]) {
//            [array insertObject:@{@"date":self.dateTextField.text} atIndex:2];
//        }else{
//            [array insertObject:@{@"date":@"请选择"} atIndex:2];
//        }
//        
//    }
//    [array writeToFile:path atomically:YES];
//    [self.navigationController popViewControllerAnimated:YES];
    
    [hud hide:YES afterDelay:6];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if(indexPath.row == 1){
                [self performSegueWithIdentifier:@"remindSegue" sender:@{@"type":@(KMedicineName)}];
            }else if(indexPath.row == 2){
                FMActionSheet *sheet = [[FMActionSheet alloc] initWithTitle:@"请选择用药次数" buttonTitles:@[@"每天一次", @"每天两次",  @"每天三次"] cancelButtonTitle:@"取消" delegate:self];
                sheet.tag = 1000;
                sheet.titleFont = [UIFont systemFontOfSize:15];
                sheet.titleBackgroundColor = [UIColor colorWithHexString:@"f4f5f8"];
                sheet.titleColor = [UIColor colorWithHexString:@"666666"];
                sheet.lineColor = [UIColor colorWithHexString:@"dbdce4"];
                [sheet show];
            }else if (indexPath.row == 3){
                TimePickerView *view = [[TimePickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) withTimes:_medicineTimes];
                view.tag = 201;
                view.delegate = self;
                [self.view addSubview:view];
                [view show];
            }else{
                
            }
        }
            
            break;
        case 1:{
            if(indexPath.row == 1){
                [self performSegueWithIdentifier:@"remindSegue" sender:@{@"type":@(KPadName)}];
            }else if(indexPath.row == 2){
                FMActionSheet *sheet = [[FMActionSheet alloc] initWithTitle:@"请选择用药次数" buttonTitles:@[@"每天一次", @"每天两次",  @"每天三次"] cancelButtonTitle:@"取消" delegate:self];
                sheet.tag = 1001;
                sheet.titleFont = [UIFont systemFontOfSize:15];
                sheet.titleBackgroundColor = [UIColor colorWithHexString:@"f4f5f8"];
                sheet.titleColor = [UIColor colorWithHexString:@"666666"];
                sheet.lineColor = [UIColor colorWithHexString:@"dbdce4"];
                [sheet show];
            }else if (indexPath.row == 3){
                TimePickerView *view = [[TimePickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) withTimes:_padTimes];
                
                view.tag = 202;
                view.delegate = self;
                [self.view addSubview:view];
                [view show];
            }else{
            
            }

        }
            
            break;

        case 2:{
            
        }
            
            break;

            
        default:
            break;
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier  isEqual: @"remindSegue"]) {
        RemindMedicineAndPadNameViewController *control = segue.destinationViewController;
        control.delegate = self;
        NSDictionary *dict = (NSDictionary *)sender;
        control.type = [dict[@"type"] integerValue];
    }
}

- (void)ChangeTextInfo:(RemindType)type str:(NSString *)str{
    switch (type) {
        case KMedicineName:{
            self.medithName.text = str;
        }
            
            break;
        case KMedicineNum:{
            self.medithNum.text = str;
        }
            
            break;

        case KPadName:{
            self.padName.text = str;
        }
            
            break;

        case KPadNum:{
            self.padNum.text = str;
        }
            
            break;

            
        default:
            break;
    }
}

- (void)actionSheet:(FMActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        switch (buttonIndex) {
            case 0:{
                self.medithNum.text = @"每天一次";
                _medicineTimes = 1;
            }
                break;
            case 1:{
                self.medithNum.text = @"每天两次";
                _medicineTimes = 2;
            }
                break;
            case 2:{
                self.medithNum.text = @"每天三次";
                _medicineTimes = 3;
            }
                break;
//            case 3:{
//                self.medithNum.text = @"每天四次";
//                _medicineTimes = 4;
//            }
//                break;
                
            default:
                break;
        }
        
    }else if (actionSheet.tag == 1001){
        switch (buttonIndex) {
            case 0:{
                self.padNum.text = @"每天一次";
                _padTimes = 1;
            }
                break;
            case 1:{
                self.padNum.text = @"每天两次";
                _padTimes = 2;
            }
                break;
            case 2:{
                self.padNum.text = @"每天三次";
                _padTimes = 3;
            }
                break;
//            case 3:{
//                self.padNum.text = @"每天四次";
//                _padTimes = 4;
//            }
//                break;
                
            default:
                break;
        }

    }
}

- (void)timePickerViewDidFinish:(TimePickerView *)pickerView str:(NSString *)timeStr{
    if (pickerView.tag == 201) {
        self.medithTime.text = timeStr;
    }else{
        self.padTime.text = timeStr;
    }
}


- (void)resignInputField {
    //    [self.activeTextField resignFirstResponder];
    [self.view endEditing:YES];
}
- (void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.dateTextField.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    
    self.dateTextField.text = [dateFormat stringFromDate:picker.date];
    
//    if (self.dateTextField.tag == 1) {
//        self.date1 = picker.date;
//    } else if (self.activeTextField.tag == 2) {
//        self.date2 = picker.date;
//    } else if (self.activeTextField.tag == 3) {
//        self.date3 = picker.date;
//    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.dateTextField = textField;
}
@end
