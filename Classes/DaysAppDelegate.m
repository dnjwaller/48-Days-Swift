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
#import "facebookViewController.h"
#import "ProductsViewController.h"
#import "CarouselViewController.h"




@implementation DaysAppDelegate

@synthesize window, navigationController;
//@synthesize window, button, navigationController, myTableViewController, mySecondTableViewController, tabBarController, webViewController, ThirdTableViewController, infoViewController, eventsController, fbController, productsController;
@synthesize splitViewController = _splitViewController;
@synthesize leftViewController = _leftViewController;
@synthesize rightViewController = _rightViewController;
@synthesize tracker;
	

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(landscapeAd) name:@"landscapeAd" object:nil];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(portraitAd) name:@"portraitAd" object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *GADefaults = [NSDictionary dictionaryWithObject:@"YES" forKey:@"optIn"];
    [defaults registerDefaults:GADefaults];
    [defaults synchronize];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(defaultsChanged:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
    
    [self configureAnalytics];
    
    
    //check for ios 7 and set title bar color and status bar color
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1]];
        /*NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],
                                    UITextAttributeTextColor,
                                    nil];
        */
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],
                                    NSForegroundColorAttributeName,
                                    nil];

         
         [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
        [[UIBarButtonItem appearance] setTitleTextAttributes: attributes
                                                    forState: UIControlStateNormal];
    }
    else {
       // [[UITabBar appearance] setSelectedImageTintColor:[UIColor redColor]];
        [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        //[[UINavigationBar appearance] setTranslucent:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        window.tintColor = [UIColor redColor];
    }
    
    /*
   	NSURL *url = [NSURL URLWithString:@"https://sites.google.com/site/48daystheapp/examples/files/banner.png"];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image = [UIImage imageWithData:data];
	
	
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(getAd:) forControlEvents:UIControlEventTouchDown];
	[button setEnabled:YES];
        
   	button.userInteractionEnabled = YES;
	[window bringSubviewToFront:button]; */
    [window makeKeyAndVisible];      
	
}

- (void) defaultsChanged:(NSNotification *)notification {
    [self configureAnalytics];
}

- (void) configureAnalytics {
    
    BOOL optIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"optIn"];
    
    NSLog(@"OptIn: %@",optIn ? @"Yes" : @"No");
    if (optIn) {
        [[GAI sharedInstance] setOptOut:NO];
        //Google Analytics
        // Optional: automatically send uncaught exceptions to Google Analytics.
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = 120;
        // Optional: set debug to YES for extra debugging information.
        [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
        // Create tracker instance.
        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-43032381-1"];
    }
    else {
        [[GAI sharedInstance] setOptOut:YES];
        NSLog(@"No data sharing enabled.");
    }
    
}


/*
-(void) portraitAd 
{
    int height = [[UIScreen mainScreen] bounds].size.height;
    int width = [[UIScreen mainScreen] bounds].size.width;

    button.frame = CGRectMake(0,height-79,width,30);
    
}

-(void) landscapeAd 
{
    int height = [[UIScreen mainScreen] bounds].size.height;
    int width = [[UIScreen mainScreen] bounds].size.width;
    
    button.frame = CGRectMake(0,height-335,width+260,30);
}
*/


- (IBAction) getAd:(id)sender {
	NSString *launchUrl = @"https://sites.google.com/site/48daystheapp/examples/files/48days_ad.html";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
	
}


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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBlog" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePodcast" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateEvents" object:nil]; 
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

