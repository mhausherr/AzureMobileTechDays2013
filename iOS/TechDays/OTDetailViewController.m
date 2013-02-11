//
//  OTDetailViewController.m
//  TechDays
//
//  Created by Mathieu Hausherr on 07/02/13.
//  Copyright (c) 2013 Octo. All rights reserved.
//

#import "OTDetailViewController.h"
#import "OTTodoItem.h"
#import "OTClient.h"

@interface OTDetailViewController ()
- (void)configureView;
@end

@implementation OTDetailViewController

/**************************************************************************************************/
#pragma mark - View Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}


- (void)configureView
{
    if (self.detailItem) {
        self.detailDescriptionTextField.text = self.detailItem.text;
        self.detailStateControl.selectedSegmentIndex = self.detailItem.complete;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

/**************************************************************************************************/
#pragma mark - Setters

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;        
        [self configureView];
    }
}

/**************************************************************************************************/
#pragma mark - Actions
							
- (IBAction)save:(id)sender
{
    self.detailItem.text = self.detailDescriptionTextField.text;
    self.detailItem.complete = [NSNumber numberWithInt:self.detailStateControl.selectedSegmentIndex];
    if(self.detailItem.id)
    {
        [[[OTClient sharedClient] todoTable] update:[self.detailItem serverRepresentationForUpdate] completion:^(NSDictionary *item, NSError *error) {
            if(error)
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else
    {
        [[[OTClient sharedClient] todoTable] insert:[self.detailItem serverRepresentation] completion:^(NSDictionary *item, NSError *error) {
            if(error)
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

@end
