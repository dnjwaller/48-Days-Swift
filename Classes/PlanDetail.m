//
//  PlanDetail.m
//  Days
//
//  Created by dawaller on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlanDetail.h"
#import "PlanViewController.h"
#import "flipsideViewController.h"
#import "GAI.h"

@implementation PlanDetail

- (void)flipsideViewControllerDidFinish:(flipsideViewController *)controller {
	//[self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/*
- (IBAction)showInfo:(id)sender {    
	
	flipsideViewController *controller = [[flipsideViewController alloc] initWithNibName:@"flipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	//[self presentModalViewController:controller animated:YES];
	[self.navigationController presentViewController:controller animated:YES completion:nil];
	//[controller release];
}




- (void)presentFlipSideViewController:(UIViewController *)flipsideViewController
{
    flipsideViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //[self.navigationController presentModalViewController:flipsideViewController animated:YES];
    [self.navigationController presentViewController:flipsideViewController animated:YES completion:nil];
}
*/

@synthesize item, itemTitle, itemSummary, itemDate;  

- (id)initWithItem:(NSDictionary *)theItem {  
//	if (self = [super initWithNibName:@"PlanDetail" bundle:nil]) {
//		self.item = theItem;
//	}
	
	return self;  
}  


- (void)viewDidLoad {  
	[super viewDidLoad]; 
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	//UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Complete" style: UIBarButtonItemStylePlain target:self action:@selector(isComplete:)];
	//self.navigationItem.rightBarButtonItem = rightButton;
	self.itemTitle.text = [item objectForKey:@"title"];  
	[self.itemSummary loadHTMLString:[item objectForKey:@"summary"] baseURL:nil];  
	row = [[item objectForKey:@"index"]intValue];
    
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navtitle"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    NSString *temp = [NSString stringWithFormat:@"Schedule Detail %@",self.itemTitle.text];
    [tracker sendView:temp];
    
   // [rightButton release];
}  
			
																					
		 
-(IBAction) isComplete:(id) sender {
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 //2) Create the full file path by appending the desired file name
 NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"status.txt"];
 
 //Load the array
 NSMutableArray *statusArray = [[NSMutableArray alloc] initWithContentsOfFile: fileName];
 
 [statusArray replaceObjectAtIndex:row withObject: @"0"];
 [statusArray writeToFile:fileName atomically:YES];
 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:@"Day Completed"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	//[alert autorelease];
	[alert show];
	//[statusArray release];
	
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Complete Button Pressed"
                         withValue:nil];
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
