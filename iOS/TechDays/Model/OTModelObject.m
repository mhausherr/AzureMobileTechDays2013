//
//  CFModelObject.m
//  CheckFoodKeeper
//
//  Created by Mathieu Hausherr on 11/11/12.
//  Copyright (c) 2012 LiveCode. All rights reserved.
//

#import "OTModelObject.h"

@implementation OTModelObject

@synthesize id;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (NSArray *)arrayFromServerRepresentation:(NSArray *)serverRepresentations
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *serverRepresentation in serverRepresentations) {
        id object = [[self alloc] init];
        [object setValuesForKeysWithDictionary:serverRepresentation];
        [array addObject:object];
    }
    return array;
}

- (NSArray *)keys
{
    return @[];
}

- (NSDictionary *)serverRepresentation
{
    return [self dictionaryWithValuesForKeys:[self keys]];
}

- (NSDictionary *)serverRepresentationForUpdate
{
    NSArray *keys = [[self keys] arrayByAddingObject:@"id"];
    return [self dictionaryWithValuesForKeys:keys];
}

@end
