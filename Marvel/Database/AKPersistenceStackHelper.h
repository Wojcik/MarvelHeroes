//
//  Created by Anton Kovalev on 5/24/14.
//  Copyright (c) 2014 Ant Coding. All rights reserved.
//

@interface AKPersistenceStackHelper : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+(instancetype)sharedHelper;

- (void)save;
@end