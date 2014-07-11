//
//  MasterViewController.m
//  Test_JSON_V2
//
//  Created by admin on 7/10/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *JSONfile;
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
    
    // Read Json file
    NSError *error = [[NSError alloc] init];
    
#pragma Network File
    // Read Json file in network
    //NSURL *url = [NSURL URLWithString:@"http://localhost:1130/api"];
    //NSData *fileByWeb = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    //JSONfile = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:fileByWeb options:NSJSONReadingMutableLeaves error:&error];
    
#pragma Local File
    // Read Json file in local
    NSFileManager *fm;
    fm = [NSFileManager defaultManager];
    NSString *mydirectory = @"/Users/Karine/Projects/Test_Json/";
    
    [fm changeCurrentDirectoryPath:mydirectory];
    // Get its content
    NSData *file = [fm contentsAtPath:[NSString stringWithFormat:@"%@%@", mydirectory, @"APIapplication.json"]];
    
    JSONfile = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:file options:NSJSONReadingMutableLeaves error:&error];

#pragma Manual Parsing of Json File
    // Keep only the first application
    application = JSONfile[0];
    for (NSString *s in application.allKeys)
    {
        NSLog(@"%@", s);
    }
    // Get all pages of the application
    allPages = [application objectForKey:@"Pages"];
    NSLog(@"%d", allPages.count);
    self.navigationItem.title = [application objectForKey:@"Name"];
    
    // Insert rows in TableView
    [self insertNewObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject//:(id)sender
{
    if (!page) {
        page = [[NSMutableDictionary alloc] init];
    }
    for (NSInteger nbpage=0; nbpage<((allPages.count)); ++nbpage) {
        NSLog(@"%d", nbpage);

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

    //NSDate *object = _objects[indexPath.row];
    //cell.textLabel.text = [object description];
    page = allPages[indexPath.row];
    NSString *txt = [page objectForKey:@"Name"];
    cell.textLabel.text = [txt description];

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
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        page = allPages[indexPath.row];
        [[segue destinationViewController] setDetailItem:page];
    }
}

@end
