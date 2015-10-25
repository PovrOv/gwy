 //
//  GLMensesOverview.m
//  GoldenLeaf
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "GLDiagnosisStep1ViewController.h"
#import "GLDiagnosisSept2ViewController.h"
#import "GLUserSession.h"
#import "GLQuestionViewController.h"
#import "GLApplicationManager.h"


@interface GLDiagnosisStep1ViewController ()

@property(nonatomic, weak) IBOutlet UILabel *questionLabel;
@property(nonatomic, weak) IBOutlet UIButton *yesButton, *noButton;
@property(nonatomic, assign) NSInteger age;

@end

@implementation GLDiagnosisStep1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem = item;
    NSDate *today = [NSDate date];
    
    NSDate *birthday =
    [[NSUserDefaults standardUserDefaults] valueForKey:@"BIRTHDAY"];
    self.age = [self yearsFromStartDate:birthday toEndDate:today];
    
    // Do any additional setup after loading the view.
//    [self.yesButton setTitle:NSLocalizedString(@"YES", "YES")
//                    forState:UIControlStateNormal];
//    [self.noButton setTitle:NSLocalizedString(@"NO", "NO")
//                   forState:UIControlStateNormal];
//    self.questionLabel.text = NSLocalizedString(@"QUESTION_MENSES_001", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    GLUserSession *session = [GLUserSession sharedManager];
    if (session.completed) {
        [self.noButton setImage:[UIImage imageNamed:@"radio_button"] forState:UIControlStateNormal];
        [self.yesButton setImage:[UIImage imageNamed:@"radio_button"] forState:UIControlStateNormal];
        session.completed = NO;
    }
}
- (IBAction)selectYes:(id)sender {
    [self.noButton setImage:[UIImage imageNamed:@"radio_button"] forState:UIControlStateNormal];
    [self.yesButton setImage:[UIImage imageNamed:@"radio_button_selected"] forState:UIControlStateNormal];
    // If age > 40, not normal
    if (self.age >= 40) {
        UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"Menses" bundle:nil];
        UIViewController *vc = [storyboard
                                instantiateViewControllerWithIdentifier:@"ConditionNotNormal"];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self performSegueWithIdentifier:@"STEP2_PAGE" sender:self];
    }
}

- (IBAction)selectNo:(id)sender {
    [self.noButton setImage:[UIImage imageNamed:@"radio_button_selected"] forState:UIControlStateNormal];
    [self.yesButton setImage:[UIImage imageNamed:@"radio_button"] forState:UIControlStateNormal];
    
    if (self.age >= 40) {
        [self performSegueWithIdentifier:@"STEP2_PAGE" sender:self];
    } else {
        [self performSegueWithIdentifier:@"NORMAL_RESULT" sender:self];
    }
}

- (NSInteger)yearsFromStartDate:(NSDate *)startDate
                      toEndDate:(NSDate *)endDate {
    if (startDate && endDate) {
        NSDateComponents *components =
        [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                        fromDate:startDate
                                          toDate:endDate
                                         options:0];
        
        NSInteger years = [components year];
        return years;
    }
    
    return 0;
}
- (void)returnBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"juejing"]) {
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
