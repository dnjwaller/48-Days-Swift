//
//  PodcastPlayerViewController.m
//  Days
//
//  Created by Dan Waller on 9/3/13.
//
//

#import "PodcastPlayerViewController.h"

@interface PodcastPlayerViewController ()

@end

@implementation PodcastPlayerViewController

@synthesize webView,urlLink;


- (void) setItem:(NSURL *) podcastUrl {
    urlLink = podcastUrl;
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
     NSLog(@"url: %@",urlLink);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: urlLink];
    [webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
