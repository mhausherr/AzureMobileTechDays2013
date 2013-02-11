//
//  OTMasterViewController.h
//  TechDays
//
//  Created by Mathieu Hausherr on 07/02/13.
//  Copyright (c) 2013 Octo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTDetailViewController;

@interface OTMasterViewController : UITableViewController

@property (strong, nonatomic) OTDetailViewController *detailViewController;

@end
