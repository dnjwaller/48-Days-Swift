//
//  Detail.h
//  Days
//
//  Created by dawaller on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Detail : UIViewController {
	NSDictionary *item;  
	IBOutlet UILabel *itemTitle;  
	IBOutlet UILabel *itemDate;  
	IBOutlet UIWebView *itemSummary;  
    IBOutlet UIBarButtonItem *shareButton;
}

@property (strong, nonatomic) NSDictionary *item;  
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;  
@property (strong, nonatomic) IBOutlet UILabel *itemDate;  
@property (strong, nonatomic) IBOutlet UIWebView *itemSummary;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) NSURL *itemUrl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;

- (id)initWithItem:(NSDictionary *)theItem;  

//- (IBAction)playPodcast:(id)sender;


@end
