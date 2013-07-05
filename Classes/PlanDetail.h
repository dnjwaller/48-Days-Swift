//
//  PlanDetail.h
//  Days
//
//  Created by dawaller on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "flipsideViewController.h"


@interface PlanDetail : UIViewController <flipsideViewControllerDelegate>{
	NSDictionary *item;  
	IBOutlet UILabel *itemTitle;  
	IBOutlet UILabel *itemDate;
	IBOutlet UIWebView *itemSummary; 
	NSUInteger row;
	
	//IBOutlet UISegmentedControl *Segment;
	//NSMutableArray *completed;
	}  
	
	@property (strong, nonatomic) NSDictionary *item;  
	//@property (retain, nonatomic) NSMutableArray *completed;
	
	@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
    @property (strong, nonatomic) IBOutlet UILabel *itemDate;
	@property (strong, nonatomic) IBOutlet UIWebView *itemSummary; 
	
	- (id)initWithItem:(NSDictionary *)theItem;  
- (IBAction) isComplete:(id)sender;
- (IBAction)showInfo:(id)sender;

@end


