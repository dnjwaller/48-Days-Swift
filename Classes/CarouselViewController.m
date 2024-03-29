//
//  CarouselViewController.m
//  Days
//
//  Created by Dan Waller on 8/18/13.
//
//

#import "CarouselViewController.h"

@interface CarouselViewController ()

@property (nonatomic, strong) NSMutableArray *items;

@end


@implementation CarouselViewController

@synthesize carousel;
@synthesize items;
@synthesize dayIndex;


- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    self.items = [NSMutableArray array];
    for (int i = 0; i < 49; i++)
    {
        [items addObject:@(i)];
    }
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    carousel.delegate = nil;
    carousel.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure carousel
    carousel.type = iCarouselTypeCoverFlow;
    //carousel.type = iCarouselTypeTimeMachine;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130.0f, 130.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"red_page.png"];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        } else {
            label.font = [label.font fontWithSize:25];
        }
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    dayIndex = index;
    if (dayIndex == 0) {
        label.text = @"Intro";
    } else {
        label.text = [NSString stringWithFormat:@"Day %@",[items[index] stringValue]];
    }
    
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)newCarousel {
    dayIndex = newCarousel.currentItemIndex;
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:dayIndex], @"day",nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newDay" object:nil userInfo:data];
}


@end