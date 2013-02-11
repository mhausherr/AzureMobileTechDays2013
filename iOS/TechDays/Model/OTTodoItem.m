//
//  OTTodoItem.m
//  TechDays
//
//  Created by Mathieu Hausherr on 07/02/13.
//  Copyright (c) 2013 Octo. All rights reserved.
//

#import "OTTodoItem.h"

@implementation OTTodoItem

- (NSString *)description
{
    return self.text;
}

- (NSArray *)keys
{
    return @[@"text",@"complete"];
}

@end
