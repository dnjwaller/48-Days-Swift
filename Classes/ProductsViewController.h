//
//  ProductsViewController.h
//  Days
//
//  Created by Dan Waller on 12/10/12.
//
//

#import <UIKit/UIKit.h>

@interface ProductsViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate> {

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
