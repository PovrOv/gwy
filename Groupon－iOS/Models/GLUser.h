//
//  GLUser.h
//  glsmvp
//
//  Created by Michael Nguyen on 2/11/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLUser : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSDate   *birthdate;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *location; // currently just the closest city


@end
