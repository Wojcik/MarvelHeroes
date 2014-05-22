//
// Created by Anton Kovalev on 5/22/14.
// Copyright (c) 2014 Anton Kovalev. All rights reserved.
//

#import "AKRequestComposer.h"


@implementation AKRequestComposer
{

}
- (NSString *)composeDictionary:(NSDictionary *)dictionary
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES];
    NSMutableArray *pairsArray = [NSMutableArray array];
    NSLog(@"%@", [dictionary allKeys]);
    for (id key in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]])
    {
        NSLog(@"%@", key);
        NSString *keyString = [[key description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        id value = [dictionary objectForKey:key];
        NSString *valueString = [[value description]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",keyString, valueString];
        [pairsArray addObject:keyValue];
    };
    return [pairsArray componentsJoinedByString:@"&"];
}
@end