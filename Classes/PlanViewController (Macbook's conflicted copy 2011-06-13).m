//
//  PlanViewController.m
//  Days
//
//  Created by dawaller on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlanViewController.h"
#import "DayParse.h"
#import "PlanDetail.h"
#import "DaysAppDelegate.h"



@interface PlanViewController (PrivateMethods)  
- (void)loadData;  
@end


@implementation PlanViewController 

@synthesize activityIndicator, items; 

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];  
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
	indicator.hidesWhenStopped = YES;  
	[indicator stopAnimating];  
	self.activityIndicator = indicator;  
	[indicator release];  

	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] init];  
	self.navigationItem.rightBarButtonItem = rightButton;  
	self.navigationItem.title =@"48 Days Schedule";
	[rightButton release];  
}



- (void)viewDidAppear:(BOOL)animated {  
	[self loadData];  
	[super viewDidAppear:animated];  
}



- (void)loadData {  
    if (items == nil) {  
		[activityIndicator startAnimating];  

		//DayParse *rssParser = [[DayParse alloc] init];  
		//NSURL *url = [ NSURL fileURLWithPath: @"days_schedule.rtf" ];
		//NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"days_schedule" ofType:@"xml"];
		//NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
		NSXMLParser *xmlParser = [[NSXMLParser alloc] init];
		[xmlParser parse];
		
    } else {  
		[self.tableView reloadData];  
	}  
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];  
    }  
	
	// Configure the cell.  
	
    cell.textLabel.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"]; 
	cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
	
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;  
	
	
	
	return cell;  
}  


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
	NSDictionary *theItem = [items objectAtIndex:indexPath.row];  
	PlanDetail *nextController = [[PlanDetail alloc] initWithItem:theItem];  
	//[self presentModalViewController:nextController animated:YES];
	[self.navigationController pushViewController:nextController animated:YES];  
	[nextController release];  
}  


/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return <#number of sections#>;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return <#number of rows in section#>;
}
*/


/*
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}
*/

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
    // Navigation logic may go here. Create and push another view controller.
    /*
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
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

