//
//  MasterViewController.h
//  Test_JSON_V2
//
//  Created by admin on 7/10/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IASKAppSettingsViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <UIAlertViewDelegate, IASKSettingsDelegate, UITextViewDelegate>

@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *Settings;
@property (strong, nonatomic) IBOutlet UITableView *menu;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSString *errorMsg;

@end
