//
//  Created by Anton Kovalev on 5/24/14.
//  Copyright (c) 2014 Ant Coding. All rights reserved.
//

@interface AKPaginator : NSObject

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger count;

@end