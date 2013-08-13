//
//  pageAppViewController.h
//  Days
//
//  Created by Dan Waller on 8/11/13.
//
//

#import <UIKit/UIKit.h>
#import "contentViewController.h"

@interface pageAppViewController : UIViewController
<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    UIPageViewController *pageController;
    NSArray *pageContent;
}
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;
@end