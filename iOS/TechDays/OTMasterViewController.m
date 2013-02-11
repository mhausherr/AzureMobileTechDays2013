//
//  OTMasterViewController.m
//  TechDays
//
//  Created by Mathieu Hausherr on 07/02/13.
//  Copyright (c) 2013 Octo. All rights reserved.
//

#import "OTMasterViewController.h"

#import "OTDetailViewController.h"
#import "OTClient.h"
#import "OTTodoItem.h"

@interface OTMasterViewController ()

@property (nonatomic, strong)  NSArray *items;
@property (nonatomic, strong)  NSArray *itemsDone;

- (void)showLoginController;
- (void)reloadData;
- (void)reloadDoneData;

- (void)configureLogoutButton;
- (void)configureAddButton;
- (void)configureRefreshControl;

- (OTTodoItem *)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)insertNewObject:(id)sender;
- (void)logout:(id)sender;

@end

@implementation OTMasterViewController

/**************************************************************************************************/
#pragma mark - View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"ToDo List";
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureLogoutButton];
    [self configureAddButton];
    [self configureRefreshControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadData];
}

/**************************************************************************************************/
#pragma mark - Configure

- (void)configureLogoutButton
{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout:)];
    self.navigationItem.leftBarButtonItem = addButton;
}

- (void)configureAddButton
{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)configureRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

/**************************************************************************************************/
#pragma mark - Actions

- (void)showLoginController
{
    UIViewController *loginController =[[OTClient sharedClient] loginViewControllerWithProvider:@"facebook" completion:^(MSUser *user, NSError *error) {
        if (error) {
            NSLog(@"Authentication Error: %@", error);
        } else {
            [self reloadData];
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.navigationController presentViewController:loginController animated:NO completion:nil];
}

- (void)reloadData
{
    if([[OTClient sharedClient] currentUser])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.complete == %@",@NO];
        [[[OTClient sharedClient] todoTable] readWhere:predicate completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
            if(error)
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            else
            {
                self.items = [NSMutableArray arrayWithArray:[OTTodoItem arrayFromServerRepresentation:items]];
                [self.tableView reloadData];
                [self reloadDoneData];
            }
        }];
    }
    else{
        [self showLoginController];
    }
}

- (void)reloadDoneData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.complete == %@",@YES];
    [[[OTClient sharedClient] todoTable] readWhere:predicate completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if(error)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else
        {
            self.itemsDone = [NSMutableArray arrayWithArray:[OTTodoItem arrayFromServerRepresentation:items]];
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)insertNewObject:(id)sender
{
    if (!self.detailViewController) {
        self.detailViewController = [[OTDetailViewController alloc] initWithNibName:@"OTDetailViewController" bundle:nil];
    }
    self.detailViewController.detailItem = [[OTTodoItem alloc] init];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

- (void)logout:(id)sender
{
    [[OTClient sharedClient] logout];
    [self.tableView reloadData];
}

/**************************************************************************************************/
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:            
            return self.items.count;
        case 1:
            return self.itemsDone.count;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.items count]?@"To do":nil;
        case 1:
            return [self.itemsDone count]?@"Done":nil;
        default:
            return nil;
    }
}

- (OTTodoItem *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return self.items[indexPath.row];
        case 1:
            return self.itemsDone[indexPath.row];
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    cell.textLabel.text = [[self itemAtIndexPath:indexPath] description];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[OTDetailViewController alloc] initWithNibName:@"OTDetailViewController" bundle:nil];
    }
    self.detailViewController.detailItem = [self itemAtIndexPath:indexPath];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
