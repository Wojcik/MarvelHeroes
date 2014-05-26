//
// Created by Anton Kovalev on 5/21/14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

@class AKCharacter;
@class NSManagedObjectContext;

@interface AKCharactersLoader : NSObject

@property (nonatomic, weak) NSManagedObjectContext *context;

- (void)loadCharacterWithId:(NSString *)characterId andCompletion:(void (^)(AKCharacter *character))completion;

+ (instancetype)loaderWithContext:(NSManagedObjectContext *)context;
@end