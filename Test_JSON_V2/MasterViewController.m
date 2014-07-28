//
//  MasterViewController.m
//  Test_JSON_V2
//
//  Created by admin on 7/10/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MasterViewController.h"

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableDictionary *application;
    NSMutableArray *allPages;
    NSMutableDictionary *page;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Get Application json file
    
    @try {
        NSError *error = [[NSError alloc] init];
        application = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:APPLICATION_FILE options:NSJSONReadingMutableLeaves error:&error];
        if (!application) {
            NSLog(@"An error occured during the Loading of the Application : %@", error);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An error occured during the Loading of the Application : %@, reason : %@", exception.name, exception.reason);
    }

    for (NSString *s in application.allKeys)
    {
        NSLog(@"%@", s);
    }
    // Get all pages of the application
    // Objective-C interprets the string <null> as a NSNull object. Exception is throw when it is used in a method
    if ([application objectForKey:@"Pages"]) {
        allPages = [application objectForKey:@"Pages"];
    }
    
    NSLog(@"All Pages Count = %d", allPages.count);
    if ([application objectForKey:@"Name"]) {
        self.navigationItem.title = [application objectForKey:@"Name"];
    }
    
    
    // Insert rows in TableView
    [self insertNewObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject
{
    // Insert row for each page in the application
    for (NSInteger nbpage=0; nbpage < allPages.count; ++nbpage) {
        NSIndexPath *indexPathTable = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPathTable] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allPages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    page = allPages[indexPath.row];
    
    if (![page objectForKey:@"Name"]) {
        cell.textLabel.text = @"No Name property";
    } else {
        cell.textLabel.text = [[page objectForKey:@"Name"] description];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        page = allPages[indexPath.row];
        self.detailViewController.detailItem = page;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    page = allPages[indexPath.row];
    [[segue destinationViewController] setDetailItem:page];
}

@end
