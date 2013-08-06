//
//  HomeScreenViewController.m
//  Days
//
//  Created by Dan Waller on 7/29/13.
//
//

#import "HomeScreenViewController.h"

@interface HomeScreenViewController ()

@end


@implementation HomeScreenViewController
@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navtitle"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
