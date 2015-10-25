//
//  GLQuestionViewController.h
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "Answer.h"

@interface GLQuestionViewController : UIViewController

@property (nonatomic, retain) Question *question;

@property (nonatomic, strong) NSString *questionId;
@property (nonatomic, retain) NSArray *answers; // array of GLAnswers

@end
