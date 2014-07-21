//
//  AppDelegate.m
//  Test_JSON_V2
//
//  Created by admin on 7/10/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }

#pragma Download & save javascript & css files
    
    NSError *error = [[NSError alloc] init];

    // Get the Bundle identifier for creating dynamic path for storing all files
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    // NSHomeDirectory returns the application's sandbox directory
    // FileManager is using for creating the Application Support Folder
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appliSupportDir = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    [appliSupportDir URLByAppendingPathComponent:bundle isDirectory:YES];
    
    // Get jquery files in network
    NSURL *url = [NSURL URLWithString:@"http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"];
    NSString *path = [NSString stringWithFormat:@"%@/Library/Application Support/jquery.js", NSHomeDirectory()];
    NSData *const JQUERY_FILE = [NSData dataWithContentsOfURL:url];
    [JQUERY_FILE writeToFile:path options:NSDataWritingAtomic error:&error];
    
    url = [NSURL URLWithString:@"http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"];
    path = [NSString stringWithFormat:@"%@/Library/Application Support/jqueryUI.js", NSHomeDirectory()];
    NSData *const JQUERYUI_FILE = [NSData dataWithContentsOfURL:url];
    [JQUERYUI_FILE writeToFile:path options:NSDataWritingAtomic error:&error];
    
    url = [NSURL URLWithString:@"http://ajax.googleapis.com/ajax/libs/jquerymobile/1.4.3/jquery.mobile.min.js"];
    path = [NSString stringWithFormat:@"%@/Library/Application Support/jqueryMobile.js", NSHomeDirectory()];
    NSData *const JQUERY_MOBILE_FILE = [NSData dataWithContentsOfURL:url];
    [JQUERY_MOBILE_FILE writeToFile:path options:NSDataWritingAtomic error:&error];
    
    url = [NSURL URLWithString:@"http://ajax.googleapis.com/ajax/libs/jquerymobile/1.4.3/jquery.mobile.min.css"];
    path = [NSString stringWithFormat:@"%@/Library/Application Support/jqueryMobileCSS.css", NSHomeDirectory()];
    NSData *const JQUERY_MOBILE_CSS_FILE = [NSData dataWithContentsOfURL:url];
    [JQUERY_MOBILE_CSS_FILE writeToFile:path options:NSDataWritingAtomic error:&error];

    
#pragma Download & save Json Files
    // Read Json file in network. WARNING : ID EN DUR !!
    // Get Application File
    url = [NSURL URLWithString:@"http://testapp.visionit.lan:8087/api/application/79e45c6e-9e87-4576-b028-609ae2902f00"];
    path = [NSString stringWithFormat:@"%@/Library/Application Support/myApplication.json", NSHomeDirectory()];
    NSData *const APPLICATION_FILE = [NSData dataWithContentsOfURL:url];
    [APPLICATION_FILE writeToFile:path options:NSDataWritingAtomic error:&error];
    // Get Feed File
    url = [NSURL URLWithString:@"http://testapp.visionit.lan:8087/api/feed/79e45c6e-9e87-4576-b028-609ae2902f00"];
    path = [NSString stringWithFormat:@"%@/Library/Application Support/myFeed.json", NSHomeDirectory()];
    NSData *const FEED_FILE = [NSData dataWithContentsOfURL:url];
    [FEED_FILE writeToFile:path options:NSDataWritingAtomic error:&error];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
