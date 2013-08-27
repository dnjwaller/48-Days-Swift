//
//  ProductsViewController.m
//  Days
//
//  Created by Dan Waller on 12/10/12.
//
//

#import "ProductsViewController.h"
#import "Reachability.h"
#import "GAI.h"

@interface ProductsViewController ()
- (void)loadData;
@end

@implementation ProductsViewController

@synthesize webDisplay, activityIndicator, backButton;
UIBarButtonItem *rightButton;


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
	
   // self.view.autoresizesSubviews = YES;
   // self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	indicator.hidesWhenStopped = YES;
	[indicator stopAnimating];
	self.activityIndicator = indicator;
    backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:webDisplay action:@selector(goBack)];
	rightButton = [[UIBarButtonItem alloc]initWithCustomView:indicator];
	self.navigationItem.rightBarButtonItem = rightButton;
    webDisplay.delegate = self;
    
    
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navtitle"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Products Screen"];
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self reachable];
}


- (void)webViewDidStartLoad:(UIWebView *)webDisplay {
    self.navigationItem.rightBarButtonItem = rightButton;
	[activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webDisplay {
    [self zoomToFit];
	[activityIndicator stopAnimating];
    
    self.navigationItem.rightBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem.enabled = (self.webDisplay.canGoBack);
}

-(void)zoomToFit
{
    
    if ([webDisplay respondsToSelector:@selector(scrollView)])
    {
        UIScrollView *scroll=[webDisplay scrollView];
        
        float zoom=webDisplay.bounds.size.width/scroll.contentSize.width;
        [scroll setZoomScale:zoom animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
	if (netStatus == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:@"No Network Connection Detected"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
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
	NSURL *url = [NSURL URLWithString:@"https://sites.google.com/site/48daystheapp/examples/files/48DaysProducts.html"];
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
