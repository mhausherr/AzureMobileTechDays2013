//
//  OTTodoItem.h
//  TechDays
//
//  Created by Mathieu Hausherr on 07/02/13.
//  Copyright (c) 2013 Octo. All rights reserved.
//

#import "OTModelObject.h"

@interface OTTodoItem : OTModelObject

@property(nonatomic, strong) NSString   *text;
@property(nonatomic) NSNumber           *complete;

@end
