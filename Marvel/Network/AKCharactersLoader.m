//
// Created by Anton Kovalev on 5/21/14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AKCharactersLoader.h"
#import "AKNetworkManager.h"


@implementation AKCharactersLoader {

}

- (void)loadCharacterWithId:(NSString *)characterId andCompletion:(void (^)(id character))completion {
    NSParameterAssert(characterId);
    NSParameterAssert(completion);
    NSString *encoded = [characterId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"characters" : encoded};
    void (^successBlock)(id) = ^(id JSON) {
        completion(JSON);
    };
    void (^failureBlock)(NSError *) = ^(NSError *error) {
        completion(nil);
    };
    [[AKNetworkManager sharedManager] sendRequestWithParams:params
                                                WithSuccess:successBlock
                                                 andFailure:failureBlock];
}

@end