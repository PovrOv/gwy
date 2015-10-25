//
//  GLStartDiagnosisViewController.m
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "GLNotNormalResultViewController.h"

#import <CoreData/CoreData.h>
#import "GLQuestionViewController.h"
#import "GLApplicationManager.h"
#import "GLUserSession.h"

@interface GLNotNormalResultViewController ()
@end

@implementation GLNotNormalResultViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"诊断结果";
  self.resultLabel.text =
      NSLocalizedString(@"START_DIAGNOSIS_MESSAGE1", "Main Message");
  self.resultSubLabel.text =
      NSLocalizedString(@"START_DIAGNOSIS_MESSAGE2", "Sub message");
}

#pragma mark - Navigation

- (IBAction)loadQuestionController:(id)sender {
  GLUserSession *currentSession = [GLUserSession sharedManager];
  currentSession.currentScore = 0;
  [self performSegueWithIdentifier:@"MoreQuestions" sender:self];
}

// In a storyboard-based application, you will often want to do a little
// preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if ([[segue identifier] isEqualToString:@"MoreQuestions"]) {
    GLQuestionViewController *controller =
        (GLQuestionViewController *)[segue destinationViewController];

    NSString *entityName = NSStringFromClass([Question class]);
    NSFetchRequest *allQuestionsRequest =
        [NSFetchRequest fetchRequestWithEntityName:entityName];
    [allQuestionsRequest
        setPredicate:[NSPredicate predicateWithFormat:@"SELF.question_id = %@",
                                                      @"QUESTION_001"]];
    GLApplicationManager *mgr = [GLApplicationManager sharedManager];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
    moc.persistentStoreCoordinator =
        mgr.managedObjectContext.persistentStoreCoordinator;
    NSError *error = nil;

    NSArray *matches =
        [moc executeFetchRequest:allQuestionsRequest error:&error];

    Question *question = [matches firstObject];
    NSFetchRequest *answersForQuestion = [[NSFetchRequest alloc]
        initWithEntityName:NSStringFromClass([Answer class])];
    [answersForQuestion
        setPredicate:[NSPredicate
                         predicateWithFormat:@"SELF.parent_question = %@",
                                             question]];
    NSSortDescriptor *sortDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"answer_id" ascending:YES];
    [answersForQuestion setSortDescriptors:@[ sortDescriptor ]];
    NSArray *answers =
        [moc executeFetchRequest:answersForQuestion error:&error];

    NSMutableArray *answerDicts = [@[] mutableCopy];
    for (Answer *item in answers) {
      [answerDicts addObject:@{
        @"answer_token" : item.answer_token,
        @"answer_id:" : item.answer_id,
        @"answer_value" : item.answer_value,
        @"severe" : item.severe,
        @"related_question" : item.related_question.question_id
      }];
    }

    controller.answers = [answerDicts copy];
    controller.questionId = question.question_id;
  }
}

@end
