//
// Created with AppCode
//  Created by Anton Kovalev on 5/24/14.
//  Copyright (c) 2014 Ant Coding. All rights reserved.
//

#import "AKResponseMappingProvider.h"
#import "EKObjectMapping.h"
#import "AKResponse.h"
#import "AKPaginator.h"

/*
{
"code": 200,
"status": "Ok",
"etag": "f0fbae65eb2f8f28bdeea0a29be8749a4e67acb3",
"data": {
"offset": 0,
"limit": 20,
"total": 30920,
"count": 20,
"results": []
}
}
*/
@implementation AKResponseMappingProvider
+ (EKObjectMapping *)mappingForResponse
{
    void (^block) (EKObjectMapping *) = ^(EKObjectMapping *mapping)
    {
        [mapping mapKey:@"data.results" toField:@"results"];
        [mapping mapKey:@"code" toField:@"statusCode"];
        [mapping hasOneMapping:[self mappingForPaginator] forKey:@"data" forField:@"paginator"];
    };
    EKObjectMapping *responseMapping = [EKObjectMapping mappingForClass:[AKResponse class]
                                                              withBlock:block];
    return responseMapping;
}

+ (EKObjectMapping *)mappingForPaginator
{
    void (^mappingBlock) (EKObjectMapping *) = ^(EKObjectMapping *mapping) {

        [mapping mapFieldsFromArray:@[@"offset", @"limit", @"total", @"count"]];
    };

    return [EKObjectMapping mappingForClass:[AKPaginator class]
                                  withBlock:mappingBlock];
}

@end