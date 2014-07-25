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
        if ([[self.detailItem objectForKey:@"HtmlContent"] isKindOfClass:[NSNull class]]) {
            [self.content loadHTMLString:[self createHTML:@"<center><font color='blue'>There is no content</font></center>"] baseURL:[NSURL fileURLWithPath:APPLICATION_SUPPORT_PATH]];
        }
        else {
            [self.content loadHTMLString:[self createHTML:[self.detailItem objectForKey:@"HtmlContent"]] baseURL:[NSURL fileURLWithPath:APPLICATION_SUPPORT_PATH]];
        }
        
        if ([[self.detailItem objectForKey:@"Name"] isKindOfClass:[NSNull class]]) {
            self.navigationItem.title = @"No Name property";
        }
        else {
            self.navigationItem.title = [self.detailItem objectForKey:@"Name"];
        }
    }
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
    if ([[self.detailItem objectForKey:@"Name"] isKindOfClass:[NSNull class]]) {
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
                      "<link type='text/css' rel='stylesheet' href='jqueryMobileCSS.css'></link>"
                      "<script src='jquery.js' type='text/javascript'></script>"
                      "<script src='jqueryUI.js' type='text/javascript'></script>"
                      "<script src='jqueryMobile.js' type='text/javascript'></script>"
                      "</head>"
                      "<body>"
                      "<div id='Main' style='padding:10px;'>"
                      "%@"
                      "</body>"
                      "</head>"
                      "</html>"
                      , htmlContent];
    
    return html;
}

@end
