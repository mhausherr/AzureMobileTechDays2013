//
//  MSClient+CheckFood.m
//  CheckFoodKeeper
//
//  Created by Mathieu Hausherr on 11/11/12.
//  Copyright (c) 2012 LiveCode. All rights reserved.
//

#import "MSClient+Techdays.h"

@implementation MSClient (Techdays)

- (MSTable*)todoTable
{
    return [self getTable:@"ToDoItem"];
}

- (MSTable*)iosPushIdTable
{
    return [self getTable:@"iOSPushId"];
}

@end