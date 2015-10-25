//
//  GLMensesRecordSheetViewController.m
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "GLDiagnosisSept2ViewController.h"
#import "Constants.h"

@interface GLDiagnosisSept2ViewController () <
UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet UIButton *submitButton;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(strong, nonatomic) UITextField *activeTextField;
@property(weak, nonatomic) IBOutlet UITextField *firstMonthField;
@property(weak, nonatomic) IBOutlet UITextField *secondMonthField;
@property(weak, nonatomic) IBOutlet UITextField *thirdMonthField;
@property(strong, nonatomic) NSDate *date1, *date2, *date3;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation GLDiagnosisSept2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.scrollView.frame =
//    CGRectMake(0, 0, CGRectGetWidth(self.view.frame), SCREEN_HEIGHT);
//    CGFloat Y;
//    Y = self.submitButton.center.y;
//    self.submitButton.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, Y);
//    self.bgView.frame = CGRectMake(10, 10, CGRectGetWidth([UIScreen mainScreen].bounds)-20, 300);
//    if (IS_IPHONE_4) {
//        CGRect buttonFrame = self.submitButton.frame;
//        buttonFrame.origin.y =
//        SCREEN_HEIGHT - 15.f - CGRectGetHeight(self.submitButton.frame);
//        self.submitButton.frame = buttonFrame;
//    }
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-5];
    NSDate *minDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:currentDate options:0];
    datePicker.minimumDate = minDate;

    datePicker.date = [NSDate date];
    datePicker.maximumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];

    UIToolbar *toolBar = [[UIToolbar alloc]
                          initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    [toolBar setBarStyle:UIBarStyleBlack];
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(resignInputField)];
    [toolBar
     setItems:[NSArray
               arrayWithObjects:[[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:
                                 UIBarButtonSystemItemFlexibleSpace
                                 target:nil
                                 action:nil],
               doneButton, nil]];
//    doneButton.tintColor = [UIColor blackColor];
//    [doneButton setTintColor:[UIColor redColor]];
    
    self.firstMonthField.inputView = datePicker;
    self.firstMonthField.inputAccessoryView = toolBar;
    self.secondMonthField.inputView = datePicker;
    self.secondMonthField.inputAccessoryView = toolBar;
    self.thirdMonthField.inputView = datePicker;
    self.thirdMonthField.inputAccessoryView = toolBar;
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardDidHideNotification
     object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.view endEditing:YES];
}

- (void)dealloc {
    // unregister for keyboard notifications
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
}

#pragma mark - Validation Methods

- (IBAction)validateInput:(id)sender {
    if (!self.firstMonthField.text.length || !self.secondMonthField.text.length ||
        !self.thirdMonthField.text.length) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:@"请输入所有信息！"
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"知道了", nil)
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSInteger diff1 = [self daysFromStartDate:self.date3 toEndDate:self.date2];
    NSInteger diff2 = [self daysFromStartDate:self.date2 toEndDate:self.date1];
    NSInteger diff3 = diff2 - diff1;
    
    UIStoryboard *storyboard =
    [UIStoryboard storyboardWithName:@"Menses" bundle:nil];
    if (ABS(diff3) > 7) {
        // everything is okay.. move on
        UIViewController *vc = [storyboard
                                instantiateViewControllerWithIdentifier:@"ConditionNotNormal"];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIViewController *vc = [storyboard
                                instantiateViewControllerWithIdentifier:@"NormalResultView"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)resignInputField {
    [self.activeTextField resignFirstResponder];
}

- (void)updateTextField:(id)sender {

    UIDatePicker *picker = (UIDatePicker*)self.activeTextField.inputView;
    
    
    self.activeTextField.text = [self.dateFormatter stringFromDate:picker.date];
    
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

#pragma mark - Notification

// Called when the UIKeyboardWillShowNotification is sent.

- (void)keyboardWillShow:(NSNotification *)aNotification {
    if (self.activeTextField.tag == 3) {
        CGRect coveredFrame = self.activeTextField.inputView.frame;
        
        self.scrollView.contentSize = CGSizeMake(
                                                 self.view.frame.size.width,
                                                 SCREEN_HEIGHT + coveredFrame.size.height + coveredFrame.origin.y);
        // scroll to the text view
        [self.scrollView scrollRectToVisible:self.activeTextField.superview.frame
                                    animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHide:(NSNotification *)aNotification {
    if (self.activeTextField.tag == 3) {
        self.scrollView.contentSize =
        CGSizeMake(self.view.frame.size.width, SCREEN_HEIGHT);
        [self.scrollView setContentOffset:CGPointMake(0, -STATUS_NAV_BAR_HEIGHT)];
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

- (NSDateFormatter *)dateFormatter{
    if (_dateFormatter == nil) {
        _dateFormatter =  [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

@end
