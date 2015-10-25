//
//  Subject.h
//  GoldenLeaf
//
//  Created by Sissi Chen  on 3/21/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * subject_id;
@property (nonatomic, retain) NSSet *related_questions;
@end

@interface Subject (CoreDataGeneratedAccessors)

- (void)addRelated_questionsObject:(Question *)value;
- (void)removeRelated_questionsObject:(Question *)value;
- (void)addRelated_questions:(NSSet *)values;
- (void)removeRelated_questions:(NSSet *)values;

@end
