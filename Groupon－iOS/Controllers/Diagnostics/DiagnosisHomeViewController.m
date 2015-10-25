//
//  GLDiagnosisBaseViewController.m
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "DiagnosisHomeViewController.h"

@interface DiagnosisHomeViewController ()

@end

@implementation DiagnosisHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)startDiagnosis:(id)sender {
    UIStoryboard *storyboard = storyboard = [UIStoryboard storyboardWithName:@"Menses" bundle:nil];;

    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"InitialViewController"];

    [self presentViewController:vc animated:YES completion:nil];
}

@end
