//
//  GLUserSession.h
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLUserSession : NSObject

@property (nonatomic, assign) NSInteger currentScore;
@property (nonatomic, assign) NSInteger noOfBadCondition;
@property (nonatomic, assign, getter=isCompleted) BOOL completed;

+sharedManager;
- (NSInteger)userCondition;

@end
