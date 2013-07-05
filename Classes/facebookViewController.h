//
//  facebookViewController.h
//  Days
//
//  Created by Dan  Waller on 7/24/12.
//  Copyright (c) 2012 Iconic Solutions, Inc. . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface facebookViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate> {
    IBOutlet UIWebView *webDisplay;
	UIActivityIndicatorView *activityIndicator;
	UIBarButtonItem *backButton;
    BOOL netStatus;
	
}

@property (strong, nonatomic) UIWebView *webDisplay;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIBarButtonItem *backButton;

-(void)reachable;
@end
