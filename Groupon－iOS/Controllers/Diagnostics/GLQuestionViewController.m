//
//  GLQuestionViewController.m
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "GLQuestionViewController.h"
#import "GLApplicationManager.h"
#import "GLUserSession.h"

#import <CoreData/CoreData.h>
#import "GLDiagnosisResultsViewController.h"

@interface GLQuestionViewController () <
UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,
NSFetchedResultsControllerDelegate>

@property(strong, nonatomic)
NSFetchedResultsController *fetchedResultsController;
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic) GLUserSession *currentSession;
@property(strong, nonatomic) NSString *subjectId;
@property(weak, nonatomic) IBOutlet UILabel *questionLabel;
@property(weak, nonatomic) IBOutlet UITableView *answerTableView;
@property(strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation GLQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentSession = [GLUserSession sharedManager];
    
    self.questionLabel.text = NSLocalizedString(self.questionId, nil);
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    self.managedObjectContext.persistentStoreCoordinator = [[[GLApplicationManager
                                                              sharedManager] managedObjectContext] persistentStoreCoordinator];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = [segue identifier];
    
    if ([segueId isEqualToString:@"show"]) {
        // grab the first question and related answers
        NSError *error = nil;
        
        NSString *entityName = NSStringFromClass([Question class]);
        NSFetchRequest *allQuestionsRequest =
        [NSFetchRequest fetchRequestWithEntityName:entityName];
        [allQuestionsRequest
         setPredicate:[NSPredicate predicateWithFormat:@"SELF.subject_id = %@",
                       self.subjectId]];
        
        NSArray *matches =
        [self.managedObjectContext executeFetchRequest:allQuestionsRequest
                                                 error:&error];
        
        GLQuestionViewController *controller =
        (GLQuestionViewController *)[segue destinationViewController];
        Question *setQuestion = [matches firstObject];
        [controller setQuestion:setQuestion];
        
        NSFetchRequest *answersForQuestion = [[NSFetchRequest alloc]
                                              initWithEntityName:NSStringFromClass([Answer class])];
        [answersForQuestion
         setPredicate:[NSPredicate
                       predicateWithFormat:@"SELF.parent_question  = %@",
                       setQuestion]];
        
        NSArray *answers =
        [self.managedObjectContext executeFetchRequest:answersForQuestion
                                                 error:&error];
        
        [controller setAnswers:answers];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"AnswersCell"
                                    forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *def = self.answers[indexPath.row];
    NSString *displayInfo =
    NSLocalizedString(def[@"answer_token"], @"Answer text");
    cell.textLabel.text = displayInfo;
}

/*!
 User tapped on an answer.  record score and push the next set of results
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndexPath ) {
        UITableViewCell *preCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        preCell.imageView.image = [UIImage imageNamed:@"radio_button"];
        NSDictionary *prevAnswer = [self.answers objectAtIndex:self.selectedIndexPath.row];
        self.currentSession.currentScore -= [prevAnswer[@"answer_value"] intValue];
        if ([prevAnswer[@"severe"] isEqualToNumber:@1]) {
            self.currentSession.noOfBadCondition -= 1;
        }
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"radio_button_selected"];
    
    NSDictionary *selectedAnswer = [self.answers objectAtIndex:indexPath.row];
    self.selectedIndexPath = indexPath;
    
    self.currentSession.currentScore += [selectedAnswer[@"answer_value"] intValue];
    if ([selectedAnswer[@"severe"] isEqualToNumber:@1]) {
        self.currentSession.noOfBadCondition += 1;
    }
    
    UIStoryboard *storyboard =
    [UIStoryboard storyboardWithName:@"Menses" bundle:nil];
    // now that we did the addition push for the next question
    if ([selectedAnswer[@"related_question"] length]) {
        GLQuestionViewController *controller =
        [storyboard instantiateViewControllerWithIdentifier:@"QuestionPage"];
        
        NSString *entityName = NSStringFromClass([Question class]);
        NSFetchRequest *allQuestionsRequest =
        [NSFetchRequest fetchRequestWithEntityName:entityName];
        [allQuestionsRequest
         setPredicate:[NSPredicate predicateWithFormat:
                       @"SELF.question_id = %@",
                       selectedAnswer[@"related_question"]]];
        NSError *error = nil;
        NSArray *matches =
        [self.managedObjectContext executeFetchRequest:allQuestionsRequest
                                                 error:&error];
        Question *setQuestion = [matches firstObject];
        
        NSFetchRequest *answersForQuestion = [[NSFetchRequest alloc]
                                              initWithEntityName:NSStringFromClass([Answer class])];
        [answersForQuestion
         setPredicate:[NSPredicate
                       predicateWithFormat:@"SELF.parent_question = %@",
                       setQuestion]];
        NSSortDescriptor *sortDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"answer_id" ascending:YES];
        [answersForQuestion setSortDescriptors:@[ sortDescriptor ]];
        NSArray *answers =
        [self.managedObjectContext executeFetchRequest:answersForQuestion
                                                 error:&error];
        
        [self.navigationController pushViewController:controller animated:YES];
        
        NSMutableArray *answerDicts = [@[] mutableCopy];
        for (Answer *item in answers) {
            [answerDicts addObject:@{
                                     @"answer_token" : item.answer_token,
                                     @"answer_id:" : item.answer_id,
                                     @"answer_value" : item.answer_value,
                                     @"severe" : item.severe,
                                     @"related_question" : item.related_question.question_id ?: @""
                                     }];
        }
        
        controller.answers = [answerDicts copy];
        controller.questionId = setQuestion.question_id;
        
    } else {
        // push the results page
        [self.currentSession setCompleted:YES];
        GLDiagnosisResultsViewController *vc =
        [storyboard instantiateViewControllerWithIdentifier:@"ResultsView"];
        
        vc.condition = [self.currentSession userCondition];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
