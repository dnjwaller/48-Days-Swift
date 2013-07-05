//
//  RootViewController.h
//  Days
//
//  Created by dawaller on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



 @interface RootViewController : UITableViewController <UIAlertViewDelegate> {  
     UIActivityIndicatorView *activityIndicator; 
     NSArray *items;  
	 BOOL netStatus;
     //UITableView *tableView;
 }  

   
 @property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;  
 @property (strong, nonatomic) NSArray *items;  
// @property (strong, nonatomic) UITableView *tableView;



-(void)reachable;
-(void) loadData;

 @end 
