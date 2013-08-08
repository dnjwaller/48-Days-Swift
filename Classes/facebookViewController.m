//
//  NetWebViewController.m
//  Days
//
//  Created by dawaller on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "facebookViewController.h"
#import "Reachability.h"
#import <Social/Social.h>
#import "GAI.h"

@interface facebookViewController (PrivateMethods)  
- (void)loadData;  
@end

@implementation facebookViewController

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
    
	//UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityIndicator.hidesWhenStopped = YES;
	[activityIndicator stopAnimating];
	//self.activityIndicator = indicator;
	
    backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:webDisplay action:@selector(goBack)];
    //self.navigationItem.leftBarButtonItem =backButton;
    
	// rightButton = [[UIBarButtonItem alloc]initWithCustomView:indicator];
	self.navigationItem.rightBarButtonItem = rightButton;  
	//self.navigationItem.title =@"48 Days Facebook";
	//[rightButton release];
	webDisplay.delegate = self;
   
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navtitle"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Facebook Screen"];
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
    
 /*   if(!_accountStore)
        _accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookTypeAccount = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [_accountStore requestAccessToAccountsWithType:facebookTypeAccount
                                           options:@{ACFacebookAppIdKey: @"147834932132", ACFacebookPermissionsKey: @[@"email"]}
                                        completion:^(BOOL granted, NSError *error) {
                                            if(granted){
                                                NSArray *accounts = [_accountStore accountsWithAccountType:facebookTypeAccount];
                                                _facebookAccount = [accounts lastObject];
                                                NSLog(@"Success");
                                                
                                                [self loadFacebook];
                                            }else{
                                                // ouch
                                                NSLog(@"Fail");
                                                NSLog(@"Error: %@", error);
                                                NSString *message;
                                                if([error code]== ACErrorAccountNotFound) {
                                                    message = @"Account not found. Please setup your account in the Settings app.";
                                            }else {
                                                    message = @"Account access denied.";
                                                }
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                [alert show];
                                            }
    }];*/
    NSURL *url = [NSURL URLWithString:@"http://www.facebook.com/home.php#!/pages/Dan-Miller-Career-Coach-Author-of-48-Days-to-the-Work-You-Love/147834932132?ref=ts"];
    NSURLRequest *request = [ NSURLRequest requestWithURL: url ];
    [webDisplay loadRequest: request ];
    
}

/*
- (void) loadFacebook {
        NSURL *url = [NSURL URLWithString:@"http://www.facebook.com/home.php#!/pages/Dan-Miller-Career-Coach-Author-of-48-Days-to-the-Work-You-Love/147834932132?ref=ts"];
       // NSURLRequest *request = [ NSURLRequest requestWithURL: url ];
       // [webDisplay loadRequest: request ];
    
        SLRequest *myrequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:url
                                                 parameters:nil];
    
        myrequest.account = _facebookAccount;
    
        [myrequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            NSString *meDataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@", meDataString);
        
        }];
}
*/


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
