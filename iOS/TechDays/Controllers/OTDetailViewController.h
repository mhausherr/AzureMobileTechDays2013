//
//  OTDetailViewController.h
//  TechDays
//
//  Created by Mathieu Hausherr on 07/02/13.
//  Copyright (c) 2013 Octo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTTodoItem;

@interface OTDetailViewController : UIViewController

@property (strong, nonatomic) OTTodoItem                    *detailItem;

@property (weak, nonatomic) IBOutlet UITextField            *detailDescriptionTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl   *detailStateControl;

- (IBAction)save:(id)sender;

@end
