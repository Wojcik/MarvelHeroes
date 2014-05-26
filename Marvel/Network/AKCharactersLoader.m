//
// Created by Anton Kovalev on 5/21/14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AKCharactersLoader.h"
#import "AKNetworkManager.h"
#import "AKCharacter.h"
#import "EKObjectMapping.h"
#import "EKManagedObjectMapping.h"
#import "EKManagedObjectMapper.h"
#import "AKMappingProvider.h"
#import "AKResponse.h"


@implementation AKCharactersLoader {

}

- (void)loadCharacterWithId:(NSString *)characterId andCompletion:(void (^)(AKCharacter *character))completion {
    NSParameterAssert(characterId);
    NSParameterAssert(completion);
    void (^successBlock)(id) = ^(AKResponse *response) {
        NSDictionary *characterRepresentation =  response.results.lastObject;
        AKCharacter *character = [EKManagedObjectMapper objectFromExternalRepresentation:characterRepresentation
                                                                             withMapping:[AKMappingProvider characterMapping]
                                                                  inManagedObjectContext:self.context];
        completion(character);
    };
    void (^failureBlock)(NSError *) = ^(NSError *error) {
        completion(nil);
    };
    [[AKNetworkManager sharedManager]
            sendRequestWithPath:[NSString stringWithFormat:@"characters/%@", characterId] params:nil
                    WithSuccess:successBlock andFailure:failureBlock];
}

+ (instancetype)loaderWithContext:(NSManagedObjectContext *)context
{
    AKCharactersLoader *loader = [AKCharactersLoader new];
    loader.context = context;
    return loader;
}

@end