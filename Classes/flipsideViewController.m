//
//  flipsideViewController.m
//  Days
//
//  Created by Dan Waller on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "flipsideViewController.h"
#import "GAI.h"

@implementation flipsideViewController

@synthesize delegate, textField, scrollView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
    textField.delegate = self;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//2) Create the full file path by appending the desired file name
	NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"notes.txt"];
	NSString *str = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:NULL];
	//Load the file
	textField.text = str;
	
	UIApplication *myApp = [UIApplication sharedApplication];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:myApp];
	UIImageView *navBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navlogo"]];
    navBarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navBarImageView;
    
    id<GAITracker> tracker =[[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Schedule Notes Screen"];
}

- (IBAction) edit:(id) sender {
	[self.textField becomeFirstResponder];
}


- (IBAction)done:(id)sender {
	[self.textField resignFirstResponder];
	//[self.delegate flipsideViewControllerDidFinish:self];
    
  	
    [self writeFile];
    
    if (IDIOM == IPAD) {
        NSLog(@"ipad");
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) writeFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//2) Create the full file path by appending the desired file name
	NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"notes.txt"];
	NSString *str = textField.text;
	
	[str writeToFile:fileName atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
}


- (void) viewWillAppear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWasShown:) 
												 name:UIKeyboardDidShowNotification object:nil];
	[super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:UIKeyboardDidShowNotification object:nil];
	[super viewWillDisappear:animated];
    [self writeFile];
}


- (void)textViewDidChange:(UITextView *)textView {
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}

// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification

{
    NSDictionary* info = [aNotification userInfo];
	
    //UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
   // CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? kbSize.width : kbSize.height;
    
    //textField.frame = CGRectMake(0, 45,self.view.frame.size.width, self.view.frame.size.height - keyboardHeight-100);
    
    

	float bottomPoint = (textField.frame.origin.y + textField.frame.size.height + 10);
	scrollAmount = kbSize.height - (self.view.frame.size.height - bottomPoint);
    //UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, scrollAmount, 0.0);
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
	
    scrollView.scrollIndicatorInsets = contentInsets;
	
	
    // If active text field is hidden by keyboard, scroll it so it's visible
	
    // Your application might not need or want this behavior.
	
    CGRect aRect = self.view.frame;

    
	
  /*  
    if (!CGRectContainsPoint(aRect, textField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, textField.frame.origin.y - (kbSize.height-15));
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
   */
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationIsPortrait(orientation)) {
        aRect.size.height -= kbSize.height;
        [textField setFrame:CGRectMake(0, 40, aRect.size.width, aRect.size.height-50)];
        if (!CGRectContainsPoint(aRect, self.textField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, self.textField.frame.origin.y-kbSize.height);
            [scrollView setContentOffset:scrollPoint animated:YES];
            
        }
    }
    else {
        aRect.size.width -= kbSize.width;
        [textField setFrame:CGRectMake(0,40,aRect.size.height,aRect.size.width -60)];
        if (!CGRectContainsPoint(aRect, self.textField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, self.textField.frame.origin.x-kbSize.height);
            [scrollView setContentOffset:scrollPoint animated:YES];
            
        }
    }
  
  
}





// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	
    scrollView.contentInset = contentInsets;
	
    scrollView.scrollIndicatorInsets = contentInsets;
	
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

- (void)applicationWillTerminate:(UIApplication *)application {
	[self writeFile];
}


- (void)viewDidUnload {
	
    [super viewDidUnload];
    [self writeFile];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
