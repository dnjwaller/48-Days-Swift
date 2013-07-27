//
//  PodcastViewController.h
//  Days
//
//  Created by dawaller on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PodcastViewController : UITableViewController <UIAlertViewDelegate> {
	UIActivityIndicatorView *activityIndicator;  
	NSArray *items;  
	 BOOL netStatus;
    IBOutlet UIBarButtonItem *shareButton;
    
}

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;  
@property (strong, nonatomic) NSArray *items;  



-(void)reachable;
-(void) loadData;


@end
