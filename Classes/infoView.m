//
//  infoView.m
//  Days
//
//  Created by dawaller on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "infoView.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"


@implementation infoView

@synthesize infoWebView, activityIndicator;;


- (void)viewDidLoad {
	[super viewDidLoad];
	
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	infoWebView.delegate = self;
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
	NSString *filePath = [myBundle pathForResource:@"infoWeb" ofType:@"html"];
	NSURL *url = [NSURL fileURLWithPath:filePath];
	NSURLRequest *request = [ NSURLRequest requestWithURL:url  ]; 
	[infoWebView loadRequest: request ];
    
	id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Info Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if(navigationType ==  UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	else 
		return YES;
}


- (IBAction) resetData:(id) sender {
	
	alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to delete the Schedule Data?" delegate:self
					 cancelButtonTitle:@"No" otherButtonTitles: @"OK", nil ];
	
	alertView.delegate = self;
	[alertView show];
	
	}


- (void)alertView:(UIAlertView *)tempAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
if (tempAlertView == alertView) {
	if (buttonIndex == 1) { 
		UIAlertView *lastAlert = [[UIAlertView alloc] initWithTitle:nil
						message:@"The Schedule data has been reset"
						delegate:self
						cancelButtonTitle:@"OK"
						otherButtonTitles:nil]; 
		[lastAlert show];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		//2) Create the full file path by appending the desired file name
		NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"status.txt"];
		
		//Load the array
		//NSMutableArray *statusArray = [[NSMutableArray alloc] initWithContentsOfFile: fileName];
		
		//Array file didn't exist... create a new one
		NSMutableArray *statusArray = [[NSMutableArray alloc] initWithCapacity:49];
		
		//Fill with default values
		NSInteger i;
		for (i = 0; i < 49; i++)
		{
			[statusArray insertObject: @"1" atIndex: i];
		}
		[statusArray writeToFile:fileName atomically:YES];
	}
	
	} 
	
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
