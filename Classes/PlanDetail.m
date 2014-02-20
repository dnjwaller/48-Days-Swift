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
#import "DayParse.h"
#import "CarouselViewController.h"

@implementation PlanDetail

@synthesize items, parser, complete,completed,button;
NSMutableArray *statusArray;
NSInteger day;

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

- (void) awakeFromNib {
    CarouselViewController *carouselVC = [[CarouselViewController alloc] init];
    day = carouselVC.dayIndex;
    [self loadData];
	[self loadCompleteData];
}

- (void) loadCompleteData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//2) Create the full file path by appending the desired file name
	NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"status.txt"];
	
	//Load the array
	statusArray = [[NSMutableArray alloc] initWithContentsOfFile: fileName];
	
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
        self.complete = statusArray;
    }
    self.complete = statusArray;
}

- (void)loadData {
    
	if (items == nil) {
        
        NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
        NSString *filePath = [myBundle pathForResource:@"days_schedule" ofType:@"xml"];
        NSURL *xmlPath = [NSURL fileURLWithPath:filePath];
        
		DayParse *xmlParser = [[DayParse alloc] init];
		xmlParser.delegate = self;
		[xmlParser parse:xmlPath withDelegate:self];
    }
    self.item = [items objectAtIndex:day];
}

- (void) loadNewDay:(NSNotification *)aDay {
    NSDictionary * dict = [[NSDictionary alloc] initWithDictionary:[aDay userInfo]];
    day = [[dict objectForKey:@"day"] integerValue];
    self.item = [items objectAtIndex:day];
    self.itemTitle.text = [item objectForKey:@"title"];
    NSMutableString *planString = [[NSMutableString alloc] init];
    planString = [NSMutableString stringWithFormat:@"<html><head>"
                  "<style type=\"text/css\">"
                  "body{font:-apple-system-body;}"
                  "</style>""</head>""<body>"];
    
    [planString appendString:[item objectForKey:@"summary"]];
    [planString appendString:@"</body></html>"];
    
    [self setLabels];
    
	[self.itemSummary loadHTMLString:planString baseURL:nil];
}

- (void) setLabels {
    
    if (![[complete objectAtIndex:day] integerValue]) {
        completed.hidden = NO;
        button.enabled = NO;
        button.hidden = YES;
    } else {
        completed.hidden = YES;
        button.enabled = YES;
        button.hidden = NO;
    }
}


- (void)receivedItems:(NSArray *)theItems {
	items = theItems;
}

/*
- (id)initWithItem:(NSDictionary *)theItem {  
//	if (self = [super initWithNibName:@"PlanDetail" bundle:nil]) {
//		self.item = theItem;
//	}
	return self;  
}  
*/

- (void)viewDidLoad {  
	[super viewDidLoad]; 
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	//UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Complete" style: UIBarButtonItemStylePlain target:self action:@selector(isComplete:)];
	//self.navigationItem.rightBarButtonItem = rightButton;
	self.itemTitle.text = [item objectForKey:@"title"];  
	[self.itemSummary loadHTMLString:[item objectForKey:@"summary"] baseURL:nil];  
	row = [[item objectForKey:@"index"]intValue];
    
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navlogo"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    NSString *temp = [NSString stringWithFormat:@"Schedule Detail %@",self.itemTitle.text];
    [tracker sendView:temp];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewDay:)
                                                 name:@"newDay" object:nil];
   // [rightButton release];
}  
			

		 
-(IBAction) isComplete:(id) sender {
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 //2) Create the full file path by appending the desired file name
 NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"status.txt"];
 
 //Load the array
 NSMutableArray *statusArray = [[NSMutableArray alloc] initWithContentsOfFile: fileName];
 
 [statusArray replaceObjectAtIndex:day withObject: @"0"];
 [statusArray writeToFile:fileName atomically:YES];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:[NSString stringWithFormat:@"Day %i Completed",day]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	//[alert autorelease];
	[alert show];
	//[statusArray release];
    
    self.complete = statusArray;
    [self setLabels];
	
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
