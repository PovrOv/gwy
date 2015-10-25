//
//  GLStartDiagnosisViewController.h
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLNotNormalResultViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton       *submitButton;
@property (nonatomic, weak) IBOutlet UIImageView    *resultImage;
@property (nonatomic, weak) IBOutlet UILabel        *resultLabel;
//@property (nonatomic, weak) IBOutlet UITextField        *resultSubLabel;

@property (weak, nonatomic) IBOutlet UITextView *resultSubLabel;


@end
