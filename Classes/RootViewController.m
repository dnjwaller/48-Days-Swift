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


@interface RootViewController (PrivateMethods)  
- (void)loadData;  
@end

@implementation RootViewController


@synthesize activityIndicator, items;


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
	self.navigationItem.title =@"48 Days Blogs";
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"updateBlog" object:nil];
	//[rightButton release];
    
}  

- (void)updateView:(NSNotification *)notification {
    [self loadData]; 
}


- (void) orientationChanged:(NSNotification *)notification {
    //UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

/*if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"portraitAd" object:nil];
}
else {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"landscapeAd" object:nil];
}*/
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"portraitAd" object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"landscapeAd" object:nil];
    }
}

- (void)loadData {  
	//if (items == nil) {  
    [activityIndicator startAnimating];  
    
    Parser *rssParser = [[Parser alloc] init];  
    [rssParser parseRssFeed:@"http://feeds.feedburner.com/48Days?format=xml" withDelegate:self];  
    
    //[rssParser release];
    //[self.view setNeedsDisplay];
    
    
	//	} else {  
	//		[self.tableView reloadData];  }
    
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
        //int height = [[UIScreen mainScreen] bounds].size.height;
        //int width = [[UIScreen mainScreen] bounds].size.width;
        
	    [self loadData];
        //[[self tableView] setFrame:CGRectMake(0, 0, width, height)];
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

// Customize the number of rows in the table view.  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  
    return [items count];
}  


// Customize the appearance of table view cells.  
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
	
	self.tableView.backgroundColor = [UIColor lightTextColor];
	
    static NSString *CellIdentifier = @"Cell";  
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
    if (cell == nil) {  
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }  
	
	// Configure the cell.  
	
    cell.textLabel.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"]; 
	cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
	
	
	// Format date  
    //NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];  
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];  
	
    cell.detailTextLabel.text = [dateFormatter stringFromDate:[[items objectAtIndex:indexPath.row] objectForKey:@"date"]];  
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;  
	
	return cell;  

}  


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
	NSDictionary *theItem = [items objectAtIndex:indexPath.row];  
	Detail *nextController = [[Detail alloc] initWithItem:theItem];  
	[self.navigationController pushViewController:nextController animated:YES];  
	//[nextController release];
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
#pragma mark View lifecycle







/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	
}
*/

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

