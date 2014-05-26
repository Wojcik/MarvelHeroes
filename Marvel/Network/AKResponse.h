//
//  Created by Anton Kovalev on 5/24/14.
//  Copyright (c) 2014 Ant Coding. All rights reserved.
//

@class AKPaginator;

@interface AKResponse : NSObject

@property (nonatomic, strong) NSNumber *statusCode;
@property (nonatomic, strong) AKPaginator *paginator;
@property (nonatomic, strong) NSArray *results;


@end