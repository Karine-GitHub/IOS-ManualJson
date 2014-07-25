//
//  AppDelegate.m
//  Test_JSON_V2
//
//  Created by admin on 7/10/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"

NSData *APPLICATION_FILE;
NSData *FEED_FILE;
NSString *APPLICATION_SUPPORT_PATH;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
#pragma Create the Application Support Folder. Not accessible by users
    // NSHomeDirectory returns the application's sandbox directory. Application Support folder will contain all files that we need for the application
    APPLICATION_SUPPORT_PATH = [NSString stringWithFormat:@"%@/Library/Application Support/", NSHomeDirectory()];
    NSLog(@"APPLICATION_SUPPORT_PATH = %@", APPLICATION_SUPPORT_PATH);
    
    // Application Support folder is not always created by default. The following code creates it.
    // Get the Bundle identifier for creating dynamic path for storing all files
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    // FileManager is using for creating the Application Support Folder
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = [[NSError alloc] init];
    NSURL *appliSupportDir = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    [appliSupportDir URLByAppendingPathComponent:bundle isDirectory:YES];
    
#pragma Download & save javascript & css files
    NSURL *url = [NSURL URLWithString:@"http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"];
    NSString *path = [NSString stringWithFormat:@"%@jquery.js", APPLICATION_SUPPORT_PATH];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSData dataWithContentsOfURL:url] writeToFile:path options:NSDataWritingAtomic error:&error];
    }
    // JqueryUI
    url = [NSURL URLWithString:@"http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"];
    path = [NSString stringWithFormat:@"%@jqueryUI.js", APPLICATION_SUPPORT_PATH];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSData dataWithContentsOfURL:url] writeToFile:path options:NSDataWritingAtomic error:&error];
    }
    //Jquery Mobile (js & css)
    url = [NSURL URLWithString:@"http://ajax.googleapis.com/ajax/libs/jquerymobile/1.4.3/jquery.mobile.min.js"];
    path = [NSString stringWithFormat:@"%@jqueryMobile.js", APPLICATION_SUPPORT_PATH];
    if (![fileManager fileExistsAtPath:path]) {

        [[NSData dataWithContentsOfURL:url] writeToFile:path options:NSDataWritingAtomic error:&error];
    }
    url = [NSURL URLWithString:@"http://ajax.googleapis.com/ajax/libs/jquerymobile/1.4.3/jquery.mobile.min.css"];
    path = [NSString stringWithFormat:@"%@jqueryMobileCSS.css", APPLICATION_SUPPORT_PATH];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSData dataWithContentsOfURL:url] writeToFile:path options:NSDataWritingAtomic error:&error];
    }
    
#pragma Download & save Json Files
    // Read Json file in network. WARNING : ID EN DUR !!
    // Get Application File
    url = [NSURL URLWithString:@"http://testapp.visionit.lan:8087/api/application/79e45c6e-9e87-4576-b028-609ae2902f00"];
    path = [NSString stringWithFormat:@"%@myApplication.json", APPLICATION_SUPPORT_PATH];
    if (![fileManager fileExistsAtPath:path]) {
        APPLICATION_FILE = [NSData dataWithContentsOfURL:url];
        [[NSData dataWithContentsOfURL:url] writeToFile:path options:NSDataWritingAtomic error:&error];
    }
    else {
        APPLICATION_FILE = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    }
    // Get Feed File
    url = [NSURL URLWithString:@"http://testapp.visionit.lan:8087/api/feed/79e45c6e-9e87-4576-b028-609ae2902f00"];
    path = [NSString stringWithFormat:@"%@myFeed.json", APPLICATION_SUPPORT_PATH];
    if (![fileManager fileExistsAtPath:path]) {
        FEED_FILE = [NSData dataWithContentsOfURL:url];
        [[NSData dataWithContentsOfURL:url] writeToFile:path options:NSDataWritingAtomic error:&error];
    }
    else {
        FEED_FILE = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    }

    
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
