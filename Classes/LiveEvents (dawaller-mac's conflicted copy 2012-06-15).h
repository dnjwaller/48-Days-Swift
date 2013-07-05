//
//  LiveEvents.h
//  Days
//
//  Created by dawaller on 5/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LiveEvents : UIViewController
{
    IBOutlet UIImageView *eventView;
}

@property (nonatomic, retain) IBOutlet UIImageView *eventView;

- (IBAction) registerCWE:(id) sender;
- (IBAction) calendarCWE:(id) sender;
- (IBAction) registerWTB:(id) sender;
- (IBAction) calendarWTB:(id) sender;
- (IBAction) registerHours:(id) sender;
- (IBAction) calendarHours:(id) sender;

@end
