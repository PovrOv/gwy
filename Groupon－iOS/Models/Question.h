//
//  Question.h
//  GoldenLeaf
//
//  Created by Sissi Chen  on 3/21/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answer, Subject;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSString * question_id;
@property (nonatomic, retain) NSString * question_token;
@property (nonatomic, retain) NSString * subject_id;
@property (nonatomic, retain) NSSet *answers;
@property (nonatomic, retain) NSSet *parent_subject;
@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(Answer *)value;
- (void)removeAnswersObject:(Answer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

- (void)addParent_subjectObject:(Subject *)value;
- (void)removeParent_subjectObject:(Subject *)value;
- (void)addParent_subject:(NSSet *)values;
- (void)removeParent_subject:(NSSet *)values;

@end
