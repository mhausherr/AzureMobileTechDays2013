//
//  CFClient.m
//  CheckFoodKeeper
//
//  Created by Mathieu Hausherr on 11/11/12.
//  Copyright (c) 2012 LiveCode. All rights reserved.
//

#import "OTClient.h"

@implementation OTClient

__strong static id _sharedClient = nil;

+ (id)sharedClient
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedClient = [MSClient clientWithApplicationURLString:@"<You App URL>"
                                              withApplicationKey:@"<Your App Key"];
    });
    return _sharedClient;
}

@end