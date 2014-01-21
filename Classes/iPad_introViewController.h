//
//  iPad_introViewController.h
//  Days
//
//  Created by Dan Waller on 1/7/14.
//
//

#import <UIKit/UIKit.h>

@interface iPad_introViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *introWebView;
	UIActivityIndicatorView *activityIndicator;
}


@property (nonatomic, strong) UIWebView *introWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


@end
