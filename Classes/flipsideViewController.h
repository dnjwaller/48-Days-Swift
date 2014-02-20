//
//  flipsideViewController.h
//  Days
//
//  Created by Dan Waller on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol flipsideViewControllerDelegate;


@interface flipsideViewController : UIViewController <UITextViewDelegate> {
	id <flipsideViewControllerDelegate> __unsafe_unretained delegate;
	IBOutlet UITextView *textField;
	CGFloat scrollAmount;
	UIScrollView *scrolLView;
}

@property (nonatomic, unsafe_unretained) id <flipsideViewControllerDelegate> delegate;
@property (nonatomic, strong) UITextView *textField;
@property (nonatomic, strong) UIScrollView *scrollView;

- (IBAction)done:(id)sender;
-(IBAction) edit:(id)sender;
@end


@protocol flipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(flipsideViewController *)controller;

@end
