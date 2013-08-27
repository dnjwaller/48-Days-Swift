//
//  CarouselViewController.h
//  Days
//
//  Created by Dan Waller on 8/18/13.
//
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"


@interface CarouselViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (assign, nonatomic) NSInteger dayIndex;

@end

