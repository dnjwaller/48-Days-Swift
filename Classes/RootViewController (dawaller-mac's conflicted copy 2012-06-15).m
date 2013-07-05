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
	Reachability *r = [Reachability reachabilityWithHostName:@"www.48days.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	if(internetStatus == NotReachable) {
		netStatus = NO;
	} else {
		netStatus = YES;
	}
}



- (void)viewDidLoad {  
	[super viewDidLoad];  
	
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
	indicator.hidesWhenStopped = YES;  
	[indicator stopAnimating];  
	self.activityIndicator = indicator;  
	[indicator release];  
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:indicator];  
	self.navigationItem.rightBarButtonItem = rightButton;  
	self.navigationItem.title =@"48 Days Blogs";
	
	[rightButton release];  
}  


- (void)loadData {  
	//if (items == nil) {  
    [activityIndicator startAnimating];  
    
    Parser *rssParser = [[Parser alloc] init];  
    [rssParser parseRssFeed:@"http://feeds.feedburner.com/48Days?format=xml" withDelegate:self];  
    
    [rssParser release];  
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
		[alert autorelease];
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
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];  
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }  
	
	// Configure the cell.  
	
    cell.textLabel.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"]; 
	cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
	
	
	// Format date  
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];    
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
	[nextController release];  
}  

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)dealloc {  
	[activityIndicator release];  
	[items release]; 
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[super dealloc];  
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

