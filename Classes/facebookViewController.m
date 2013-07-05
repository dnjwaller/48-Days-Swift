//
//  NetWebViewController.m
//  Days
//
//  Created by dawaller on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "facebookViewController.h"
#import "Reachability.h"

@interface facebookViewController (PrivateMethods)  
- (void)loadData;  
@end

@implementation facebookViewController

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
	//[indicator release];
	
	//backButton = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:webDisplay action:@selector(goBack)] autorelease];
    backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:webDisplay action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem =backButton;
    
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:indicator];  
	self.navigationItem.rightBarButtonItem = rightButton;  
	self.navigationItem.title =@"48 Days Facebook";
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
	NSURL *url = [NSURL URLWithString:@"http://www.facebook.com/home.php#!/pages/Dan-Miller-Career-Coach-Author-of-48-Days-to-the-Work-You-Love/147834932132?ref=ts"];
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
