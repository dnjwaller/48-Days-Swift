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

@class LeftViewController;
@class RightViewController;

@interface DaysAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	//UITabBarController *tabBarController;
    //UITableViewController *myTableViewController;
    //UITableViewController *mySecondTableViewController;
	//UIViewController *webViewController;
	//UITableViewController *ThirdTableViewController;
	IBOutlet UIWebView *webDisplay;
	//UIViewController *infoViewController;
    //UIViewController *eventsController;
    //UIViewController *fbController;
    //UIViewController *productsController;
	NSMutableArray *viewControllers;
	IBOutlet UIButton *button;
    
    UISplitViewController *_splitViewController;
    LeftViewController *_leftViewController;
    RightViewController *_rightViewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
//@property (nonatomic, strong) UITabBarController *tabBarController;
//@property (nonatomic, strong) UITableViewController *myTableViewController;
//@property (nonatomic, strong) UITableViewController *mySecondTableViewController;
//@property (nonatomic, strong) UIViewController *webViewController;
//@property (nonatomic, strong) UITableViewController *ThirdTableViewController;
//@property (nonatomic, strong) UIViewController *infoViewController;
//@property (nonatomic, strong) UIViewController *eventsController;
//@property (nonatomic, strong) UIViewController *fbController;
//@property (nonatomic, strong) UIViewController *productsController;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, strong) IBOutlet LeftViewController *leftViewController;
@property (nonatomic, strong) IBOutlet RightViewController *rightViewController;

-(IBAction) getAd:(id)sender;


@end

