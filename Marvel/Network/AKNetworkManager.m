//
// Created by Anton Kovalev on 5/21/14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AKNetworkManager.h"
#import "Constants.h"
#import "NSString+Hashes.h"


@interface AKNetworkManager ()


@end

@implementation AKNetworkManager

+ (instancetype)sharedManager {
    static AKNetworkManager *manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[self alloc] init];
    });
    return  manager;
}

- (void)sendRequestWithParams:(NSDictionary *)params WithSuccess:(success_block_t)successBlock andFailure:(failure_block_t)failureBlock
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timeStampString = [formatter stringFromDate:[NSDate date]];

    NSString *hash = [NSString stringWithFormat:@"%@%@%@", timeStampString, kPrivateAPIKey, kPublicAPIKey].md5;
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithDictionary:@{@"apikey" : kPublicAPIKey,
            @"ts" : timeStampString,
            @"hash" : hash}];
    [queryParams addEntriesFromDictionary:params];
    NSString *requestString = [NSString stringWithFormat:@"%@?%@", params, kPublicAPIKey];
    NSURL *charUrl = [NSURL URLWithString:requestString relativeToURL:self.baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:charUrl];
    NSString *url = [request.URL absoluteString];
    NSLog(@"url %@", url);
    NSURLSessionDataTask *dataTask = [self.currentSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:nil error:&jsonError];
        if (!jsonError)
        {
            NSLog(@"%@", json);
        }
    }];
    [dataTask resume];
}


- (id)init
{
    self = [super init];
    if (self)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
                kKeyForPublicAPIKey : kPublicAPIKey
        };
        self.currentSession = [NSURLSession sessionWithConfiguration:configuration];
        self.baseURL = [NSURL URLWithString:kBaseURL];
    }

    return self;
}


@end