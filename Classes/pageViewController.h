//
//  pageViewController.h
//  Days
//
//  Created by Dan Waller on 8/11/13.
//
//

#import <UIKit/UIKit.h>
#import "Detail.h"

@interface pageViewController : UIViewController <UIPageViewControllerDelegate> {

Detail *detailPageDataSource;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
