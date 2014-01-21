//
//  HomeScreenViewController.h
//  Days
//
//  Created by Dan Waller on 7/29/13.
//
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface HomeScreenViewController : UIViewController {
    UIWebView *webView;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) DetailViewController *detailVC;

@end
