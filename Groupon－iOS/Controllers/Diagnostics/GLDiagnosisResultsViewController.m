//
//  GLDiagnosisResulsViewController.m
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "GLDiagnosisResultsViewController.h"
#import "GLUserSession.h"
#import "AppDelegate.h"

@interface GLDiagnosisResultsViewController ()

@property(strong, nonatomic) GLUserSession *currentSession;
@property(strong, nonatomic) NSString *nextResultStr;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GLDiagnosisResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"诊断结果";
    self.currentSession = [GLUserSession sharedManager];
    
    if (!self.buttonText) {
        [self.okButton
         setTitle:NSLocalizedString(@"WHAT_NEXT_STR",
                                    "Submit button on Course of Action page ")
         forState:UIControlStateNormal];
    } else {
        [self.okButton setTitle:self.buttonText forState:UIControlStateNormal];
        [self.okButton addTarget:self
                          action:@selector(dismissPage)
                forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.resultText) {
        // Do any additional setup after loading the view.
        switch (self.condition) {
            case 0: {
                [self.resultLabel setText:NSLocalizedString(@"DIAGNOSIS_RESULTS_MILD_STR",
                                                            "Mild Results")];
                
                self.nextResultStr = NSLocalizedString(@"DIAGNOSIS_ACTION_MILD_STR",
                                                            "Mild Results");
                
                [self.okButton addTarget:self
                                  action:@selector(showMildDetails)
                        forControlEvents:UIControlEventTouchUpInside];
                
                break;
            }
            case 1: {
                [self.resultLabel
                 setText:NSLocalizedString(@"DIAGNOSIS_RESULTS_MODERATE_STR",
                                           "Moderate Results")];
                
                self.nextResultStr = NSLocalizedString(@"DIAGNOSIS_ACTION_MODERATE_STR",
                                                       "Mild Results");
                
                [self.okButton addTarget:self
                                  action:@selector(showExtraDetails)
                        forControlEvents:UIControlEventTouchUpInside];
                
                break;
            }
            case 2:{
                [self.resultLabel
                 setText:NSLocalizedString(@"DIAGNOSIS_RESULTS_SEVERE_STR", nil)];
                self.nextResultStr = NSLocalizedString(@"DIAGNOSIS_ACTION_SEVERE_STR",
                                                       "Mild Results");
                [self.okButton addTarget:self
                                  action:@selector(showExtraDetails)
                        forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 99:{
                [self.resultLabel
                 setText:NSLocalizedString(@"DIAGNOSIS_RESULTS_MILD_STR", nil)];
                
                self.nextResultStr = NSLocalizedString(@"DIAGNOSIS_ACTION_MILD_STR_NOR",
                                                       "Mild Results");
                
                [self.okButton addTarget:self
                                  action:@selector(showExtraDetails)
                        forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 100:{
                [self.resultLabel
                 setText:NSLocalizedString(@"DIAGNOSIS_RESULTS_Healthy", nil)];
                
                self.nextResultStr = NSLocalizedString(@"DIAGNOSIS_ACTION_Healthy",
                                                       "Mild Results");
                
                [self.okButton addTarget:self
                                  action:@selector(showExtraDetails)
                        forControlEvents:UIControlEventTouchUpInside];
            }
                break;

            default:
                break;
        }
    } else {
        self.resultLabel.hidden = YES;
        CGRect frame = self.titleLabel.frame;
        frame.size.height = 120.f;
        self.titleLabel.frame = frame;
        self.titleLabel.text = self.resultText;
        self.titleLabel.font = [UIFont systemFontOfSize:20.f weight:0.5f];
    }
}

- (void)showMildDetails {
    if (self.currentSession.noOfBadCondition > 0) {
        UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"Menses" bundle:nil];
        
        GLDiagnosisResultsViewController *controller =
        [storyboard instantiateViewControllerWithIdentifier:@"ResultsView"];
        [self.navigationController pushViewController:controller animated:YES];
        controller.buttonText = @"回到主页";
        
//        controller.resultText = NSLocalizedString(@"DIAGNOSIS_ACTION_MILD_STR",
//                                                  "Mild Result Course of Action");
        controller.resultText = self.nextResultStr;
    } else {
        [self showExtraDetails];
    }
}

- (void)showExtraDetails {
    UIStoryboard *storyboard =
    [UIStoryboard storyboardWithName:@"Menses" bundle:nil];
    
    GLDiagnosisResultsViewController *controller =
    [storyboard instantiateViewControllerWithIdentifier:@"ResultsView"];
    [self.navigationController pushViewController:controller animated:YES];
    controller.buttonText = @"回到主页";
    
//    controller.resultText = NSLocalizedString(@"DIAGNOSIS_ACTION_MODERATE_STR",
//                                              "Moderate Result Course of Action");
    controller.resultText = self.nextResultStr;
}

- (void)dismissPage {
//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    delegate.tabBarController.selectedIndex = 2;
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.currentSession.currentScore = 0;
    self.currentSession.noOfBadCondition = 0;
}

@end
