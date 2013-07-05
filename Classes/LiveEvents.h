//
//  LiveEvents.h
//  Days
//
//  Created by dawaller on 5/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>



@interface LiveEvents : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate, UIAlertViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *event1;
    IBOutlet UIImageView *event2;
    IBOutlet UIImageView *event3;
    IBOutlet UIImageView *event4;
    UIActivityIndicatorView *activityIndicator; 
    //UIAlertView *alert;
    BOOL netStatus;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *event1;
@property (nonatomic, strong) IBOutlet UIImageView *event2;
@property (nonatomic, strong) IBOutlet UIImageView *event3;
@property (nonatomic, strong) IBOutlet UIImageView *event4;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator; 


- (IBAction) registerEvent1:(id) sender;
- (IBAction) calendarEvent1:(id) sender;
- (IBAction) registerEvent2:(id) sender;
- (IBAction) calendarEvent2:(id) sender;
- (IBAction) registerEvent3:(id) sender;
- (IBAction) calendarEvent3:(id) sender;
//- (IBAction) registerEvent4:(id) sender;
//- (IBAction) calendarEvent4:(id) sender;

-(void) registerEvent;
-(void) calendarEvent;
-(void) showCalendarChoice;
-(void) addEvent:(NSString *)title start:(NSString *)startDate end:(NSString *)endDate;

@end
