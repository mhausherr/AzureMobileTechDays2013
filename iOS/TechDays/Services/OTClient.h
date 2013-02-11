//
//  CFClient.h
//  CheckFoodKeeper
//
//  Created by Mathieu Hausherr on 11/11/12.
//  Copyright (c) 2012 LiveCode. All rights reserved.
//

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "MSClient+Techdays.h"

@interface OTClient : MSClient
+ (id)sharedClient;
@end