//
//  OTIOSPushID.h
//  TechDays
//
//  Created by Mathieu Hausherr on 11/02/13.
//  Copyright (c) 2013 Octo. All rights reserved.
//

#import "OTModelObject.h"

@interface OTIOSPushID : OTModelObject

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *user;

@end
