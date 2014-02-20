//
//  DaysAppDelegate.h
//  Days
//
//  Created by dawaller on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GAI.h"


@class LeftViewController;
@class RightViewController;
@class iCarouselExampleViewController;


@interface DaysAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	IBOutlet UIWebView *webDisplay;
	NSMutableArray *viewControllers;
	//IBOutlet UIButton *button;
    
    UISplitViewController *_splitViewController;
    LeftViewController *_leftViewController;
    RightViewController *_rightViewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
//@property (nonatomic, strong) IBOutlet UIButton *button;

@property (nonatomic, strong) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, strong) IBOutlet LeftViewController *leftViewController;
@property (nonatomic, strong) IBOutlet RightViewController *rightViewController;

@property(nonatomic, retain) id<GAITracker> tracker;

-(IBAction) getAd:(id)sender;


@end

