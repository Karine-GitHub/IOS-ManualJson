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
    NSLog(@"The current device is : %@", [UIDevice currentDevice].model);
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Dl by Network : %hhd", appDel.isDownloadedByNetwork);
    NSLog(@"Dl by File : %hhd", appDel.isDownloadedByFile);
    
    // Get Application json file
    @try {
        if (appDel.isDownloadedByNetwork || appDel.isDownloadedByFile) {
            NSError *error = [[NSError alloc] init];
            application = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:APPLICATION_FILE options:NSJSONReadingMutableLeaves error:&error];
            if (!application) {
                NSLog(@"An error occured during the Loading of the Application : %@", error);
                // throw exception
                NSException *e = [NSException exceptionWithName:error.localizedDescription reason:error.localizedFailureReason userInfo:error.userInfo];
                @throw e;
            }
        }
        else {
            if (!appDel.isDownloadedByFile) {
                _errorMsg = @"Impossible to download content file. The application will shut down. Sorry for the inconvenience.";
            } else if (!appDel.isDownloadedByNetwork) {
                _errorMsg = @"Impossible to download content on the server. The network connection is too low or off. The application will shut down. Please try later.";
            }
            UIAlertView *alertNoConnection = [[UIAlertView alloc] initWithTitle:@"Application fails" message:_errorMsg delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:nil];
            [alertNoConnection show];
        }
    }
    @catch (NSException *e) {
        _errorMsg = [NSString stringWithFormat:@"An error occured during the Loading of the Application : %@, reason : %@", e.name, e.reason];
        UIAlertView *alertNoConnection = [[UIAlertView alloc] initWithTitle:@"Application fails" message:_errorMsg delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:nil];
        [alertNoConnection show];
    }
    
    for (NSString *s in application.allKeys)
    {
        NSLog(@"%@", s);
    }
    // Get all pages of the application
    if ([application objectForKey:@"Pages"]) {
        allPages = [application objectForKey:@"Pages"];
    }
    
    NSLog(@"All Pages Count = %d", allPages.count);
    if ([application objectForKey:@"Name"]) {
        self.navigationItem.title = [application objectForKey:@"Name"];
    }
    
    // Insert rows in TableView
    if (application) {
        [self insertNewObject];
    }
    
    
    // Select row manually for displaying an home page when device = iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [_menu selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [_menu.delegate tableView:_menu didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
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
        [self.menu insertRowsAtIndexPaths:@[indexPathTable] withRowAnimation:UITableViewRowAnimationAutomatic];
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
/*{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}*/

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
        [self.detailViewController setDetailItem:page];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    page = allPages[indexPath.row];
    [[segue destinationViewController] setDetailItem:page];
}

#pragma mark - Alert View
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // Fermer l'application
        //Home button
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        // Wait while app is going background
        [NSThread sleepForTimeInterval:2.0];
        exit(0);
    }
}

@end
