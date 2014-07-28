//
//  DetailViewController.m
//  Test_JSON_V2
//
//  Created by admin on 7/10/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        // Get Page's Dependencies
        /*
        if ([self.detailItem objectForKey:@"Dependencies"]) {
            self.pageDependencies = [self.detailItem objectForKey:@"Dependencies"];
        }
         */
        // Get Application's Dependencies
        NSError *error = [[NSError alloc] init];
        self.application = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:APPLICATION_FILE options:NSJSONReadingMutableLeaves error:&error];
        if (!self.application) {
            NSLog(@"An error occured during the Deserialization of Application file : %@", error);
        }
        else {
            if ([self.application objectForKey:@"Dependencies"]) {
                self.appDependencies = [self.application objectForKey:@"Dependencies"];
            }
        }
        // Load Content in the WebView
        if (![self.detailItem objectForKey:@"HtmlContent"]) {
            [self.content loadHTMLString:[self createHTML:@"<center><font color='blue'>There is no content</font></center>"] baseURL:[NSURL fileURLWithPath:APPLICATION_SUPPORT_PATH]];
        }
        else {
            [self.content loadHTMLString:[self createHTML:[self.detailItem objectForKey:@"HtmlContent"]] baseURL:[NSURL fileURLWithPath:APPLICATION_SUPPORT_PATH]];
        }
        // Set Page's title
        if (![self.detailItem objectForKey:@"Name"]) {
            self.navigationItem.title = @"No Name property";
        }
        else {
            self.navigationItem.title = [self.detailItem objectForKey:@"Name"];
        }
        
    }
}

- (NSMutableString *) addFiles
{
    NSMutableString *files;
    
    if (self.pageDependencies) {
        for (NSMutableDictionary *pageDep in self.pageDependencies) {
            if ([pageDep objectForKey:@"Name"]) {
                if ([[pageDep objectForKey:@"Type"] isEqualToString:@"script"]) {
                    NSString *fileName = [NSString stringWithFormat:@"%@.%@", [pageDep objectForKey:@"Name"], [AppDelegate extensionType:[pageDep objectForKey:@"Type"]]];
                    NSString *add = [NSString stringWithFormat:@"<script src='%@' type='text/javascript'></script>", fileName];
                    if (files) {
                        files = [NSMutableString stringWithFormat:@"%@%@", files, add];
                    } else {
                        files = (NSMutableString *)[NSString stringWithString:add];
                    }
                    
                }
                if ([[pageDep objectForKey:@"Type"] isEqualToString:@"style"]) {
                    NSString *fileName = [NSString stringWithFormat:@"%@.%@", [pageDep objectForKey:@"Name"], [AppDelegate extensionType:[pageDep objectForKey:@"Type"]]];
                    NSString *add = [NSString stringWithFormat:@"<link type='text/css' rel='stylesheet' href='%@'></link>", fileName];
                    if (files) {
                        files = [NSMutableString stringWithFormat:@"%@%@", files, add];
                    } else {
                        files = (NSMutableString *)[NSString stringWithString:add];
                    }
                }
            }
        }
    }
    if (self.appDependencies) {
        for (NSMutableDictionary *appDep in self.appDependencies) {
            if ([appDep objectForKey:@"Name"]) {
                if ([[appDep objectForKey:@"Type"] isEqualToString:@"script"]) {
                    NSString *fileName = [NSString stringWithFormat:@"%@.%@", [appDep objectForKey:@"Name"], [AppDelegate extensionType:[appDep objectForKey:@"Type"]]];
                    NSString *add = [NSString stringWithFormat:@"<script src='%@' type='text/javascript'></script>", fileName];
                    if (files) {
                        files = [NSMutableString stringWithFormat:@"%@%@", files, add];
                    } else {
                        files = (NSMutableString *)[NSString stringWithString:add];
                    }
                }
                if ([[appDep objectForKey:@"Type"] isEqualToString:@"style"]) {
                    NSString *fileName = [NSString stringWithFormat:@"%@.%@", [appDep objectForKey:@"Name"], [AppDelegate extensionType:[appDep objectForKey:@"Type"]]];
                    NSString *add = [NSString stringWithFormat:@"<link type='text/css' rel='stylesheet' href='%@'></link>", fileName];
                    if (files) {
                        files = [NSMutableString stringWithFormat:@"%@%@", files, add];
                    } else {
                        files = (NSMutableString *)[NSString stringWithString:add];
                    }
                }
            }
        }
    }
    NSLog(@"My final string = %@", files);
    return files;
}

- (NSString *) extensionType:(NSString *)type {
    NSString *mimeType;
    if ([type isEqualToString:@"script"]) {
        mimeType = @"js";
    }
    else if ([type isEqualToString:@"script"]) {
        mimeType = @"css";
    }
    else {
        mimeType = nil;
    }
    return mimeType;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    //barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    if (![self.detailItem objectForKey:@"Name"]) {
        barButtonItem.title = @"No Name property";
    }
    else {
        barButtonItem.title = [self.detailItem objectForKey:@"Name"];
    }
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Web View
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *errormsg = [NSString stringWithFormat:@"<html><center><font size=+4 color='red'>An error occured :<br>%@</font></center></html>", error.localizedDescription];
    [self.content loadHTMLString:[self createHTML:errormsg] baseURL:nil];
}

- (NSString *)createHTML:(NSString *)htmlContent
{
    NSString *html = [NSString stringWithFormat:@"<!DOCTYPE>"
                      "<html>"
                      "<head>"
                      "%@"
                      "</head>"
                      "<body>"
                      "<div id='Main' style='padding:10px;'>"
                      "%@"
                      "</body>"
                      "</head>"
                      "</html>"
                      , [self addFiles], htmlContent];
    
    return html;
}

@end
