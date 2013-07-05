//
//  LiveEvents.m
//  Days
//
//  Created by dawaller on 5/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
// Display conference dates and allow user to register or add date to their calendar 

#import "LiveEvents.h"
#import <EventKit/EventKit.h>
#import "Reachability.h"



@implementation LiveEvents

@synthesize event1, event2, event3, event4,activityIndicator,scrollView;

NSString *eventDates;
int eventDay;
int eventMonth;
int eventYear;
NSDate *timestamp;
NSString *event;
/*NSString *event1interval;
NSString *event2interval;
NSString *event3interval;
NSString *event4interval;
NSString *event5interval;
NSString *event6interval;
NSString *event1url;
NSString *event2url;
NSString *event3url;
NSString *event4url;
NSString *event5url;
NSString *event6url;
NSString *event1title;
NSString *event2title;
NSString *event3title;
NSString *event4title;
NSString *event5title;
NSString *event6title;*/
NSString *title;
NSMutableDictionary *md;

int interval=0;


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:@"LiveEventsView2" bundle:nil])  {
        self.title = @"48 Days Live Events"; 
    }
    return self;
}

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
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
	indicator.hidesWhenStopped = YES;  
	[indicator stopAnimating];  
	self.activityIndicator = indicator;  
    
    [self loadEvents];
    
   /* //load images
    NSURL *url = [NSURL URLWithString:[md objectForKey:@"event1image"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img1 = [UIImage imageWithData:data];
    
    url = [NSURL URLWithString:[md objectForKey:@"event2image"]];
    data = [NSData dataWithContentsOfURL:url];
    UIImage *img2 = [UIImage imageWithData:data];
    
    url = [NSURL URLWithString:[md objectForKey:@"event3image"]];
    data = [NSData dataWithContentsOfURL:url];
    UIImage *img3 = [UIImage imageWithData:data];
    
    url = [NSURL URLWithString:[md objectForKey:@"event4image"]];
    data = [NSData dataWithContentsOfURL:url];
    UIImage *img4 = [UIImage imageWithData:data];  */
    
    UIImage *img1 =[UIImage imageNamed:@"cwe_new.png"];
    UIImage *img2 =[UIImage imageNamed:@"masterylogo.png"];
    UIImage *img3 =[UIImage imageNamed:@"ino48.png"];
    
    self.event1.image = img1;
    self.event2.image = img2;
    self.event3.image = img3;
    //self.event4.image = img4;
    
    [scrollView addSubview:event1];
    [scrollView addSubview:event2];
    [scrollView addSubview:event3];
    //[scrollView addSubview:event4];
    
	scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height); 
    scrollView.delegate = self;
    //[self.view addSubview:scrollView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"updateEvents" object:nil];
}

- (void)updateView:(NSNotification *)notification {
    [self loadEvents];
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
	     [self loadEvents];
    }
    
	[super viewDidAppear:animated];
}

-(void) viewWillAppear:(BOOL)animated {
    [self reachable];
    [self loadEvents];
}



//calendar
- (void) calendarEvent  {
    
    NSString *titleString = [event stringByAppendingString:@"title"];
    NSString *eventInterval = [event stringByAppendingString:@"interval"];
    title = [md objectForKey:titleString];
    interval = [[md objectForKey:eventInterval] intValue];
    [self showCalendarChoice];
    
}

//Register
-(void) registerEvent {
    NSString *url = [event stringByAppendingString:@"url"];
    NSString *eventUrl = [md objectForKey:url];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: eventUrl]];
}


// Register for Coaching With Excellence
- (IBAction) registerEvent1:(id) sender {
    event=@"event1";
    [self registerEvent];
}


//Add Coaching With Excellence to calendar
- (IBAction) calendarEvent1:(id) sender {
    event = @"event1";
    [self calendarEvent];
}


//Register Coaching Mastery
- (IBAction) registerEvent2:(id) sender {
    event=@"event2";
    [self registerEvent];
}

//Add Coaching Mastery to calendar
- (IBAction) calendarEvent2:(id) sender {
    event = @"event2";
    [self calendarEvent];
}

//Register Innovate
- (IBAction) registerEvent3:(id) sender {
    event=@"event3";
    [self registerEvent];
}

//Add Innovate Calendar
- (IBAction) calendarEvent3:(id) sender {
    event = @"event3";
    [self calendarEvent];

}

/*
- (IBAction) registerEvent4:(id) sender {
    event=@"event4";
    [self registerEvent];
}

- (IBAction) calendarEvent4:(id) sender {
    event = @"event4";
    [self calendarEvent];
    
}
 */

-(void) loadEvents {
    [md removeAllObjects];
    NSURL *url = [NSURL URLWithString:@"https://sites.google.com/site/48daystheapp/examples/files/live.plist"];
    md = [NSDictionary dictionaryWithContentsOfURL:url];
}

-(void) showCalendarChoice {

    Class cls = NSClassFromString (@"EKEventStore");
    
    //Check to see if using ios4.0 or later
    if (cls) {
    
    //retrieve live.plist for list of dates
    
    NSArray *dates = [md objectForKey:event];

    //display dates to user
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Dates" 
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    int counter = [dates count];
    
    for (int i = 0; i < counter; i++) {
        [actionSheet addButtonWithTitle:[dates objectAtIndex:i]];        
    }
    
    
    
    //check if using iPad and check orientation to display correctly
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
         UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
           [actionSheet showFromRect:CGRectMake(0, 0, 700, 585) inView:self.view animated:YES];
        }
        else {
            [actionSheet showFromRect:CGRectMake(0, 0,600, 600) inView:self.view animated:YES];
        }
        
        
    }
    else {
            [actionSheet addButtonWithTitle:@"Cancel"];
            actionSheet.cancelButtonIndex = 4;
            [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
            
            [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
            [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    }
        
    
    
    
    }
    //Not using ios 4.0 or later
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This function is only supported on IOS 4.0 and later." delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK", nil ];
        
        [alert show];
    }
    
    
}


//handle button clicked on dates action sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == -1) {
        [actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    }
    else {
        eventDates = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    
        if ((![eventDates isEqualToString:@"Cancel"]) && (![eventDates isEqualToString:@"No Event Scheduled"])) {
            
            NSMutableString *key = [NSMutableString stringWithString:@""];
            NSMutableString *startKey = [NSMutableString stringWithString:@""];
            NSMutableString *endKey = [NSMutableString stringWithString:@""];
      
            //Build the keynames to find the event start and end dates and add to calendar.  
            [key appendString:event];
            [key appendString:[NSString stringWithFormat:@"%d",buttonIndex+1]];
            [startKey appendString: key];
            [startKey appendString:@"StartDay"];
      
            [endKey appendString: key];
            [endKey appendString:@"EndDay"];
      
      
            NSString *startDay = [md objectForKey:startKey];
            NSString *endDay = [md objectForKey:endKey];
      

            [self addEvent:title start:startDay end:endDay];
     
      }
     
    }
    
}

 
//add event to the calendar
- (void) addEvent:(NSString *)title start:(NSString *)startDate end:(NSString *)endDate {
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *Day1 = [formatter dateFromString:startDate];
    NSDate *Day2 = [formatter dateFromString:endDate];
    __block NSDate *day = Day1;
   
    
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
           dispatch_async(dispatch_get_main_queue(), ^{
            if (granted){
                //---- codes here when user allow your app to access theirs' calendar.
                //loop twice to add event to two consecutive days
                EKCalendar *cal = [eventStore defaultCalendarForNewEvents];
                for (int i=1;i<=2;i++) {
                    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                    [event setCalendar: cal];
                    [event setTitle: title];
                    [event setStartDate: day];
                    
                    NSDate *endTime = [[NSDate alloc] initWithTimeInterval:interval sinceDate:day];
                    [event setEndDate: endTime];
                    day = Day2;
                    
                    //add alarm reminder
                    if (i==1) {
                        [event addAlarm:[EKAlarm alarmWithRelativeOffset:(-60*60*24)]];
                    }
                    
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                }
                
                
                //inform user that claendar operation is complete
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"The event has been added to your calendar.  A reminder will occur one day before the event." delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK", nil ];
                
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                //[alert show];
            }
            else
            {
                //----- codes here when user NOT allow your app to access the calendar.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"The event could not be added to your calendar.  Please modify your Privacy settings to allow access to the calendar." delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK", nil ];
                
                //[alert show];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            }
           });
        }];
    }
    else {
        //ios version < 6.0
        //loop twice to add event to two consecutive days
        EKCalendar *cal = [eventStore defaultCalendarForNewEvents];
        for (int i=1;i<=2;i++) {
            EKEvent *event = [EKEvent eventWithEventStore:eventStore];
            [event setCalendar: cal];
            [event setTitle: title];
            [event setStartDate: day];
            
            NSDate *endTime = [[NSDate alloc] initWithTimeInterval:interval sinceDate:day];
            [event setEndDate: endTime];
            day = Day2;
            
            //add alarm reminder
            if (i==1) {
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:(-60*60*24)]];
            }
            
            NSError *err;
            [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
            
        }
        
        
        //inform user that claendar operation is complete
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"The event has been added to your calendar.  A reminder will occur one day before the event." delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK", nil ];
        
        [alert show];

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
