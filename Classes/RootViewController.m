//
//  RootViewController.m
//  Days
//
//  Created by dawaller on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "Parser.h" 
#import "Detail.h"
#import "DaysAppDelegate.h"
#import "Reachability.h"
#import "GAI.h"

@interface RootViewController (PrivateMethods)  
- (void)loadData;  
@end

@implementation RootViewController


@synthesize activityIndicator, items;
NSDictionary *theItem;


-(void)reachable {
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	if(internetStatus == NotReachable) {
		netStatus = NO;
	} else {
		netStatus = YES;
	}
}



- (void)viewDidLoad {  
	[super viewDidLoad];  
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification object:nil];
   /* self.edgesForExtendedLayout = UIExtendedEdgeAll;
	
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 60, 0);
    [self.tableView setContentInset:insets];
    [self.tableView setScrollIndicatorInsets:insets];
    */
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
	indicator.hidesWhenStopped = YES;  
	[indicator stopAnimating];  
	self.activityIndicator = indicator;  
	//[indicator release];
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:indicator];  
	self.navigationItem.rightBarButtonItem = rightButton;  
	//self.navigationItem.title =@"48 Days Blogs";
	
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navtitle"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
    
    
    theItem = [[NSDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"updateBlog" object:nil];
	//[rightButton release];
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Blog Screen"];
    
}  

- (void)updateView:(NSNotification *)notification {
    [self loadData]; 
}


- (void) orientationChanged:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"portraitAd" object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"landscapeAd" object:nil];
    }
}

- (void)loadData {  
    [activityIndicator startAnimating];  
    
    Parser *rssParser = [[Parser alloc] init];  
    [rssParser parseRssFeed:@"http://feeds.feedburner.com/48Days?format=xml" withDelegate:self];  
}  


-(void) viewDidAppear:(BOOL)animated {
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


-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self reachable];
    [self loadData];
}	


- (void)receivedItems:(NSArray *)theItems {  
	items = theItems;  
	[self.tableView reloadData];  
	[activityIndicator stopAnimating];  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// Customize the number of rows in the table view.  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}  


// Customize the appearance of table view cells.  
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
	
	//self.tableView.backgroundColor = [UIColor lightTextColor];
	
       
    static NSString *CellIdentifier = @"Cell";  
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
    if (cell == nil) {  
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
   /* if (indexPath.row % 2 == 0) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else {
       // cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    */
	// Configure the cell.  
	
    
	
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        //Dynamic Type
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
	
	// Format date  
    //NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];  
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];  
	
    
    cell.detailTextLabel.text = [dateFormatter stringFromDate:[[items objectAtIndex:indexPath.row] objectForKey:@"date"]];
    cell.textLabel.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
    
	return cell;  

}  


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	theItem = [items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"BlogDetail" sender:self];
	//Detail *nextController = [[Detail alloc] initWithItem:theItem];
	//[self.navigationController pushViewController:nextController animated:YES];
	//[nextController release];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"BlogDetail"]) {
        Detail *detailVC = segue.destinationViewController;
        [detailVC setItem:theItem];
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


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


@end

