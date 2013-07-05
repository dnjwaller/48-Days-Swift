//
//  infoView.h
//  Days
//
//  Created by dawaller on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface infoView : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *infoWebView;
	UIActivityIndicatorView *activityIndicator;
	UIAlertView *alertView;
}

-(IBAction) resetData:(id) sender;
@property (nonatomic, strong) UIWebView *infoWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
