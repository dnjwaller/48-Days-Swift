//
//  PlanCarouselViewController.h
//  Days
//
//  Created by Dan Waller on 8/18/13.
//
//

#import <UIKit/UIKit.h>
#import "CarouselViewController.h"
#import "PlanDetail.h"


@interface PlanCarouselViewController : UIViewController

@property (strong, nonatomic) CarouselViewController *carousel;
@property (strong, nonatomic) PlanDetail *planDetail;

@end
