//
//  GLDiagnosisResulsViewController.h
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLDiagnosisResultsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *okButton;
@property (nonatomic, weak) IBOutlet UILabel *resultLabel;
@property (nonatomic, assign) NSInteger condition;
@property (nonatomic, strong) NSString *resultText;
@property (nonatomic, strong) NSString *buttonText;

@end
