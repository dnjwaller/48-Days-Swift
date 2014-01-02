//
//  PodcastViewDetail.m
//  Days
//
//  Created by dawaller on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PodcastViewDetail.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "GAI.h"
#import "Parser.h"
//#import "PodcastPlayerViewController.h"

@implementation PodcastViewDetail

NSUInteger numberOfPages;
CGRect frame;
NSArray *articles;
BOOL pageControlBeingUsed;
NSMutableArray *podcastUrlArray;
NSMutableArray *podcastTitleArray;
NSMutableArray *postUrlArray;
NSURL *url;
MPMoviePlayerController *mediaPlayer;

@synthesize item, itemTitle, itemDate, itemSummary, shareButton, itemUrl, popover,scrollView,activityIndicator,pageControl,mpPlayerView,loadingLabel;
//@synthesize player, playerItem;


- (id)initWithItem:(NSDictionary *)theItem {  
	/*if (self = [super initWithNibName:@"PodcastViewDetail" bundle:nil]) {
		self.item = theItem;  
		self.title = @"";  
	}  
	*/
    self.item = theItem;
    return self;
}  


- (void)viewDidLoad {  
	[super viewDidLoad];
    
	podcastUrlArray = [[NSMutableArray alloc] init];
    podcastTitleArray = [[NSMutableArray alloc] init];
    postUrlArray = [[NSMutableArray alloc] init];
    url = [[NSURL alloc] init];
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [activityIndicator startAnimating];
    [loadingLabel setHidden:FALSE];
    
    
    UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navtitle"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
    
	self.itemTitle.text = [item objectForKey:@"title"];
    self.itemUrl = [item objectForKey:@"blogLink"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.itemDate.text = [dateFormatter stringFromDate:[item objectForKey:@"date"]];
    self.itemDate.textColor = [UIColor redColor];
    
    pageControlBeingUsed = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator=YES;
    scrollView.delegate = self;
    
    
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator stopAnimating];
    self.pageControl.currentPage = 0;

    
    if ([mediaPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [mediaPlayer.view setFrame:self.view.bounds];
            [self.itemSummary addSubview:mediaPlayer.view];
        } else {
            [mediaPlayer.view setFrame:mpPlayerView.bounds];
            [mpPlayerView addSubview:mediaPlayer.view];
        }
        
        Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
        
        if (playingInfoCenter) {
            NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
            
            MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imageNamed:@"navtitle"]];
            
            [songInfo setObject:self.itemTitle.text forKey:MPMediaItemPropertyTitle];
            [songInfo setObject:@"Dan Miller" forKey:MPMediaItemPropertyArtist];
            [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        }
        
    }
    else {
        
        
        
        [[AVAudioSession sharedInstance] setDelegate:self];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        BOOL ok;
        NSError *setCategoryError = nil;
        ok =[audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        
        if (!ok) {
            NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
        }
        else {
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            [self.itemSummary loadHTMLString:[item objectForKey:@"summary"] baseURL:nil];
        
        }
        
        
        
    }
    
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.itemTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.itemDate.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        
        [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoading) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Podcast Detail Screen"];
}


-(void) viewDidAppear:(BOOL)animated {
    Parser *rssParser = [[Parser alloc] init];
    [rssParser parseRssFeed:@"http://feeds.feedburner.com/48DaysRadio?format=xml" withDelegate:self];
    
	[super viewDidAppear:animated];
}

- (void) showArticle {
    
    UIInterfaceOrientation myOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    //No data from FeedBurner
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
            frame.origin.y = 60;
            frame.size.height = self.scrollView.bounds.size.width-135;
            frame.size.width = self.scrollView.bounds.size.width;
        }
        item = [articles objectAtIndex:i];
        
        
        NSString *title = [item objectForKey:@"title"];
        self.itemUrl = [item objectForKey:@"blogLink"];
        
        [podcastUrlArray addObject:[item objectForKey:@"podcastLink"]];
        [podcastTitleArray addObject:title];
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
    [self loadPodcast];
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
    [self loadPodcast];
}

/*
- (IBAction)playPodcast:(id)sender {  
	//UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    //AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    
    url = [NSURL URLWithString:[podcastUrlArray objectAtIndex:pageControl.currentPage]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        //mediaPlayer  = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[item objectForKey:@"podcastLink"]]];
        mediaPlayer  = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [mediaPlayer prepareToPlay];
        mediaPlayer.scalingMode = MPMovieScalingModeAspectFill;
        mediaPlayer.fullscreen = NO;
        //mediaPlayer.useApplicationAudioSession = NO;
        NSError *setCategoryError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        [mediaPlayer.view setFrame:self.view.bounds];
        
        [self.view addSubview:mediaPlayer.view];
        mediaPlayer.view.autoresizesSubviews = YES;
        mediaPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [mediaPlayer play];
   }
    else {
        // NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
        //player = [AVPlayer playerWithURL:url];
        //[player play];
   
        
        mediaPlayer  = [[MPMoviePlayerController alloc] initWithContentURL:url];
        [mediaPlayer setShouldAutoplay:NO];
        [mediaPlayer prepareToPlay];
        //mediaPlayer.scalingMode = MPMovieScalingModeAspectFill;
        mediaPlayer.fullscreen = NO;
        mediaPlayer.controlStyle = MPMovieControlStyleEmbedded;
        mediaPlayer.allowsAirPlay = YES;
        //mediaPlayer.useApplicationAudioSession = NO;
        NSError *setCategoryError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        [mediaPlayer.view setFrame:mpPlayerView.bounds];
        
        [mpPlayerView addSubview:mediaPlayer.view];
        mediaPlayer.view.autoresizesSubviews = YES;
        mediaPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
       // [mediaPlayer play];
        
    }
   
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Play Podcast Button Pressed"
                         withValue:nil];
}  
*/

- (void) loadPodcast {
    [activityIndicator startAnimating];
    [loadingLabel setHidden:FALSE];
    url = [NSURL URLWithString:[podcastUrlArray objectAtIndex:pageControl.currentPage]];
    
    mediaPlayer  = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [mediaPlayer setShouldAutoplay:NO];
    [mediaPlayer prepareToPlay];
    mediaPlayer.scalingMode = MPMovieScalingModeAspectFill;
    mediaPlayer.fullscreen = NO;
    mediaPlayer.controlStyle = MPMovieControlStyleEmbedded;
    mediaPlayer.allowsAirPlay = YES;
    [mediaPlayer.view setFrame:mpPlayerView.bounds];
    mediaPlayer.backgroundView.backgroundColor = [UIColor clearColor];
    mediaPlayer.view.backgroundColor = [UIColor clearColor];
    mpPlayerView.backgroundColor = [UIColor clearColor];
    
    [mpPlayerView addSubview:mediaPlayer.view];
    mediaPlayer.view.autoresizesSubviews = YES;
    mediaPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
}

- (void) hideLoading {
    [activityIndicator stopAnimating];
    [activityIndicator setHidden:TRUE];
    [loadingLabel setHidden:TRUE];
}


- (IBAction)shareButtonTapped:(id)sender
{
    // initial text for social post
    NSString *initialText = [NSString stringWithFormat:@"%@", [podcastTitleArray objectAtIndex:pageControl.currentPage]];
    
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
            [popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [popover dismissPopoverAnimated:YES];
            popover = nil;
        }
    } else {
        [self presentViewController:activity animated:YES completion:nil];
    }
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Share Podcast Button Pressed"
                         withValue:nil];
}

/*
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"PlayPodcast"]) {
        url = [NSURL URLWithString:[podcastUrlArray objectAtIndex:pageControl.currentPage]];
        PodcastPlayerViewController *playerVC = segue.destinationViewController;
        [playerVC setItem:url];
    }
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later
        return YES;
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
