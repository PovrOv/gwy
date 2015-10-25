//
//  GLApplicationManager.m
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "GLApplicationManager.h"
#import "Question.h"
#import "Answer.h"
#import "Subject.h"

@implementation GLApplicationManager

+ (id)sharedManager {
    static GLApplicationManager *sharedSomeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSomeManager = [[self alloc] init];
    });

    return sharedSomeManager;
}

-(instancetype)init {
    self = [super init];
    if (self != nil) {
        NSString *defaultQuestionsFile = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"dat"];
        NSString *defaultAnswersFile = [[NSBundle mainBundle] pathForResource:@"answers" ofType:@"dat"];
        NSString *defaultSubjectFile = [[NSBundle mainBundle] pathForResource:@"subjects" ofType:@"dat"];

        [self importDataFromURL:[NSURL fileURLWithPath:defaultQuestionsFile] forType:QUESTION_DATA];
        [self importDataFromURL:[NSURL fileURLWithPath:defaultSubjectFile] forType:CATEGORY_DATA];
        [self importDataFromURL:[NSURL fileURLWithPath:defaultAnswersFile] forType:ANSWER_DATA];
    }

    return self;
}


/*!
 Get all questions from database
 */
- (NSMutableDictionary *)getAllQuestions {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Question class])];

    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSMutableDictionary *questions = [[NSMutableDictionary alloc] init];

    for (Question *question in results ) {
        [questions setObject:question forKey:question.question_id];
    }

    return questions;
}

/*!
    given a valid URL, import data from data file into DB.
 */
-(void)importDataFromURL:(NSURL *)url forType:(NSInteger)dataType {
    NSFileManager *fm = [NSFileManager defaultManager];

    if (![fm fileExistsAtPath: [url path]]) {
        return;
    }

    // open the file for reading
    NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
    NSString* fileContents = [NSString stringWithContentsOfFile:[url path]
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];

    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineCharSet];
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSError *error = nil;

    @autoreleasepool {
        NSString *QuestionEntityName = NSStringFromClass([Question class]);
        NSString *AnswerEntityName = NSStringFromClass([Answer class]);
        NSString *SubjectEntityName = NSStringFromClass([Subject class]);

        int index = 0;
        // do a fetch of all the questions
        NSMutableDictionary *questions = [self getAllQuestions];

        for (NSString *line in lines) {
            NSArray *components = [line componentsSeparatedByString:@"|"];
            if ((index == 0) || ([components count] < 2)) {
                index++;
                continue;
            }
            index++;

            switch (dataType) {
                    //QUESTION_ID|ANSWER_ID|ANSWER_KEY|RELATED_QUESTION|SCORE_VALUE|FLAG|N
                case QUESTION_DATA: {
                    NSString *questionId = [components objectAtIndex:1];
                    // create a Question object and save it to the database
                    Question *questionEntity = [self findOrCreateEntity:QuestionEntityName withId:questionId andFieldName:@"question_id"];

                    questionEntity.subject_id = [components objectAtIndex:0];
                    questionEntity.question_id = questionId;
                    questionEntity.question_token = [components objectAtIndex:2];
                    break;
                }
                    // QUESTION_ID|ANSWER_ID|ANSWER_KEY|RELATED_QUESTION|SCORE_VALUE|FLAG|N
                case ANSWER_DATA: {

                    NSString *answerId = [components objectAtIndex:1];
                    Answer *answerEntity = [self findOrCreateEntity:AnswerEntityName withId:answerId andFieldName:@"answer_id"];
                    NSString *parentQuestionId = [components firstObject];
                    NSString *relatedQuestionId = [components objectAtIndex: 3];

                    Question *parentQuestion = [questions objectForKey: parentQuestionId];
                    Question *relatedQuestion = [questions objectForKey: relatedQuestionId];

                    answerEntity.answer_id = answerId;
                    answerEntity.answer_token = [components objectAtIndex:2];
                    answerEntity.answer_value = [components objectAtIndex:4];
                    [answerEntity setRelated_question: relatedQuestion];
                    [answerEntity setParent_question:parentQuestion];

                    BOOL isSevere = [[components lastObject] isEqualToString:@"Y"];
                    answerEntity.severe = [NSNumber numberWithBool:isSevere];

                    break;
                }
                case CATEGORY_DATA: {
                    NSString *subjectId = [components firstObject];
                    Subject *subjectEntity = [self findOrCreateEntity:SubjectEntityName withId:subjectId andFieldName:@"subject_id"];

                    subjectEntity.subject_id = subjectId;
                    subjectEntity.subject = [components lastObject];
                    break;
                }
                default:
                    break;
            }

            if (((index % 100) == 0) &&![moc save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                error = nil;
            }
        }

        if (![moc save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            error = nil;
        }

    }

}


- (id)findOrCreateEntity: (NSString *)entityName withId: (NSString *)objectId andFieldName: (NSString *)propertyName {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
    moc.persistentStoreCoordinator = [self persistentStoreCoordinator];

    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext: moc];
    request.predicate = [NSPredicate predicateWithFormat:@"SELF.%@ == %@", propertyName, objectId];

    NSError *error = nil;
    id result = [[self.managedObjectContext executeFetchRequest:request error:&error] firstObject];

    if (result == nil) {
        result = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                           inManagedObjectContext: self.managedObjectContext];
    }

    return result;


}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.hlcam.sample.URLInspector" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }

    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    // Create the coordinator and store

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Diagnosis.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // delete the current model and recreate it.
        error = nil;

        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

            abort();
        }
    }

    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
