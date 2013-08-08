//
//  PodcastViewDetail.m
//  Days
//
//  Created by dawaller on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PodcastViewDetail.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "GAI.h"


@implementation PodcastViewDetail

@synthesize item, itemTitle, itemDate, itemSummary, shareButton, itemUrl, popover;

MPMoviePlayerController *mediaPlayer;

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
	
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
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
	
    if ([mediaPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [mediaPlayer.view setFrame:self.view.bounds];
        [self.itemSummary addSubview:mediaPlayer.view];
        
    }
    else {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        BOOL ok;
        NSError *setCategoryError = nil;
        ok = [audioSession setCategory:AVAudioSessionCategoryPlayback
                                 error:&setCategoryError];
        if (!ok) {
            NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
        }

        [self.itemSummary loadHTMLString:[item objectForKey:@"summary"] baseURL:nil];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.itemTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.itemDate.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    }
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Podcast Detail Screen"];
}

- (IBAction)playPodcast:(id)sender {  
	//   
	
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
 //   {
        mediaPlayer  = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[item objectForKey:@"podcastLink"]]];
        
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
 /*   }
    else {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: [item objectForKey:@"podcastLink"]]];
        [self.itemSummary loadRequest:request];
        
        
        
    }
	*/
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Play Podcast Button Pressed"
                         withValue:nil];
}  


- (IBAction)shareButtonTapped:(id)sender
{
    // initial text for social post
    NSString *initialText = [NSString stringWithFormat:@"%@", self.itemTitle.text];
    
    // url for social post
    // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.itemUrl]];
    
    NSString *tagLine = [NSString stringWithFormat:@"\nSent via 48 Days app\n\n"];
    
    UIActivityViewController* activity = [[UIActivityViewController alloc] initWithActivityItems:@[initialText, itemUrl, tagLine] applicationActivities:nil];
    
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
