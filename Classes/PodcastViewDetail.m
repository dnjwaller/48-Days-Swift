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


@implementation PodcastViewDetail

@synthesize item, itemTitle, itemDate, itemSummary;  

MPMoviePlayerController *mediaPlayer;

- (id)initWithItem:(NSDictionary *)theItem {  
	if (self = [super initWithNibName:@"PodcastViewDetail" bundle:nil]) {  
		self.item = theItem;  
		self.title = @"48 Days Podcast";  
	}  
	
	return self;  
}  


- (void)viewDidLoad {  
	[super viewDidLoad];  
	
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	self.itemTitle.text = [item objectForKey:@"title"];  
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];  
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];  
	
	self.itemDate.text = [dateFormatter stringFromDate:[item objectForKey:@"date"]];  
	
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
}

- (IBAction)playPodcast:(id)sender {  
	//   
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        mediaPlayer  = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[item objectForKey:@"podcastLink"]]];
        
        [mediaPlayer prepareToPlay];
        mediaPlayer.scalingMode = MPMovieScalingModeAspectFill; 
        mediaPlayer.fullscreen = NO; 
        mediaPlayer.useApplicationAudioSession = NO;
        [mediaPlayer.view setFrame:self.view.bounds];
        
        [self.view addSubview:mediaPlayer.view];  
        mediaPlayer.view.autoresizesSubviews = YES;
        mediaPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [mediaPlayer play];
    }
    else {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: [item objectForKey:@"podcastLink"]]];
        [self.itemSummary loadRequest:request];
    }
	 
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
