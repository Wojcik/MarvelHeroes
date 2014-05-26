//
// Created by Anton Kovalev on 5/21/14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//


@class AKResponse;

typedef void (^success_block_t)(AKResponse *JSON);
typedef void (^failure_block_t)(NSError *error);

@interface AKNetworkManager : NSObject

@property (nonatomic, strong) NSURLSession *currentSession;
@property(nonatomic, strong) NSURL *baseURL;

+ (instancetype)sharedManager;

- (void)sendRequestWithPath:(NSString *)path params:(NSDictionary *)params
                WithSuccess:(success_block_t)successBlock andFailure:(failure_block_t)failureBlock;

@end