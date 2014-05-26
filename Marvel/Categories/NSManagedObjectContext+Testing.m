//
// Created with AppCode
//  Created by Anton Kovalev on 5/25/14.
//  Copyright (c) 2014 Ant Coding. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+Testing.h"

@implementation NSManagedObjectContext (Testing)
+ (instancetype)tetsInMemoryStorageError:(NSError **)error
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc]
            initWithManagedObjectModel:model];
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType
                              configuration:nil URL:nil
                                    options:nil error:error];

    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]
            initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setPersistentStoreCoordinator:coordinator];
    return context;
}

@end