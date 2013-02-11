//
//  OTAppDelegate.m
//  TechDays
//
//  Created by Mathieu Hausherr on 07/02/13.
//  Copyright (c) 2013 Octo. All rights reserved.
//

#import "OTAppDelegate.h"

#import "OTMasterViewController.h"
#import "OTClient.h"
#import "OTIOSPushID.h"

@implementation OTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    OTMasterViewController *masterViewController = [[OTMasterViewController alloc] initWithNibName:@"OTMasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    if([[OTClient sharedClient] currentUser])
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* token = [[[[deviceToken description]
                               stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];

    NSString *user = [[OTClient sharedClient] currentUser].userId;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.user == %@", user];
    [[[OTClient sharedClient] iosPushIdTable] readWhere:predicate completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if([items count])
        {
            OTIOSPushID *iosPushID = [[OTIOSPushID arrayFromServerRepresentation:items] objectAtIndex:0];
            iosPushID.deviceToken = token;
            [[[OTClient sharedClient] iosPushIdTable] update:[iosPushID serverRepresentationForUpdate] completion:^(NSDictionary *item, NSError *error) {
                
            }];
        }
        else
        {
            OTIOSPushID *iosPushID = [[OTIOSPushID alloc] init];
            iosPushID.deviceToken = token;
            iosPushID.user = user;
            [[[OTClient sharedClient] iosPushIdTable] insert:[iosPushID serverRepresentation] completion:^(NSDictionary *item, NSError *error) {
                
            }];
        }
    }];
}

@end
