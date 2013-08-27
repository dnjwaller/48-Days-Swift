//
//  PlanCarouselViewController.m
//  Days
//
//  Created by Dan Waller on 8/18/13.
//
//

#import "PlanCarouselViewController.h"


@interface PlanCarouselViewController ()

@end


@implementation PlanCarouselViewController
@synthesize carousel, planDetail;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navtitle"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
