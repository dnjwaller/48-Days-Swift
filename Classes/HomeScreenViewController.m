//
//  HomeScreenViewController.m
//  Days
//
//  Created by Dan Waller on 7/29/13.
//
//

#import "HomeScreenViewController.h"
#import "Detail.h"
#import "PodcastViewDetail.h"
#import "NetWebViewController.h"
#import "PlanCarouselViewController.h"
#import "infoView.h"
#import "LiveEvents.h"
#import "facebookViewController.h"


@interface HomeScreenViewController ()

@end


@implementation HomeScreenViewController
@synthesize webView,button;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navlogo"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
    
    self.detailVC = (DetailViewController *)[self.splitViewController.viewControllers lastObject];
    
    NSURL *url = [NSURL URLWithString:@"https://sites.google.com/site/48daystheapp/examples/files/banner.png"];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image = [UIImage imageWithData:data];

    [button setImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(getAd:) forControlEvents:UIControlEventTouchUpInside];
	[button setEnabled:YES];

}

- (IBAction) getAd:(id)sender {
	NSString *launchUrl = @"https://sites.google.com/site/48daystheapp/examples/files/48days_ad.html";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
	
}



/*
-(IBAction)detailViewSelect:(UIButton*)sender {
    UIViewController  *tempVC = nil;
    
    switch (sender.tag) {
        case 1:
        {
            Detail *blogVC = [[Detail alloc] init];
            tempVC = blogVC;
            break;
        }
        case 2:
        {
            PodcastViewDetail *podcastVC = [[PodcastViewDetail alloc] init];
            tempVC = podcastVC;
            break;
        }
        case 3:
        {
            NetWebViewController *netVC = [[NetWebViewController alloc] init];
            tempVC = netVC;
            break;
        }
        case 4:
        {
            PlanCarouselViewController *planVC = [[PlanCarouselViewController alloc] init];
            tempVC = planVC;
            break;
        }
        case 5:
        {
            LiveEvents *liveVC = [[LiveEvents alloc] init];
            tempVC = liveVC;
            break;
        }
        case 6:
        {
            facebookViewController *fbVC = [[facebookViewController alloc] init];
            tempVC = fbVC;
            break;
        }
        case 7:
        {
            infoView *infoVC = [[infoView alloc] init];
            tempVC = infoVC;
            break;
        }   
        default:
            break;
    }
    self.detailVC = (tempVC *)[[self.splitViewController.viewControllers lastObject]];
}

*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
