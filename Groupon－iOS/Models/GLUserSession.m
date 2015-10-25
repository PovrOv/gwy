//
//  GLUserSession.m
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "GLUserSession.h"

@implementation GLUserSession

+ (id)sharedManager {
    static GLUserSession *userSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userSession = [[self alloc] init];
    });
    
    return userSession;
}

- (NSInteger)userCondition {
    int retVal = 0;
    
    
    if (self.currentScore < 21) {
        if (self.noOfBadCondition > 0) {
            return 99;
        }
        if (self.currentScore < 15) {
            return 100;
        }
        retVal = 0;
    } else if (self.currentScore < 36) {
        retVal = 1;
    } else {
        retVal = 2;
    }

    return retVal;
}

@end
