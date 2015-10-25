//
//  Answer.h
//  GoldenLeaf
//
//  Created by Sissi Chen  on 3/21/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Answer : NSManagedObject

@property (nonatomic, retain) NSString * answer_id;
@property (nonatomic, retain) NSString * answer_token;
@property (nonatomic, retain) NSString * answer_value;
@property (nonatomic, retain) NSNumber * severe;
@property (nonatomic, retain) Question *parent_question;
@property (nonatomic, retain) Question *related_question;

@end
