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

@synthesize activityIndicator, items, parser, complete; 

#pragma mark -
#pragma mark View lifecycle


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

	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]init];
	self.navigationItem.rightBarButtonItem = rightButton;  
	self.navigationItem.title =@"48 Days Schedule";

}



- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated]; 
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//2) Create the full file path by appending the desired file name
	NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"status.txt"];
	
	//Load the array
	NSMutableArray *statusArray = [[NSMutableArray alloc] initWithContentsOfFile: fileName];
	
	self.complete = statusArray;

	[self.tableView reloadData];	
	
}



-(void) viewDidAppear:(BOOL)animated {
	[self loadData];
	[super viewDidAppear:animated];
}


- (void)loadData {  
	if (items == nil) {  
		[activityIndicator startAnimating];
		NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
		NSString *xmlPath = [myBundle pathForResource:@"days_schedule" ofType:@"xml"];
		DayParse *xmlParser = [[DayParse alloc] init];
		xmlParser.delegate = self;
		[xmlParser parse:xmlPath withDelegate:self];
		
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		//2) Create the full file path by appending the desired file name
		NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"status.txt"];
		
		//Load the array
		NSMutableArray *statusArray = [[NSMutableArray alloc] initWithContentsOfFile: fileName];
		
		if(statusArray == nil)
		{
			//Array file didn't exist... create a new one
			statusArray = [[NSMutableArray alloc] initWithCapacity:49];
			
			//Fill with default values
			NSInteger i;
			for (i = 0; i < 49; i++)
			{
				[statusArray insertObject: @"1" atIndex: i];
			}
			[statusArray writeToFile:fileName atomically:YES];
		}
		self.complete = statusArray;
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
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}  
	
	// Configure the cell.  
	
    cell.textLabel.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"]; 
	cell.textLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:20];
	row = [[[items objectAtIndex:indexPath.row] objectForKey:@"index"]intValue];
	status = [complete objectAtIndex:row];
	BOOL done = [status isEqualToString:@"1"];
	
	if (done) {
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;  
	} else {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	return cell; 
}  


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
	NSDictionary *theItem = [items objectAtIndex:indexPath.row];  
	PlanDetail *nextController = [[PlanDetail alloc] initWithItem:theItem];  
	[self.navigationController pushViewController:nextController animated:YES];
	
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
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


@end
