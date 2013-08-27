//
//  NetWebViewController.h
//  Days
//
//  Created by dawaller on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NetWebViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate> {
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
