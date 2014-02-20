//
//  iPad_introViewController.m
//  Days
//
//  Created by Dan Waller on 1/7/14.
//
//

#import "iPad_introViewController.h"

@interface iPad_introViewController ()

@end



@implementation iPad_introViewController


@synthesize introWebView, activityIndicator;;


- (void)viewDidLoad {
	[super viewDidLoad];
	
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	introWebView.delegate = self;
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	indicator.hidesWhenStopped = YES;
	[indicator stopAnimating];
	self.activityIndicator = indicator;
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:indicator];
	self.navigationItem.rightBarButtonItem = rightButton;
	//self.navigationItem.title =@"About Us";
	
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navlogo"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
	
	NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
	NSString *filePath = [myBundle pathForResource:@"iPad_intro" ofType:@"html"];
	NSURL *url = [NSURL fileURLWithPath:filePath];
	NSURLRequest *request = [ NSURLRequest requestWithURL:url  ];
	[introWebView loadRequest: request ];
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if(navigationType ==  UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	else
		return YES;
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later
        return YES;
    }
    else
    {
        // The device is an iPhone or iPod touch.
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
