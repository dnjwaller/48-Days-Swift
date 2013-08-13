//
//  pageViewController.m
//  Days
//
//  Created by Dan Waller on 8/11/13.
//
//

#import "pageViewController.h"
#import "Detail.h"
#import "contentViewController.h"


@interface pageViewController ()
@property (readonly, strong, nonatomic) contentViewController *contentController;
@end

@implementation pageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    Detail *startingViewController = [self.contentController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = self.contentController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
