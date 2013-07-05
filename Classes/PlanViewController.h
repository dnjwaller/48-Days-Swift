//
//  PlanViewController.h
//  Days
//
//  Created by dawaller on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlanViewController : UITableViewController <NSXMLParserDelegate> {
	UIActivityIndicatorView *activityIndicator;  
	NSArray *items;  
	NSXMLParser *parser;
	NSMutableArray *complete;
	NSInteger *selectedRow;
	NSString *status;
	NSUInteger row;
}


@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;  
@property (strong, nonatomic) NSArray *items;  
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSMutableArray *complete;



@end
