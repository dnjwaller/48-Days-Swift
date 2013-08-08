//
//  PodcastViewController.m
//  Days
//
//  Created by dawaller on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PodcastViewController.h"
#import "Parser.h" 
#import "PodcastViewDetail.h"
#import "Reachability.h"
#import "GAI.h"


@interface PodcastViewController (PrivateMethods)  
- (void)loadData;  
@end

@implementation PodcastViewController


@synthesize activityIndicator, items;
NSDictionary *theItem;

BOOL playing=NO;

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
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 32, 0);
    [self.tableView setContentInset:insets];
    [self.tableView setScrollIndicatorInsets:insets];
    
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
	indicator.hidesWhenStopped = YES;  
	[indicator stopAnimating];  
	self.activityIndicator = indicator;  
	//[indicator release];
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:indicator];  
	self.navigationItem.rightBarButtonItem = rightButton;
    theItem = [[NSDictionary alloc] init];
	//self.navigationItem.title =@"Podcasts";
	//[rightButton release];
	
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navtitle"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"updatePodcast" object:nil];
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Podcast Screen"];
}
    
-(void) isPlaying:(NSNotification *)notification {
    playing = YES;
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self reachable];
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

- (void)updateView:(NSNotification *)notification {
    [self loadData]; 
}

- (void)loadData {  
		[activityIndicator startAnimating];  
		
		Parser *rssParser = [[Parser alloc] init];  
		[rssParser parseRssFeed:@"http://feeds.feedburner.com/48DaysRadio?format=xml" withDelegate:self];  
}  

- (void)receivedItems:(NSArray *)theItems {  
	items = theItems;  
	[self.tableView reloadData];  
	[activityIndicator stopAnimating];  
}

// Customize the number of rows in the table view.  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  
    return [items count];  
}  


// Customize the appearance of table view cells.  
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
	
	
    static NSString *CellIdentifier = @"Cell";  
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
    if (cell == nil) {  
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }  
	
	// Configure the cell.  
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        //Dynamic Type
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.textLabel.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	
	// Format date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];  
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];  
	
    cell.textLabel.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:[[items objectAtIndex:indexPath.row] objectForKey:@"date"]];  
      
	
	return cell;  
}  


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
	theItem = [items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"PodcastDetail" sender:self];
    //PodcastViewDetail *nextController = [[PodcastViewDetail alloc] initWithItem:theItem];
    //[self.navigationController pushViewController:nextController animated:YES];
   // [nextController release];
}  


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"PodcastDetail"]) {
        PodcastViewDetail *detailVC = segue.destinationViewController;
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


@end

