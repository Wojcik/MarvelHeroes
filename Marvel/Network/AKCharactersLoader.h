//
// Created by Anton Kovalev on 5/21/14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

@interface AKCharactersLoader : NSObject

- (void)loadCharacterWithId:(NSString *)characterId andCompletion:(void (^)(id character))completion;
@end