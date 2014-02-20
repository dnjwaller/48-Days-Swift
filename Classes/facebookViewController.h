//
//  facebookViewController.h
//  Days
//
//  Created by Dan  Waller on 7/24/12.
//  Copyright (c) 2012 Iconic Solutions, Inc. . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>


@interface facebookViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate> {
    IBOutlet UIWebView *webDisplay;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	UIBarButtonItem *backButton;
    BOOL netStatus;
}

@property (strong, nonatomic) UIWebView *webDisplay;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccount *facebookAccount;
@property (strong, nonatomic) IBOutlet UIButton *ipadBackButton;

-(void)reachable;
-(IBAction)goBack:(id)sender;
@end
