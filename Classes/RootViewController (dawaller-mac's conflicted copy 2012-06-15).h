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
 }  

   
 @property (retain, nonatomic) UIActivityIndicatorView *activityIndicator;  
 @property (retain, nonatomic) NSArray *items;  

 
-(void)reachable;
-(void) loadData;
 @end 
