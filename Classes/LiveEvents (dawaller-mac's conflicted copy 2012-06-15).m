//
//  LiveEvents.m
//  Days
//
//  Created by dawaller on 5/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LiveEvents.h"


@implementation LiveEvents


- (id)initWithFrame:(CGRect)frame
{
   // self = [super initWithFrame:frame];
    if ((self = [super initWithNibName:@"LiveEventsView" bundle:nil])) {  
		//self.item = theItem;  
		self.title = @"48 Days Live Events"; 
    }
    return self;
}


- (IBAction) registerCWE:(id) sender {
    NSString *cweUrl = @"http://www.1automationwiz.com/app/?Clk=4684697";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: cweUrl]];
}

- (IBAction) calendarCWE:(id) sender {}

- (IBAction) registerWTB:(id) sender {
    NSString *wtbUrl = @"http://www.1automationwiz.com/app/?Clk=4684696";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: wtbUrl]];
}

- (IBAction) calendarWTB:(id) sender {}

- (IBAction) registerHours:(id) sender {
    NSString *hoursUrl = @"http://www.1automationwiz.com/app/?Clk=4684695";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: hoursUrl]];
}

- (IBAction) calendarHours:(id) sender {}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
