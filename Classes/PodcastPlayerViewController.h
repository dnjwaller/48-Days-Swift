//
//  PodcastPlayerViewController.h
//  Days
//
//  Created by Dan Waller on 9/3/13.
//
//

#import <UIKit/UIKit.h>

@interface PodcastPlayerViewController : UIViewController {
    UIWebView *webView;
    NSURL *urlLink;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *urlLink;

- (void) setItem:(NSURL *)podcastUrl;

@end
