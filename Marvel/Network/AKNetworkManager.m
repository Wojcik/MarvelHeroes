//
// Created by Anton Kovalev on 5/21/14.
// Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AKNetworkManager.h"
#import "Constants.h"
#import "AKResponse.h"
#import "NSString+Hashes.h"
#import "AKRequestComposer.h"
#import "AKResponse.h"
#import "EKMapper.h"
#import "AKResponseMappingProvider.h"


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

- (void)sendRequestWithPath:(NSString *)path params:(NSDictionary *)params
                WithSuccess:(success_block_t)successBlock andFailure:(failure_block_t)failureBlock
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timeStampString = [formatter stringFromDate:[NSDate date]];

    NSString *hash = [NSString stringWithFormat:@"%@%@%@", timeStampString, kPrivateAPIKey, kPublicAPIKey].md5;
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithDictionary:@{@"apikey" : kPublicAPIKey,
            @"ts" : timeStampString,
            @"hash" : hash}];
    [queryParams addEntriesFromDictionary:params];
    AKRequestComposer *composer = [[AKRequestComposer alloc] init];
    NSString *composedParams = [composer composeDictionary:queryParams];
    NSString *requestString = [path stringByAppendingFormat:@"?%@", composedParams] ;
    NSURL *charUrl = [NSURL URLWithString:requestString relativeToURL:self.baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:charUrl];
    NSString *url = [request.URL absoluteString];
    NSLog(@"url %@", url);
    NSURLSessionDataTask *dataTask = [self.currentSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:nil error:&jsonError];
        if (!jsonError)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                AKResponse *responseObject = [EKMapper objectFromExternalRepresentation:json
                                                                            withMapping:[AKResponseMappingProvider mappingForResponse]];

                if ([responseObject.statusCode intValue] != 200)
                {
                    NSDictionary *errorInfo = @{
                            NSLocalizedDescriptionKey        : @"Request failed",
                            NSLocalizedFailureReasonErrorKey : @"Use debug. Not completed yet"
                    };
                    NSError *apiError = [NSError errorWithDomain:@"MarvelApiError"
                                                            code:10001000
                                                        userInfo:errorInfo];
                    failureBlock(apiError);
                }
                else
                {
                    successBlock(responseObject);
                }
            });


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