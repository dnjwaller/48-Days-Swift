//
//  DaysAppDelegate.m
//  Days
//
//  Created by dawaller on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DaysAppDelegate.h"
#import "RootViewController.h"
#import "PodcastViewController.h"
#import "NetWebViewController.h"
#import "PlanViewController.h"
#import "infoView.h"
#import "LiveEvents.h"




@implementation DaysAppDelegate

@synthesize window, button, navigationController, myTableViewController, mySecondTableViewController, tabBarController, webViewController, ThirdTableViewController, infoViewController, eventsController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {

	tabBarController = [[UITabBarController alloc] init];          // creates your tab bar so you can add everything else to it
	
	
	myTableViewController = [[RootViewController alloc] init];               // creates your table view - this should be a UIViewController with a table view in it, or UITableViewController
	UINavigationController *tableNavController = [[[UINavigationController alloc] initWithRootViewController:myTableViewController] autorelease];
	tableNavController.navigationBar.tintColor = [UIColor colorWithRed:0.65 green:0.0 blue:0.0 alpha:0.0];
	tableNavController.tabBarItem.title = @"Blogs";
	tableNavController.tabBarItem.image = [UIImage imageNamed:@"newspaper.png"];
	[myTableViewController release];                                                              // creates your table view's navigation controller, then adds the view controller you made. Note I then let go of the view controller as the navigation controller now holds onto it for me. This saves memory.
	
	mySecondTableViewController = [[PodcastViewController alloc] init];   
	UINavigationController *table2NavController = [[[UINavigationController alloc] initWithRootViewController:mySecondTableViewController] autorelease];
	table2NavController.navigationBar.tintColor = [UIColor colorWithRed:0.65 green:0.0 blue:0.0 alpha:0.0];
	table2NavController.tabBarItem.title = @"Podcast";
	table2NavController.tabBarItem.image = [UIImage imageNamed:@"microphone.png"];
	[mySecondTableViewController release];                                                    // does exactly the same as the first round, but for your second tab at the bottom of the bar.
	
	webViewController = [[NetWebViewController alloc] init];
	UINavigationController *webView = [[[UINavigationController alloc] initWithRootViewController:webViewController] autorelease];
	webView.navigationBar.tintColor = [UIColor colorWithRed:0.65 green:0.0 blue:0.0 alpha:0.0];
	webView.tabBarItem.title = @"Community";
	webView.tabBarItem.image = [UIImage imageNamed:@"group.png"];
	[webViewController release];
	
	ThirdTableViewController = [[PlanViewController alloc] init];
	UINavigationController *table3NavController = [[[UINavigationController alloc] initWithRootViewController:ThirdTableViewController] autorelease];
	table3NavController.navigationBar.tintColor = [UIColor colorWithRed:0.65 green:0.0 blue:0.0 alpha:0.0];
	table3NavController.tabBarItem.title = @"Schedule";
	table3NavController.tabBarItem.image = [UIImage imageNamed:@"notepad.png"];
	[ThirdTableViewController release];
	
/*	infoViewController = [[infoView alloc] init];
	UINavigationController *fifthView = [[[UINavigationController alloc] initWithRootViewController:infoViewController] autorelease];
	fifthView.navigationBar.tintColor = [UIColor colorWithRed:0.65 green:0.0 blue:0.0 alpha:0.0];
	fifthView.tabBarItem.title = @"Info";
	fifthView.tabBarItem.image = [UIImage imageNamed:@"star.png"];
	[infoViewController release];*/
    
    eventsController = [[LiveEvents alloc] init];
	UINavigationController *sixthView = [[[UINavigationController alloc] initWithRootViewController:eventsController] autorelease];
	sixthView.navigationBar.tintColor = [UIColor colorWithRed:0.65 green:0.0 blue:0.0 alpha:0.0];
	sixthView.tabBarItem.title = @"Info";
	sixthView.tabBarItem.image = [UIImage imageNamed:@"star.png"];
	[eventsController release];
	
	
	tabBarController.viewControllers = [NSArray arrayWithObjects:tableNavController, table2NavController,webView, table3NavController,sixthView, nil]; //add both of your navigation controllers to the tab bar. You can put as many controllers on as you like, but they will turn into the more button like in the iPod program.

	NSURL *url = [NSURL URLWithString:@"https://sites.google.com/site/48daystheapp/examples/files/banner.png"];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image = [UIImage imageWithData:data];
	
	
	
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(getAd:) forControlEvents:UIControlEventTouchDown];
	[button setEnabled:YES];
	button.frame = CGRectMake(0,402, 320, 30);
	
	button.userInteractionEnabled = YES;

	
	//add the tabcotroller as a subview of the view
	[tabBarController.view  addSubview:button];
	
	
	[window bringSubviewToFront:button];	
	[window addSubview:tabBarController.view];                                              // adds the tab bar's view property to the window
	[window makeKeyAndVisible];      
	
}



- (IBAction) getAd:(id)sender {
	NSString *launchUrl = @"https://sites.google.com/site/48daystheapp/examples/files/48days_ad.html";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
	
}


- (void)dealloc {
	[myTableViewController release];
	[mySecondTableViewController release];
	[tabBarController release];
	[webViewController release];
	[ThirdTableViewController release];
	[infoViewController release];
	[tabBarController release];
	//[bannerLogoView release];
	[window release];
	[super dealloc];
}                                           // lets go of everything else, thats so your program doesn't create any leaks of memory.





#pragma mark -
#pragma mark Application lifecycle
/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

    return YES;
}

*/
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    RootViewController *blogResume = [[RootViewController alloc]init];
    [blogResume loadData];
    
    PodcastViewController *podcastResume = [[PodcastViewController alloc]init];
    [podcastResume loadData];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

@end

