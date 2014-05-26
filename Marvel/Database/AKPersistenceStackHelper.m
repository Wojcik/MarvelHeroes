//
// Created with AppCode
//  Created by Anton Kovalev on 5/24/14.
//  Copyright (c) 2014 Ant Coding. All rights reserved.
//

#import "AKPersistenceStackHelper.h"
#import "NSString+Path.h"
#import <CoreData/CoreData.h>

@interface AKPersistenceStackHelper ()
{
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_storeCoordinator;

    NSManagedObjectContext *_concurrentContext;
}
@end

@implementation AKPersistenceStackHelper

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        [self setupCoreDataStack];
    }
    return _managedObjectContext;
}

+ (instancetype)sharedHelper
{
    static AKPersistenceStackHelper *helper;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        helper = [[self alloc] init];
    });
    return helper;
}


- (void)setupCoreDataStack
{
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];

    NSURL *databasePath = [NSURL fileURLWithPath:[[NSString documentPath]
            stringByAppendingPathComponent:@"Database.sqlite"]];
    _storeCoordinator = [[NSPersistentStoreCoordinator alloc]
            initWithManagedObjectModel:_managedObjectModel];
    NSError *error = nil;
   if (! [_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                    configuration:nil
                                              URL:databasePath
                                          options:nil
                                            error:&error])
   {
       abort();
   }



    _managedObjectContext = [[NSManagedObjectContext alloc]
            initWithConcurrencyType:NSMainQueueConcurrencyType];

    [_managedObjectContext setPersistentStoreCoordinator:_storeCoordinator];
}


- (void)save
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end