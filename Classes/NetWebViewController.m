//
//  NetWebViewController.m
//  Days
//
//  Created by dawaller on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetWebViewController.h"
#import "Reachability.h"
#import "GAI.h"

@interface NetWebViewController (PrivateMethods)  
- (void)loadData;  
@end

@implementation NetWebViewController

UIBarButtonItem *rightButton;

@synthesize webDisplay, activityIndicator, backButton, ipadBackButton;


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
	
    [activityIndicator setHidesWhenStopped:YES];
    backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:webDisplay action:@selector(goBack)];
    webDisplay.delegate = self;
    
    
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navlogo"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [ipadBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else
    {
        [ipadBackButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }

    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Community Screen"];

}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self reachable];
}	


- (void)webViewDidStartLoad:(UIWebView *)webDisplay {
    //self.navigationItem.rightBarButtonItem = rightButton;
	[activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webDisplay {
	[activityIndicator stopAnimating];
    [activityIndicator setHidden:YES];
    
    self.navigationItem.rightBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem.enabled = (self.webDisplay.canGoBack);
    
    ipadBackButton.enabled = (self.webDisplay.canGoBack);
    ipadBackButton.hidden = !(self.webDisplay.canGoBack);
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

- (IBAction) goBack:(id) sender {
	[webDisplay goBack];
}


- (void) loadData {
    dispatch_queue_t bgQueue = dispatch_queue_create( "parser", NULL );
    
    dispatch_async(bgQueue, ^{
        NSURL *url = [NSURL URLWithString:@"http://www.48days.net"];
        NSURLRequest *request = [ NSURLRequest requestWithURL: url ];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [webDisplay loadRequest: request ];
        });
    });
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
