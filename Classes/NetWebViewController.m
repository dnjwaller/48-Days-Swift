//
//  NetWebViewController.m
//  Days
//
//  Created by dawaller on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetWebViewController.h"
#import "Reachability.h"

@interface NetWebViewController (PrivateMethods)  
- (void)loadData;  
@end

@implementation NetWebViewController

@synthesize webDisplay, activityIndicator, backButton;


-(void)reachable {
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	if(internetStatus == NotReachable) {
		netStatus = NO;
	} else {
		netStatus = YES;
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
	indicator.hidesWhenStopped = YES;  
	[indicator stopAnimating];  
	self.activityIndicator = indicator;
    
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navtitle"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;

    
    //backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:webDisplay action:@selector(goBack)];
    //self.navigationItem.leftBarButtonItem =backButton;

	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:indicator];  
	self.navigationItem.rightBarButtonItem = rightButton;  
	//self.navigationItem.title =@"Community";
	//[rightButton release];
	webDisplay.delegate = self;

}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self reachable];
}	


- (void)webViewDidStartLoad:(UIWebView *)webDisplay {
	[activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webDisplay {
	[activityIndicator stopAnimating];
}


- (void)viewDidAppear:(BOOL)animated {  
	if (netStatus == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:@"No Network Connection Detected"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		//[alert autorelease];
		[alert show];
		
	} 
	else {
		[self loadData];
	}
	[super viewDidAppear:animated];  
}  

- (void) goBack:(id) sender {
	[webDisplay goBack];
}


- (void) loadData {
	NSURL *url = [NSURL URLWithString:@"http://www.48days.net"];
	NSURLRequest *request = [ NSURLRequest requestWithURL: url ]; 
	[webDisplay loadRequest: request ];	
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
