//
//  DetailViewController.m
//  Test_JSON_V2
//
//  Created by admin on 7/10/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
//javascript & css files
@property NSString *jqueryFile;
@property NSString *jqueryUIFile;
@property NSString *jqueryMobileFile;
@property NSString *jqueryMobileCSSFile;
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
    NSString *msg = @"<html><center><font color='blue'>There is no content</font></center></html>";

    if (self.detailItem) {
        if ([[self.detailItem objectForKey:@"HtmlContent"] isKindOfClass:[NSNull class]]) {
            [self.content loadHTMLString:msg baseURL:nil];
        }
        else {
            [self.content loadHTMLString:[self.detailItem objectForKey:@"HtmlContent"] baseURL:nil];            
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
    [self.content setDelegate:self];
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
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
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
    
    [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.src = 'http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js';"
                        "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.src = 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js';"
                        "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    
    [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.src = 'http://ajax.googleapis.com/ajax/libs/jquerymobile/1.4.3/jquery.mobile.min.js';"
                        "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"var link = document.createElement('link');"
                        "link.type = 'text/css';"
                        "link.rel = 'stylesheet';"
                        "link.href = 'http://ajax.googleapis.com/ajax/libs/jquerymobile/1.4.3/jquery.mobile.min.css';"
                        "document.getElementsByTagName('head')[0].appendChild(link);"];

}

- (void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *errormsg = [NSString stringWithFormat:@"<html><center><font size=+7 color='red'>An error occured :<br>%@</font></center></html>", error.localizedDescription];
    [self.content loadHTMLString:errormsg baseURL:nil];
}

@end
