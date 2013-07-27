//
//  Detail.m
//  Days
//
//  Created by dawaller on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Detail.h"


@implementation Detail

@synthesize item, itemTitle, itemDate, itemSummary,popover, itemUrl, shareButton;

- (id)initWithItem:(NSDictionary *)theItem {  
	/*if (self = [super initWithNibName:@"Detail" bundle:nil]) {
		self.item = theItem;  
		self.title = @"48 Days Blog";  
	}  
	*/
    self.item = theItem;
	return self;  
}



- (void)viewDidLoad {  
	[super viewDidLoad];  
	
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	self.itemTitle.text = [item objectForKey:@"title"];
    self.itemUrl = [item objectForKey:@"blogLink"];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];  
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];  
	
	self.itemDate.text = [dateFormatter stringFromDate:[item objectForKey:@"date"]];
    self.itemDate.textColor = [UIColor redColor];
	
	[self.itemSummary loadHTMLString:[item objectForKey:@"summary"] baseURL:nil];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.itemTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline1];
        self.itemDate.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    }
}  

- (IBAction)shareButtonTapped:(id)sender
{
    // initial text for social post
    NSString *initialText = [NSString stringWithFormat:@"%@", self.itemTitle.text];
    
    // url for social post
   // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.itemUrl]];
    
    NSString *tagLine = [NSString stringWithFormat:@"\nSent via 48 Days app\n\n"];
    
    UIActivityViewController* activity = [[UIActivityViewController alloc] initWithActivityItems:@[initialText, itemUrl, tagLine] applicationActivities:nil];
    
   [activity setValue:[NSString stringWithFormat:@"48 Days: %@", self.itemTitle.text] forKey:@"subject"];
    
   
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        activity.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeSaveToCameraRoll];
    } else {
        activity.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    }
    
    if (IDIOM == IPAD) {
        if (popover == nil) {
            popover = [[UIPopoverController alloc] initWithContentViewController:activity];
            [popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [popover dismissPopoverAnimated:YES];
            popover = nil;
        }
    } else {
        [self presentViewController:activity animated:YES completion:nil];
    }
}


/*
- (IBAction)playPodcast:(id)sender {  
	NSURLRequest *request = [[NSURLRequest alloc]  
							 initWithURL: [NSURL URLWithString: [item objectForKey:@"enclosure"]]];   
	
	[self.itemSummary loadRequest:request];  
}  

*/



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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
