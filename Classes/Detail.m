//
//  Detail.m
//  Days
//
//  Created by dawaller on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Detail.h"
#import "GAI.h"
#import "Parser.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation Detail

NSUInteger numberOfPages;
CGRect frame;
NSArray *articles;
BOOL pageControlBeingUsed;
NSMutableArray *postTitleArray;
NSMutableArray *postUrlArray;


@synthesize item, itemTitle, itemDate, itemSummary,popover, itemUrl, shareButton, scrollView,activityIndicator,pageControl,ipadShare;

- (id)initWithItem:(NSDictionary *)theItem {  
	/*if (self = [super initWithNibName:@"Detail" bundle:nil]) {
		self.item = theItem;  
		self.title = @"48 Days Blog";  
	}  
	*/
    self.item = theItem;
	return self;  
}



- (void)viewDidLoad {  
	[super viewDidLoad];  
	
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	//self.itemTitle.text = [item objectForKey:@"title"];
    //   	[self.itemSummary loadHTMLString:[item objectForKey:@"summary"] baseURL:nil];
    
    [activityIndicator startAnimating];
    postTitleArray = [[NSMutableArray alloc] init];
    postUrlArray = [[NSMutableArray alloc] init];
    
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.itemTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.itemDate.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        
        [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
    
    if (IDIOM != IPAD) {
        UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navlogo"]];
        navBarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.navigationItem.titleView = navBarImageView;
    }
    
    pageControlBeingUsed = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator=YES;
    scrollView.delegate = self;
    
    
    activityIndicator.hidesWhenStopped = YES;
	[activityIndicator stopAnimating];
    self.pageControl.currentPage = 0;
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Blog Detail Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}


-(void) viewDidAppear:(BOOL)animated {
    Parser *rssParser = [[Parser alloc] init];
    [rssParser parseRssFeed:@"http://feeds.feedburner.com/48Days?format=xml" withDelegate:self];
    
	[super viewDidAppear:animated];
}

- (void) showArticle {
    
    UIInterfaceOrientation myOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (numberOfPages == 0) {
        [itemSummary loadHTMLString:@"<html><body><h3>There is currently no data to display.  Please check again later.</h3></body></html>" baseURL:nil];
    }

    for (int i=0;i<numberOfPages; i++) {
        
        if (UIInterfaceOrientationIsPortrait(myOrientation)) {
            frame.origin.x = self.scrollView.bounds.size.width*i;
            frame.origin.y = 60;
            frame.size.height = self.scrollView.bounds.size.height-60;
            frame.size.width = self.scrollView.bounds.size.width;
            //frame.size = self.scrollView.frame.size;
        } else if (UIInterfaceOrientationIsLandscape(myOrientation)) {
            frame.origin.x = self.scrollView.bounds.size.width*i;
            frame.origin.y = self.scrollView.bounds.size.width*0.05;
            frame.size.height = self.scrollView.bounds.size.width-15;
            frame.size.width = self.scrollView.bounds.size.width;
        }
        item = [articles objectAtIndex:i];
        
        
        NSString *title = [item objectForKey:@"title"];
        self.itemUrl = [item objectForKey:@"blogLink"];
        
        [postTitleArray addObject:title];
        [postUrlArray addObject:self.itemUrl];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        //self.itemDate.text = [dateFormatter stringFromDate:[item objectForKey:@"date"]];
        //self.itemDate.textColor = [UIColor redColor];
        NSString *pubDate = [dateFormatter stringFromDate:[item objectForKey:@"date"]];
        
        NSMutableString *blogString = [[NSMutableString alloc] init];
        blogString = [NSMutableString stringWithFormat:@"<html><head>"
                                                "<style type=\"text/css\">"
                                                "body{font:-apple-system-body;}"
                                                "h1{font: -apple-system-headline;}"
                                                "#date {font: -apple-system-caption1;}"
                                                "</style>""</head>""<body>"];
        NSString *temp =[NSString stringWithFormat:@"<h1>%@</h1>",title];
        [blogString appendString:temp];
        
        temp = [NSString stringWithFormat:@"<b style=\"color:red\" id=\"date\">%@</b>",pubDate];
        [blogString appendString:temp];
        [blogString appendString:[item objectForKey:@"summary"]];
        [blogString appendString:@"</body></html>"];
        UIWebView *view = [[UIWebView alloc] initWithFrame:frame];
        [scrollView addSubview:view];
        [view loadHTMLString:blogString baseURL:nil];
    }
}

- (void)receivedItems:(NSArray *)theItems {
    dispatch_queue_t bgQueue = dispatch_queue_create( "parser", NULL );
    dispatch_async(bgQueue, ^{
        articles = theItems;
        [activityIndicator stopAnimating];
        numberOfPages = [articles count];
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numberOfPages, scrollView.frame.size.height);
        pageControl.numberOfPages = numberOfPages;
    });
    dispatch_async(dispatch_get_main_queue(), ^{[self showArticle];
    });
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
}


- (IBAction)shareButtonTapped:(id)sender
{
    // initial text for social post
    NSString *initialText = [NSString stringWithFormat:@"%@", [postTitleArray objectAtIndex:pageControl.currentPage]];
    
    // url for social post
    NSString *postUrl = [postUrlArray objectAtIndex:pageControl.currentPage];
    NSString *tagLine = [NSString stringWithFormat:@"\nSent via 48 Days app\n\n"];
    
    UIActivityViewController* activity = [[UIActivityViewController alloc] initWithActivityItems:@[initialText, postUrl, tagLine] applicationActivities:nil];
    
   [activity setValue:[NSString stringWithFormat:@"48 Days: %@", self.itemTitle.text] forKey:@"subject"];
    
   
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        activity.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeSaveToCameraRoll];
    } else {
        activity.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    }
    
    if (IDIOM == IPAD) {
        if (popover == nil) {
            popover = [[UIPopoverController alloc] initWithContentViewController:activity];
            [popover presentPopoverFromRect:ipadShare.bounds inView:self.ipadShare permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
            //[popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [popover dismissPopoverAnimated:YES];
            popover = nil;
        }
    } else {
        [self presentViewController:activity animated:YES completion:nil];
    }
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Blog Detail Screen"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"uiAction"
                                                          action:@"buttonPress"
                                                           label:@"Share Blog Button Pressed"
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later
            //return YES;
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    }
    else
    {
        // The device is an iPhone or iPod touch.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
