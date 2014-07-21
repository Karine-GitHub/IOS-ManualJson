//
//  DetailViewController.h
//  Test_JSON_V2
//
//  Created by admin on 7/10/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIWebView.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIWebView *content;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigation;

//javascript & css files
/*@property NSString *jqueryFile;
@property NSString *jqueryUIFile;
@property NSString *jqueryMobileFile;
@property NSString *jqueryMobileCSSFile;*/

@end
