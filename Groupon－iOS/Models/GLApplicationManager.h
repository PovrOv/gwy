//
//  GLApplicationManager.h
//  glsmvp
//
//  Created by Michael Nguyen on 2/24/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static const NSInteger QUESTION_DATA = 1;
static const NSInteger ANSWER_DATA = 2;
static const NSInteger CATEGORY_DATA = 3;

@interface GLApplicationManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+sharedManager;

-(void)importDataFromURL: (NSURL *)url forType: (NSInteger )dataType;
-(void)saveContext;
-(NSURL *)applicationDocumentsDirectory;

@end
